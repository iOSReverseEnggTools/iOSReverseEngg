#!/bin/bash

#configuration 
heightInPx=400
widthInPx=400

count=0
mkdir -p "./$widthInPx"

echo "The script you are running has basename `basename $0`, dirname `dirname $0`"

scriptDir=`dirname $0`
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
		$scriptDir/libwebp-0.4.1-rc1-mac-10.8/bin/dwebp "$name.webp" -scale $widthInPx $heightInPx -o "$widthInPx/$name.W$widthInPx.png" | 2>&1 > /dev/null #"$name.1024.png"
		if [ $? == 0 ]; then
			count=$((count+1))
		fi
	fi
done 

echo "Done converting $count files"
ls "$widthInPx"

	echo "*****************************************************"
	echo "* Do you want to open folder enclosing files? [y/n] *"
	echo "*****************************************************" 
	read input
	if [ $input == "y" ]; then 
		open "$widthInPx"
	fi

echo "******************************"
echo "* Thanks for using converter *"
echo "******************************"

#improvement passign the directory
#surpressing the log output only final message on screen 
