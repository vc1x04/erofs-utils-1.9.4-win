# erofs-utils 1.9.4 — Windows x64 (Cygwin) build

GitHub Actions builds upstream [erofs-utils](https://github.com/erofs/erofs-utils) **v1.9.4** under Cygwin on `windows-latest` and packages `fsck.erofs.exe` with the DLLs it needs (lz4 is built from upstream source as well).

## Download

Grab `erofs-utils-1.9.4-win-x64.zip` from the latest [release](../../releases) or from the workflow artifact.

## Usage

```
fsck.erofs --version
fsck.erofs --extract=<output-dir> <image>
```

Keep `cygwin1.dll` and `cyglz4-1.dll` next to `fsck.erofs.exe`.

## What is inside

- `fsck.erofs.exe` — erofs-utils 1.9.4, decompressors: `lz4`, `lz4hc`, `deflate`
- `cygwin1.dll` — Cygwin runtime the binary links against
- `cyglz4-1.dll` — liblz4 1.10.0

## Notes

- Built from unmodified upstream sources; no patches are applied.
- On sample images the extracted trees are byte-for-byte identical to the ones produced by the same 1.9.4 source built natively on Linux (same per-file SHA-256, same tree digest).
- The binary is a Cygwin PE64 executable, so it is not a single-file standalone program.
- Not affiliated with the upstream project; provided as a convenience build.
