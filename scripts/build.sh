#!/bin/bash
# Build erofs-utils v1.9.4 under Cygwin.
# Produces fsck.erofs.exe (lz4 linked statically) plus cygwin1.dll in /tmp/pkg.
set -eu

LZ4_VER=1.10.0
EROFS_VER=1.9.4
WORK=/tmp/b
PKG=/tmp/pkg

rm -rf "$WORK" "$PKG"
mkdir -p "$WORK" "$PKG" /usr/local/lib /usr/local/include
cd "$WORK"

bash --version | head -1
echo "--- lz4 $LZ4_VER ---"
curl -fsSL -o lz4.tgz "https://codeload.github.com/lz4/lz4/tar.gz/refs/tags/v$LZ4_VER"
tar xzf lz4.tgz
cd "lz4-$LZ4_VER"
make -C lib liblz4.a || make -C lib
ls -l lib/liblz4.a
cp lib/liblz4.a /usr/local/lib/
cp lib/*.h /usr/local/include/
cd "$WORK"

echo "--- erofs-utils $EROFS_VER ---"
curl -fsSL -o erofs.tgz "https://codeload.github.com/erofs/erofs-utils/tar.gz/refs/tags/v$EROFS_VER"
tar xzf erofs.tgz
cd "erofs-utils-$EROFS_VER"
./autogen.sh
CPPFLAGS=-I/usr/local/include LDFLAGS=-L/usr/local/lib ./configure \
  --disable-libselinux \
  --disable-lzma \
  --disable-fuse \
  --without-zlib \
  --without-libzstd \
  --without-xxhash \
  --without-libcurl
make -j"$(nproc)"

echo "--- collect ---"
./fsck/fsck.erofs --version
cp fsck/fsck.erofs.exe "$PKG/"
cp /usr/bin/cygwin1.dll "$PKG/"
cp /usr/bin/cyglz4*.dll "$PKG/" 2>/dev/null || true
ls -l "$PKG"
