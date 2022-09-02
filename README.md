# Glad for OpenGL

Glad `git` repository for OpenGL usage. This project include different build
system script, `cmake`, `premake5` and `shellscript`.

## Build

### CMake

```
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release -GNinja
```

### shellscript

Make `build.sh` into an executable.

```
chmod +x build.sh
```

Run the `build.sh` script to create `libglad.a` for later usage.

