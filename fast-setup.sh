#!/bin/bash

if [ -f /usr/bin/git ];then
	if [ ! -d tools ];then
		git clone https://github.com/sirius-2/tools.git -b osx-beautify
	fi
        if [ $? -eq 0 ];then
                cd tools && sudo chmod +x setup.sh
                ./setup.sh -i
        fi
else
	echo 'please install git to start'
fi
