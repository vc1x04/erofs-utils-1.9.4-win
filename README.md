# erofs-utils 1.9.4 — Windows x64 (Cygwin) build

GitHub Actions builds upstream [erofs-utils](https://github.com/erofs/erofs-utils) **v1.9.4** under Cygwin on `windows-latest` and packages `fsck.erofs.exe` together with the `cygwin1.dll` it links against.

## Download

Take the zip from the latest [release](../../releases) or the workflow artifact.

## Usage

```
fsck.erofs --extract=<output-dir> <image>
```

`cygwin1.dll` must stay in the same directory as `fsck.erofs.exe`.

## Notes

- Built from unmodified upstream sources; `lz4` is compiled from source and linked statically.
- The binary is a Cygwin PE64 executable, so it is not a single-file standalone program.
- No affiliation with the upstream project; provided as a convenience build.
