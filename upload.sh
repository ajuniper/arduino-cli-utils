#!/bin/bash
# upload latest build to most recent target from here
# p1 = optional new target
tgtfile=./build/lasttarget

if [[ -n $1 ]] ; then
    target="$1"
elif [[ -s $tgtfile ]] ; then
    target="$(<$tgtfile)"
fi
if [[ -z $target ]] ; then
    echo "Cannot determine target from param 1 or $tgtfile" >&2
    exit 1
fi

ino=( $(echo *.ino) )
if [[ ${#ino[*]} -ne 1 ]] ; then
    echo "Too many ino files to work out build name: ${ino[*]}" >&2
    exit 1
fi
build=( $(echo build/*/${ino}.bin ) )
if [[ ${#build[*]} -ne 1 || ! -s ${build} ]] ; then
    echo "Failed to identify build from ${ino}: ${build[*]}" >&2
    exit 1
fi

echo "Uploading to ${target}" >&2
set -e
curl --fail-with-body -F update=@${build} "http://${target}/update"
echo
curl -s --fail-with-body http://${target}/reboot
echo "$target" >"${tgtfile}"
echo
sleep 15
curl -s --fail-with-body http://${target}/status
