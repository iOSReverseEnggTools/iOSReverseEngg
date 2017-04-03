#!/bin/bash

#configuration 
heightInPx=1024
widthInPx=1024

count=0
mkdir -p "./$widthInPx"

webpFiles=(`ls .`)
echo $webpFiles
for i in "${webpFiles[@]}"
do
	ext=$(echo $i | cut -f 2 -d '.')
	echo $ext
	if [ $ext == "webp" ]; then 
		echo "Converting $i\n"
		name=$(echo $i | cut -f 1 -d '.')
		echo "File name : $name"
		~/Downloads/libwebp-0.4.1-rc1-mac-10.8/bin/dwebp "$name.webp" -scale $widthInPx $heightInPx -o "$widthInPx/$name.W$widthInPx.png" | 2>&1 > /dev/null #"$name.1024.png"
		if [ $? == 0 ]; then
			count=$((count+1))
		fi
	fi
done 

echo "Done converting $count files"

#improvement passign the directory
#surpressing the log output only final message on screen 
