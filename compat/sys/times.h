// platform_compat.h
#pragma once

#ifdef _WIN32

#include <time.h>

/* Fake POSIX timing */
struct tms {
    clock_t tms_utime;
    clock_t tms_stime;
    clock_t tms_cutime;
    clock_t tms_cstime;
};

static inline int times(struct tms *buf) {
    if (buf) {
        clock_t c = clock();
        buf->tms_utime = c;
        buf->tms_stime = 0;
        buf->tms_cutime = 0;
        buf->tms_cstime = 0;
    }
    return 0;
}

#ifndef _SC_CLK_TCK
#define _SC_CLK_TCK 2
#endif

static inline long sysconf(int name) {
    return CLOCKS_PER_SEC;
}

#endif