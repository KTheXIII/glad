#!/usr/bin/env sh

ins="src/*.c"
bin=build
obj=obj

name='glad'

c_version=-std=c18
warnings="-Wall -Wextra"
includes="-Iinclude"
other="-O3"
compile_flags="${c_version} ${warnings} ${includes} ${other}"

mkdir -p $obj
mkdir -p $bin

object_files=()
for input in $ins; do
    out=${input%.*}
    out=${out##*/}
    cc $compile_flags -c $input -o $obj/${out}.o
    object_files+=("${obj}/${out}.o")
done

ar rcs $bin/lib${name}.a "${object_files}"

