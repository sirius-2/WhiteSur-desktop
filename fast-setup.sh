#!/bin/bash

c_dir=$(pwd)
if [ -f /usr/bin/git ];then
	if [ ! -d  WhiteSur-desktop ];then
		git clone https://github.com/sirius-2/WhiteSur-desktop.git -b beautify-plasma
	fi
        if [ $? -eq 0 ];then
                cd WhiteSur-desktop && sudo chmod +x setup.sh
                ./setup.sh -m
        fi
else
	echo 'please install git to start'
fi
cd ${c_dir}
