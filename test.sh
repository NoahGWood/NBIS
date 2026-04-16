x86_64-w64-mingw32-g++ test.cpp \
    -Iartifacts/windows/include \
    -Icompat \
    ./artifacts/windows/lib/libwsq.a \
    ./artifacts/windows/lib/libimage.a \
    ./artifacts/windows/lib/libihead.a \
    ./artifacts/windows/lib/libioutil.a \
    ./artifacts/windows/lib/libjpegl.a \
    ./artifacts/windows/lib/libfet.a \
    ./artifacts/windows/lib/libutil.a \
    -static -static-libgcc -static-libstdc++ \
    -o test.exe

g++ test.cpp \
    -Iartifacts/linux/include \
    ./artifacts/linux/lib/libwsq.a \
    ./artifacts/linux/lib/libimage.a \
    ./artifacts/linux/lib/libihead.a \
    ./artifacts/linux/lib/libioutil.a \
    ./artifacts/linux/lib/libjpegl.a \
    ./artifacts/linux/lib/libfet.a \
    ./artifacts/linux/lib/libutil.a \
    -o test_executable
