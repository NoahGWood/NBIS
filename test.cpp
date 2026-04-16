#include <iostream>
#include <cstdint>
extern "C" {
    int debug = 0;
#include <wsq.h>
#include <util.h>
#include <ihead.h>
}

int main() {
    // Give it a tiny fake buffer so the pointers aren't NULL
    unsigned char fake_buffer[10] = {0xFF, 0xD8, 0xFF, 0xA0, 0, 0, 0, 0, 0, 0}; 
    int len = 10;

    unsigned char* out = nullptr;
    int w, h, d, ppi, lossy;

    std::cout << "Attempting to call wsq_decode_mem with fake data..." << std::endl;

    // This should now return a non-zero error code (like -1 for "marker not found")
    // instead of crashing, because cbufptr is no longer NULL.
    int ret = wsq_decode_mem(&out, &w, &h, &d, &ppi, &lossy, fake_buffer, len);

    std::cout << "Library returned: " << ret << std::endl;

    return 0;
}