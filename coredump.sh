#!/bin/bash
export PATH=$PATH:../xtensa-esp-elf-gdb/bin/
for d in build $(printf "%s\n" builds/* | sort -r) ; do

    echo "Trying $d..." >&2
    /c/Users/arepi/AppData/Local/Packages/PythonSoftwareFoundation.Python.3.12_qbz5n2kfra8p0/LocalCache/local-packages/Python312/Scripts/esp-coredump.exe  info_corefile -c "$1" $d/*/*.ino.elf >"$1".txt && break

done

if [[ $? -eq 0 ]] ; then
    echo "Succeeded" >&2
else
    rm -f "$1".txt
    echo "Decode failed." >&2
    exit 1
fi
