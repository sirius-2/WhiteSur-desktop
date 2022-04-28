#!/bin/bash

if [ -f /usr/bin/git ];then
	if [ ! -d  WhiteSur-desktop ];then
		git clone https://github.com/sirius-2/WhiteSur-desktop.git -b beautify-gtk
	fi
        if [ $? -eq 0 ];then
                cd WhiteSur-desktop && sudo chmod +x setup.sh
                ./setup.sh -i
        fi
else
	echo 'please install git to start'
fi
