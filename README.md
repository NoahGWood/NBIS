# NBIS Cross-Compilation (Linux → Windows) – Minimal WSQ Build

This repo contains a patched build workflow for compiling a **minimal subset of NBIS** (NIST Biometric Image Software) for **Windows (x86_64)** from a Linux host.

The goal is **not** to build the full NBIS toolchain (which is heavily Unix-dependent), but instead to extract usable static libraries—primarily:

* `libwsq.a` (WSQ fingerprint decoder)
* Supporting libraries (`libimage.a`, `libihead.a`, etc.)

---

## Overview

NBIS is:

* Unix-centric
* Built with legacy Makefiles
* Not designed for cross-compilation

This build system works by:

* Cross-compiling with MinGW (`x86_64-w64-mingw32-*`)
* Injecting a **compatibility layer** (no source modification)
* Skipping all **non-portable CLI binaries**
* Extracting only **static libraries**

---

## Output

After a successful build:

```
artifacts/linux/
  ├── lib/
  │   ├── libnbis.a
artifacts/windows/
  ├── lib/
  │   ├── libwsq.a
  │   ├── libimage.a
  │   ├── libihead.a
  │   └── ...
  └── include/
```

---

## Requirements

* Linux environment
* MinGW toolchain:

  ```bash
  sudo apt install mingw-w64
  ```

---

## Key Design Decisions

### Do NOT build binaries

NBIS CLI tools rely on:

* `fork()`
* `wait()`
* POSIX process model

These do not work on Windows.

#### We only build **libraries**

---

### No source modification

All compatibility fixes are handled via:

```
compat/compat.h
```

Injected globally using:

```bash
-include compat/compat.h
```
or overrides.
---

## Build Instructions

```bash
./build.sh
```

---

## Compatibility Layer (`compat/compat.h`)

This file provides minimal shims for missing Unix APIs:

* `sys/times.h`
* `fork()`, `wait()`
* `index()` → `strchr`
* `mkdir(path, mode)` → `_mkdir(path)`

Only missing functionality is stubbed
Real system headers (e.g. `sys/stat.h`) are **mostly not overridden**

---

## Linking Example

Minimal test:

```cpp
extern "C" {
    int wsq_decode_mem(
        unsigned char **odata,
        int *ow, int *oh, int *od,
        int *ppi, int *lossy,
        unsigned char *idata,
        const int ilen
    );
}
```

Compile:

```bash
x86_64-w64-mingw32-g++ test.cpp \
  -Lartifacts/windows/lib \
  -lwsq -limage -lihead \
  -o test.exe
```

---

## Notes

* Some NBIS libraries (e.g. `libutil`) may not build cleanly
 (Often not required for WSQ usage)
* Link order matters:
  ```bash
  -lwsq -limage -lihead
  ```
* Memory returned by NBIS must be freed manually:
  ```c
  free(odata);
  ```
---
## What This Is (and Isn’t)
### This is:
* A minimal, portable WSQ extraction
* A cross-compile pipeline
* A compatibility shim approach

### This is NOT:

* A full NBIS port
* A working CLI toolchain
* A production-ready SDK

---

## Final Thoughts

NBIS is essentially:
> “Unix research code from another era”
This approach:
* avoids rewriting it
* avoids modifying upstream
* extracts only what’s useful

---

## Status
* [x] Linux build
* [x] Windows cross-compile
* [x] WSQ library extracted
* [x] Runtime validation 
---

## License
NBIS is public domain (NIST, U.S. Government).
---

## Credits
* NIST (original NBIS)