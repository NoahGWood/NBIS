x86_64-w64-mingw32-g++ test.cpp -Lartifacts/windows/lib   -lwsq -limage -lihead -o test.exe
gcc test.cpp -Lartifacts/linux/lib/libnbis.a -o test_executable