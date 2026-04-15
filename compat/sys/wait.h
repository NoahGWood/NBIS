#ifdef _WIN32

/* sys/wait.h replacement */
#include <sys/types.h>

static inline int wait(int *status) {
    return -1;
}

static inline int waitpid(pid_t pid, int *status, int options) {
    return -1;
}

static inline pid_t fork(void) {
    return -1;  // pretend failure
}
#endif