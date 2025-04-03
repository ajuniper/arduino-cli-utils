#!/bin/bash
board=esp32:esp32:esp32
declare -a opts
[[ -e boardname.txt ]] && board=$(<boardname.txt)
if [[ $1 = *:*:* ]] ; then
    board=${1}
    shift
fi

if [[ $board = *esp32* ]] ; then
    opts=( --board-options PartitionScheme=min_spiffs )
else
    opts=( --build-property build.partitions=min_spiffs,upload.maximum_size=1966080 )
fi

# create timestamp file for build
date +$'#include <Arduino.h>\nconst char * build_time PROGMEM = "%F %T";' >buildstamp.cpp

echo "Building for $board"
/c/users/arepi/Documents/Arduino/arduino-cli.exe compile \
    --fqbn ${board} \
    "${opts[@]}" \
    -e \
    "$@"
e=$?

if [[ $e -eq 0 ]] ; then
    # preserve builds
    dir=builds/$(date +%Y%m%d-%H%M%S)
    mkdir -p $dir
    cp -a build/${board//:/.} $dir
    # keep the most recent 5 builds
    ls -r -d builds/*/${board//:/.} | tail -n +6 | xargs -r -t rm -rf
fi
