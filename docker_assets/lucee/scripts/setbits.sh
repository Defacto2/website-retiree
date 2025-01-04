#!/usr/bin/env bash

# root directory
assets=/opt/assets-defacto2

# sub-directories
declare -a directories=("downloads" "images000" "images150" "images400")

# save the current working directory
workdirectory=$(pwd)
# reset directories
cd $assets
sudo chown ben:ben .
sudo chmod -R 775 .
echo -e "\nListing of\033[94m" $assets"\033[0m/"
ls -l --color=always $assets | grep -v '^total' | awk '{print $1, $3":"$4, $9"/"}'
echo ""

# reset sub-directories
arraylength=${#directories[@]}
for (( i=1; i<${arraylength}+1; i++ ));
do
    directory=$assets/${directories[$i-1]}
    # set the working directory
    cd $directory
    echo -e $i"/"${arraylength}":\033[94m" $directory"\033[0m/" $(du -h --max-depth=0) $(ls -1 | wc -l) "files"
    # double-check the current working directory
    # because we're using -R recursive arguments
    if [ "$(pwd)" != "$directory" ]; then
        echo "error, skipping this directory"
        continue
    fi
    # reset ownerships (ben)
    find . -maxdepth 1 -not -name "." -print0 | xargs --null chown -R ben:ben
    # reset permission bits (rw,r,r)
    find . -maxdepth 1 -not -name "." -print0 | xargs --null chmod -R 664
done

# reset wayback web
cd $assets/waybackweb
find . -type d -exec chmod 755 {} +
find . -type f -exec chmod 644 {} +

# return to the original working directory
cd $workdirectory