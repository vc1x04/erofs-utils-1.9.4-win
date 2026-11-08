#!/bin/bash
# Build erofs-utils v1.9.4 under Cygwin (fsck.erofs, lz4 support).
set -eu

LZ4_VER=1.10.0
EROFS_VER=1.9.4
WORK=/tmp/b
PKG=/tmp/pkg

rm -rf "$WORK" "$PKG"
mkdir -p "$WORK" "$PKG" /usr/local/lib /usr/local/include /usr/local/lib/pkgconfig
cd "$WORK"

echo "--- lz4 $LZ4_VER ---"
curl -fsSL -o lz4.tgz "https://codeload.github.com/lz4/lz4/tar.gz/refs/tags/v$LZ4_VER"
tar xzf lz4.tgz
cd "lz4-$LZ4_VER"
make -C lib liblz4.a
make -C lib install PREFIX=/usr/local
ls -l /usr/local/lib/liblz4* /usr/local/lib/pkgconfig/ || true
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
pkg-config --modversion liblz4
cd "$WORK"

echo "--- erofs-utils $EROFS_VER ---"
curl -fsSL -o erofs.tgz "https://codeload.github.com/erofs/erofs-utils/tar.gz/refs/tags/v$EROFS_VER"
tar xzf erofs.tgz
cd "erofs-utils-$EROFS_VER"
./autogen.sh
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
CPPFLAGS=-I/usr/local/include LDFLAGS=-L/usr/local/lib ./configure \
  --disable-shared --enable-static \
  --disable-libselinux \
  --disable-lzma \
  --disable-fuse \
  --without-uuid \
  --without-zlib \
  --without-libzstd \
  --without-xxhash \
  --without-libcurl
make -j"$(nproc)"

echo "--- diagnose ---"
ls -l fsck/
ls -l fsck/.libs/ 2>/dev/null || true
echo "== top-level binary =="
./fsck/fsck.erofs --version || true
echo "== .libs binary =="
./fsck/.libs/fsck.erofs.exe --version || true

echo "--- collect ---"
if [ -f fsck/.libs/fsck.erofs.exe ]; then
  cp fsck/.libs/fsck.erofs.exe "$PKG/fsck.erofs.exe"
else
  cp fsck/fsck.erofs.exe "$PKG/fsck.erofs.exe"
fi
cp /usr/bin/cygwin1.dll "$PKG/"
for f in /usr/bin/cyglz4*.dll /usr/bin/cygerofs*.dll; do
  [ -f "$f" ] && cp "$f" "$PKG/" || true
done
ls -l "$PKG"
"$PKG/fsck.erofs.exe" --version || true
