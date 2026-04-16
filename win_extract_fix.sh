COMPAT_DIR=$(pwd)/compat
# This script exists to unfuck the NBIS build tree and grab as many exports as we can mostly validly
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
    CFLAGS="-fcommon -D__NBISLE__ -I$COMPAT_DIR -include $COMPAT_DIR/compat.h"
  ) || true
done
