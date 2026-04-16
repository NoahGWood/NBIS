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
make install

# cd $ROOT

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
BUILD_DIR=$(pwd)
COMPAT_DIR=$(pwd)/compat
MASTER_INCLUDES="-I$BUILD_DIR/commonnbis/include \
-I$BUILD_DIR/imgtools/include \
-I$BUILD_DIR/an2k/include \
-I$BUILD_DIR/bozorth3/include \
-I$BUILD_DIR/mindtct/include \
-I$BUILD_DIR/nfseg/include \
-I$BUILD_DIR/nfiq/include \
-I$BUILD_DIR/pcasys/include"

./setup.sh $(pwd)/../artifacts/windows --without-X11 --STDLIBS --64
make config
echo "Building CommonNBIS foundations..."
cd commonnbis/src/lib
for sub in util ioutil f2c fft; do
    make -C $sub \
        CC="$CC" \
        AR="$AR" \
        RANLIB="$RANLIB" \
        CFLAGS="-fcommon -I$COMPAT_DIR -include $COMPAT_DIR/compat.h $MASTER_INCLUDES"
done
cd ../../../
# 1. Build the base utilities first (the foundation)
MISSING_LIBS="util ioutil fft"
for dir in $MISSING_LIBS; do
    echo "Building core dependency: $dir"
    make -C commonnbis/src/lib/$dir -j$(nproc) \
        CC="$CC" \
        AR="$AR" \
        RANLIB="$RANLIB" \
        CFLAGS="-fcommon -I$COMPAT_DIR -include $COMPAT_DIR/compat.h $MASTER_INCLUDES"
done

# 2. Build everything else
# libs only
for d in */ ; do
  # Determine the actual library source directory
  LIB_SRC_DIR=""
  if [ -d "$d/src/lib/$d" ]; then
    LIB_SRC_DIR="$d/src/lib/$d"
  elif [ -d "$d/src/lib" ]; then
    LIB_SRC_DIR="$d/src/lib"
  fi

  if [ -n "$LIB_SRC_DIR" ]; then
    echo "Building libs in $d..."
    (cd "$d" && make -C "src/lib" -j$(nproc) libs \
      CC="$CC" \
      CXX="$CXX" \
      AR="$AR" \
      RANLIB="$RANLIB" \
      CFLAGS="-fcommon -I$COMPAT_DIR -include $COMPAT_DIR/compat.h $MASTER_INCLUDES"
    ) || echo "Failed to build libs in $d, skipping..."
  fi
done

mkdir -p ../artifacts/windows/lib
mkdir -p ../artifacts/windows/include

cp -r exports/lib/* ../artifacts/windows/lib/ || true
cp -r exports/include/* ../artifacts/windows/include/ || true

cp commonnbis/lib/libutil.a ../artifacts/windows/lib/
cp commonnbis/lib/libioutil.a ../artifacts/windows/lib/