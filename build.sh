#!/bin/bash
targets=("linux" "windows/386" "windows/amd64" "ios/*")
archiveName="webview-sample"
function printTargetOptions {
    declare -i index
    echo ${targets[@]}
    index=0
    for target in ${targets[@]}
    do
        echo "$index: $target"
        ((index = index + 1))
    done
}
echo "you will need root access to build"
printTargetOptions
echo -n "Specify target os (0 for linux) => "
read targetIndex
if [ $targetIndex -gt 3 ]; then
    echo "invalid input"
    exit
fi
echo "building for ${targets[$targetIndex]}..."
if [ $targetIndex -eq 0 ]; then
    go build -o $archiveName main.go
else
    sudo sh -c "./xgo -out $archiveName --targets=${targets[$targetIndex]} github.com/radhe-soni/webview-sample"
    mkdir dist
    rm "$archiveName.zip"
    find ./ -maxdepth 1 -type f -name "${archiveName}-*" | xargs -i mv {} dist/{}
    if [ "${targets[$targetIndex]}" = "windows/386" ]; then
        cp dll/x86/* dist/
    elif [ "${targets[$targetIndex]}" = "windows/amd64" ]; then
        cp dll/x86/* dist/
    fi
    
    zip -9vmr "$archiveName.zip" dist
fi