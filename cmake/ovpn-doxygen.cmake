option(ENABLE_DOXYGEN "Build code documentation with Doxygen")


function(configure_doxygen projname outputdir)
    find_package(Doxygen
                 REQUIRED dot)

    # OpenVPN Logo
    file(WRITE
            "${CMAKE_CURRENT_BINARY_DIR}/doxygen/openvpn-logo.svg"
            "<svg xmlns='http://www.w3.org/2000/svg' width='131' height='40' viewBox='0 0 131 40' fill='none'><path fill-rule='evenodd' clip-rule='evenodd' d='M121.849 12.8604H123.949H123.959C124.019 12.8616 124.076 12.885 124.119 12.926C124.164 12.9693 124.19 13.0286 124.19 13.0905V27.2404C124.19 27.3729 124.08 27.4803 123.944 27.4803H122.08V27.446L115.934 17.1102V27.2404C115.934 27.3729 115.824 27.4803 115.688 27.4803H113.558C113.495 27.4803 113.434 27.4554 113.39 27.4112C113.345 27.3669 113.321 27.3071 113.322 27.2453V13.1737C113.321 13.0902 113.354 13.0098 113.415 12.9507C113.475 12.8916 113.558 12.8591 113.643 12.8604H116.23L121.603 21.8742V13.1003C121.603 12.9678 121.713 12.8604 121.849 12.8604ZM100.98 13.1591V27.2257C100.98 27.3636 101.095 27.4754 101.236 27.4754H104.008C104.141 27.4754 104.249 27.3702 104.249 27.2404V21.8253H107.256C107.256 21.8253 111.362 21.6147 111.362 17.3208C111.362 13.0269 107.201 12.88 107.201 12.88H101.286C101.207 12.873 101.128 12.8995 101.069 12.9528C101.011 13.006 100.979 13.0811 100.98 13.1591ZM106.354 15.0831C106.959 15.0679 107.543 15.3067 107.957 15.7389C108.37 16.1712 108.575 16.7558 108.519 17.3451C108.558 17.9299 108.347 18.5042 107.937 18.9318C107.527 19.3594 106.954 19.6021 106.354 19.6022H104.193V15.23C104.193 15.0341 104.344 15.0586 104.344 15.0586L106.354 15.0831ZM93.4565 27.3041L98.8351 13.1983C98.8635 13.1251 98.8528 13.043 98.8065 12.9792C98.7603 12.9154 98.6846 12.8782 98.6045 12.88H96.1934C96.0922 12.8805 96.0013 12.9404 95.9628 13.0318L92.4539 22.2757L88.92 13.0318C88.8845 12.9403 88.7946 12.8798 88.6944 12.88H86.2833C86.2033 12.8782 86.1276 12.9154 86.0813 12.9792C86.0351 13.043 86.0244 13.1251 86.0527 13.1983L91.4314 27.3041C91.4693 27.3965 91.56 27.4581 91.6619 27.4607H93.2409C93.3448 27.4601 93.4379 27.3982 93.4765 27.3041H93.4565ZM12.0907 16.6072C13.9596 16.8309 15.3615 18.3852 15.3532 20.2242C15.351 21.7162 14.4114 23.0538 12.9872 23.5928L14.3908 31.0398H8.91187L10.3405 23.6075C8.57637 22.9646 7.58375 21.1342 8.03044 19.3476C8.47713 17.561 10.2218 16.3835 12.0907 16.6072Z' fill='#1A3967'></path><path class='ov-orange' fill-rule='evenodd' clip-rule='evenodd' d='M11.7072 8.95996C18.0798 8.95996 23.2825 13.9376 23.4143 20.1607C23.4177 24.2068 21.2081 27.9464 17.6196 29.9677L16.8728 25.1156C18.0433 23.8769 18.693 22.2528 18.6924 20.5671C18.591 16.8702 15.4935 13.9247 11.7072 13.9247C7.92085 13.9247 4.82337 16.8702 4.72196 20.5671C4.72155 22.2395 5.36169 23.8515 6.51651 25.0862L5.76461 29.953C2.19541 27.924 -0.000133845 24.1944 6.11979e-09 20.1607C0.131844 13.9376 5.33451 8.95996 11.7072 8.95996ZM31.5001 20.1284C31.4789 24.2511 34.8785 27.6124 39.0993 27.6421C41.136 27.6499 43.0925 26.8671 44.5383 25.4659C45.9841 24.0647 46.8008 22.1599 46.8088 20.1706C46.8115 16.0479 43.3968 12.7011 39.176 12.6895C34.9552 12.6779 31.5213 16.0057 31.5001 20.1284ZM43.2995 20.1476C43.3124 22.4281 41.4336 24.2887 39.0989 24.3075C37.9707 24.3127 36.8866 23.8796 36.0855 23.1036C35.2845 22.3276 34.8321 21.2723 34.8281 20.1703C34.8282 17.8898 36.7175 16.0395 39.0523 16.0332C41.387 16.027 43.2867 17.8672 43.2995 20.1476ZM48.4337 27.2257V13.1591C48.4319 13.0811 48.4643 13.006 48.5227 12.9528C48.581 12.8995 48.6599 12.873 48.7394 12.88H54.6494C54.6494 12.88 58.815 13.0269 58.815 17.3208C58.815 21.6147 54.7096 21.8253 54.7096 21.8253H51.727V27.2404C51.7243 27.3691 51.6182 27.4728 51.4864 27.4754H48.6893C48.5481 27.4754 48.4337 27.3636 48.4337 27.2257ZM55.4084 15.7391C54.9953 15.3066 54.4122 15.0678 53.8069 15.0831L51.7968 15.0586C51.7968 15.0586 51.6464 15.0341 51.6464 15.23V19.6022H53.8069C54.4064 19.6022 54.9791 19.3594 55.3886 18.9316C55.798 18.5038 56.0076 17.9294 55.9674 17.3451C56.025 16.7563 55.8214 16.1716 55.4084 15.7391ZM60.6488 27.4754C60.5159 27.4754 60.4082 27.3702 60.4082 27.2404V13.1003C60.4082 13.0371 60.4342 12.9766 60.4804 12.9324C60.5267 12.8881 60.5891 12.864 60.6538 12.8653H70.594C70.7305 12.8653 70.8419 12.9719 70.8447 13.1052V15.1616C70.8447 15.2248 70.8186 15.2853 70.7724 15.3295C70.7262 15.3737 70.6637 15.3979 70.599 15.3966H63.862C63.7302 15.3992 63.624 15.5029 63.6213 15.6316V18.4028C63.6213 18.5326 63.7291 18.6378 63.862 18.6378H68.3132C68.3775 18.6365 68.4395 18.6608 68.4849 18.7052C68.5303 18.7496 68.5552 18.8101 68.5539 18.8729V20.939C68.5539 21.0009 68.5284 21.0602 68.4831 21.1035C68.4378 21.1468 68.3766 21.1705 68.3132 21.1691H63.862C63.7302 21.1717 63.624 21.2755 63.6213 21.4042V24.7091C63.6241 24.8369 63.731 24.9392 63.862 24.9392H70.599C70.7328 24.9392 70.8419 25.0436 70.8447 25.1742V27.2404C70.8447 27.3036 70.8186 27.3641 70.7724 27.4083C70.7262 27.4525 70.6637 27.4767 70.599 27.4754H60.6488ZM83.4322 12.8751H81.3319C81.1962 12.8751 81.0863 12.9825 81.0863 13.115V21.8889L75.7126 12.8751H73.1161C72.9547 12.875 72.8231 13.0014 72.8203 13.159V27.2599C72.8203 27.3897 72.928 27.4949 73.0609 27.4949H75.1863C75.2523 27.4963 75.3161 27.4716 75.3632 27.4264C75.4104 27.3813 75.437 27.3195 75.437 27.255V17.1249L81.5625 27.4607V27.4949H83.4272C83.4923 27.4949 83.5548 27.4697 83.6009 27.4247C83.6469 27.3797 83.6728 27.3187 83.6728 27.255V13.1052C83.6728 13.0433 83.6473 12.984 83.6021 12.9407C83.5592 12.8997 83.502 12.8763 83.4423 12.8751H83.4322Z' fill='#ED7F22'></path><path fill-rule='evenodd' clip-rule='evenodd' d='M130.221 13.0656C130.221 13.9802 129.47 14.7216 128.543 14.7216C127.617 14.7216 126.866 13.9802 126.866 13.0656C126.866 12.151 127.617 11.4096 128.543 11.4096C129.47 11.4096 130.221 12.151 130.221 13.0656ZM130.407 13.0656C130.407 14.0818 129.573 14.9056 128.543 14.9056C127.514 14.9056 126.68 14.0818 126.68 13.0656C126.68 12.0494 127.514 11.2256 128.543 11.2256C129.573 11.2256 130.407 12.0494 130.407 13.0656ZM128.44 13.3394L128.964 14.1696H129.346L128.794 13.3247C128.969 13.2952 129.103 13.2285 129.194 13.1245C129.288 13.0204 129.334 12.887 129.334 12.7241C129.334 12.5337 129.272 12.3806 129.146 12.2648C129.023 12.149 128.841 12.0911 128.601 12.0911H127.858V14.1696H128.198V13.3394H128.44ZM128.574 13.1009H128.198V12.3796H128.574C128.715 12.3796 128.818 12.412 128.884 12.4768C128.952 12.5396 128.985 12.6279 128.985 12.7417C128.985 12.9812 128.848 13.1009 128.574 13.1009Z' fill='#1A3967'></path></svg>")

    set(DOXYGEN_PROJECT_NAME "${projname}")
    set(DOXYGEN_PROJECT_LOGO "${CMAKE_CURRENT_BINARY_DIR}/doxygen/openvpn-logo.svg")
    set(DOXYGEN_PROJECT_NUMBER "")
    set(DOXYGEN_OUTPUT_DIRECTORY "${outputdir}")
    set(DOXYGEN_GENERATE_HTML YES)
    set(DOXYGEN_EXTRACT_ALL YES)
    set(DOXYGEN_EXTRACT_PRIVATE YES)
    set(DOXYGEN_EXTRACT_STATIC YES)
    set(DOXYGEN_SOURCE_BROWSER YES)
    set(DOXYGEN_NUM_PROC_THREADS 0)
    set(DOXYGEN_CALL_GRAPH "NO" CACHE STRING "Generate call graph images (value: YES/NO)")
    set(DOXYGEN_CALLER_GRAPH "YES" CACHE STRING "Generate caller graph images (value: YES/NO)")
    set(DOXYGEN_FILE_PATTERNS *.c *.h *.cc *.hh *.cpp *.hpp *.java *.i *.md *.txt)
    set(DOXYGEN_EXTENSION_MAPPING txt=md)
    set(DOXYGEN_DOT_GRAPH_MAX_NODES 500)
    set(DOXYGEN_WARN_AS_ERROR YES)

    doxygen_add_docs(doxygen ALL
        "${DOXYGEN_USE_MDFILE_AS_MAINPAGE}" "${CMAKE_CURRENT_SOURCE_DIR}"
        WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
        COMMENT "Generate Doxygen documentation")
endfunction ()
