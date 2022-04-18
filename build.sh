#!/usr/bin/env sh

ins="src/*.c"
lib=lib
obj=obj

lib_name='glad'

c_version=-std=c18
warnings="-Wall -Wextra"
includes="-Iinclude"
other="-O3"
compile_flags="${c_version} ${warnings} ${includes} ${other}"

mkdir -p $obj
mkdir -p $lib

object_files=()
for input in $ins; do
    out=${input%.*}
    out=${out##*/}
    cc $compile_flags -c $input -o $obj/${out}.o
    object_files+=("${obj}/${out}.o")
done

ar rcs $lib/lib${lib_name}.a "${object_files}"

