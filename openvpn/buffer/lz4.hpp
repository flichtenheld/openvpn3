//    OpenVPN -- An application to securely tunnel IP networks
//               over a single port, with support for SSL/TLS-based
//               session authentication and key exchange,
//               packet encryption, packet authentication, and
//               packet compression.
//
//    Copyright (C) 2012- OpenVPN Inc.
//
//    SPDX-License-Identifier: MPL-2.0 OR AGPL-3.0-only WITH openvpn3-openssl-exception
//

#pragma once

#include <cstdint> // for std::uint32_t, uint64_t, etc.

#include <lz4.h>

#include <openvpn/common/clamp_typerange.hpp>
#include <openvpn/common/exception.hpp>
#include <openvpn/common/socktypes.hpp> // for ntohl/htonl
#include <openvpn/buffer/buffer.hpp>

using openvpn::numeric_util::clamp_to_typerange;

namespace openvpn::LZ4 {

OPENVPN_EXCEPTION(lz4_error);

inline BufferPtr compress(const ConstBuffer &src,
                          const size_t headroom,
                          const size_t tailroom)
{
    // sanity check
    if (src.size() > LZ4_MAX_INPUT_SIZE)
        OPENVPN_THROW(lz4_error, "compress buffer size=" << src.size() << " exceeds LZ4_MAX_INPUT_SIZE=" << LZ4_MAX_INPUT_SIZE);

    // allocate dest buffer
    auto dest = BufferAllocatedRc::Create(sizeof(std::uint32_t) + headroom + tailroom + LZ4_COMPRESSBOUND(src.size()));
    dest->init_headroom(headroom);

    // as a hint to receiver, write the decompressed size
    {
        const std::uint32_t size = htonl(clamp_to_typerange<uint32_t>(src.size()));
        dest->write(&size, sizeof(size));
    }

    // compress
    const int comp_size = ::LZ4_compress_default((const char *)src.c_data(),
                                                 (char *)dest->data_end(),
                                                 (int)src.size(),
                                                 (int)dest->remaining(tailroom));
    if (comp_size <= 0)
        OPENVPN_THROW(lz4_error, "LZ4_compress_default returned error status=" << comp_size);
    dest->inc_size(comp_size);
    return dest;
}

inline BufferPtr decompress(const ConstBuffer &source,
                            const size_t headroom,
                            const size_t tailroom,
                            size_t max_decompressed_size = LZ4_MAX_INPUT_SIZE)
{
    // get the decompressed size
    ConstBuffer src(source);
    if (src.size() < sizeof(std::uint32_t))
        OPENVPN_THROW(lz4_error, "decompress buffer size=" << src.size() << " is too small");
    std::uint32_t size;
    src.read(&size, sizeof(size));
    size = ntohl(size);
    if (max_decompressed_size > LZ4_MAX_INPUT_SIZE)
        max_decompressed_size = LZ4_MAX_INPUT_SIZE;
    if (max_decompressed_size && size > max_decompressed_size)
        OPENVPN_THROW(lz4_error, "decompress expansion size=" << size << " is too large (must be <= " << max_decompressed_size << ')');

    // allocate dest buffer
    auto dest = BufferAllocatedRc::Create(headroom + tailroom + size);
    dest->init_headroom(headroom);

    // decompress
    const int decomp_size = LZ4_decompress_safe((const char *)src.c_data(),
                                                (char *)dest->data(),
                                                (int)src.size(),
                                                size);
    if (decomp_size <= 0)
        OPENVPN_THROW(lz4_error, "LZ4_decompress_safe returned error status=" << decomp_size);
    if (static_cast<unsigned int>(decomp_size) != size)
        OPENVPN_THROW(lz4_error, "decompress size inconsistency expected_size=" << size << " actual_size=" << decomp_size);
    dest->inc_size(decomp_size);
    return dest;
}

} // namespace openvpn::LZ4
