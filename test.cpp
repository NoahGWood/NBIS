#include <vector>
#include <cstdint>

extern "C" {
    int wsq_decode_mem(
        unsigned char **odata,
        int *ow, int *oh, int *od, int *ppi, int *lossy,
        unsigned char *idata,
        const int ilen
    );
}

int main() {
    return 0;
}