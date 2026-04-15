#!/bin/bash
set -e

ROOT=$(pwd)
SRC=$ROOT/vendor/nbis

# -------- Linux --------
rm -rf build-linux
cp -r $SRC build-linux
cd build-linux

./setup.sh $ROOT/artifacts/linux --without-X11 --STDLIBS --64
make config
make -j$(nproc) it CFLAGS="-fcommon"
make install LIBNBIS=yes

cd $ROOT

# -------- Windows --------
rm -rf build-windows
cp -r $SRC build-windows
cp -r compat build-windows # Copy over the headers
cd build-windows
export CC=x86_64-w64-mingw32-gcc
export CXX=x86_64-w64-mingw32-g++
export LD=x86_64-w64-mingw32-gcc
export AR="x86_64-w64-mingw32-ar rcs"
export RANLIB=x86_64-w64-mingw32-ranlib
COMPAT_DIR=$(pwd)/compat

./setup.sh $(pwd)/../artifacts/windows --without-X11 --STDLIBS --64
make config
# Someday may fix, probably not but maybe
# make -j$(nproc) it \
#   CC=x86_64-w64-mingw32-gcc \
#   CXX=x86_64-w64-mingw32-g++ \
#   AR="$AR" \
#   RANLIB=$RANLIB \
#   CFLAGS="-fcommon -I$(pwd)/compat -include $(pwd)/compat/compat.h"
# make install

# headers
for d in */ ; do
  if [ -f "$d/Makefile" ]; then
    (cd "$d" && make -q cpheaders 2>/dev/null && make cpheaders) || true
  fi
done
# libs only
for d in */ ; do
  (cd "$d" && make -j$(nproc) libs \
    CC="$CC" \
    CXX="$CXX" \
    AR="$AR" \
    RANLIB="$RANLIB" \
    CFLAGS="-fcommon -I$COMPAT_DIR -include $COMPAT_DIR/compat.h"
  ) || true
done

mkdir -p ../artifacts/windows/lib
mkdir -p ../artifacts/windows/include

cp -r exports/lib/* ../artifacts/windows/lib/ || true
cp -r exports/include/* ../artifacts/windows/include/ || true