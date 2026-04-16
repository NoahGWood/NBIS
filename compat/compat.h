#pragma once

/* Pull in REAL system headers first */
#include <sys/stat.h>

#ifdef _WIN32

#include <direct.h>

/* mkdir signature fix */
#ifndef mkdir
#define mkdir(path, mode) _mkdir(path)
#endif

/* safety */
#ifndef max
#define max(a,b) ((a) > (b) ? (a) : (b))
#endif

#ifndef min
#define min(a,b) ((a) < (b) ? (a) : (b))
#endif

#endif