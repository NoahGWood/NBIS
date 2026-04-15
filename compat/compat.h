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
#ifdef max
#undef max
#endif
#ifdef min
#undef min
#endif


#endif