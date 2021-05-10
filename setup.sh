#!/bin/bash

mydebug()
{
gsettings set org.gnome.desktop.interface gtk-theme Default
gsettings set org.gnome.desktop.interface icon-theme default
gsettings set org.gnome.desktop.interface cursor-theme Adwaita
gsettings set org.gnome.desktop.wm.preferences button-layout ':maximize,minimize,close'
}

config()
{
baseurl='https://github.com/'
#baseurl='https://github.com.cnpmjs.org/'

# theme
theme_repo='vinceliuice/WhiteSur-gtk-theme'
theme_dir='WhiteSur-light'

# icon
icon_repo='vinceliuice/WhiteSur-icon-theme'
icon_dir='WhiteSur'

# cursor - macOSBigSur - built
cursor_dir='macOSBigSur'

# other
c_dir=$(pwd)
cursor_tgdir=$HOME/.icons
stablesource=./builds/surbuilds.tar.xz
}

pull_source()
{
if [[ -d $HOME/.themes/WhiteSur-light ]] && [[ -d $HOME/.local/share/icons/WhiteSur ]] && [[ -d $cursor_tgdir/$cursor_dir ]];then
	return 0
else
	echo -e "\033[31m Continue ...\033[0m"
	list=($theme_repo $icon_repo)

	_eleok=0
	for l in "${list[@]}"
	do
		_eledir="$(echo $l | awk -F '/' '{print $2}')"
		if [[ ! -f "$_eledir/install.sh" ]];then
			git clone "$baseurl$l.git"
		fi
		if [[ -f "$_eledir/install.sh" ]];then _eleok=1;else _eleok=0;fi
		if [[ $_eleok -eq 1 ]];then
			cd $_eledir && sudo chmod +x install.sh
			./install.sh
			cd $c_dir
			_eleok=0
		fi
	done
fi
}

use_stable()
{
	if [[ -f $stablesource ]];then
		tar -Jxf $stablesource -C ./
	fi
}

manual()
{
if [[ ! -d $cursor_tgdir/$cursor_dir ]];then
	if [[ ! $(mkdir -p $cursor_tgdir) ]] && [[ -d $cursor_dir ]];then
		cp -rf $cursor_dir $cursor_tgdir
		return true
	else
		return false
	fi
else
	return true
fi
}

arrange(){
# theme
gsettings set org.gnome.desktop.interface gtk-theme $theme_dir

# icon
gsettings set org.gnome.desktop.interface icon-theme $icon_dir

# cursor
if [[ manual ]];then gsettings set org.gnome.desktop.interface cursor-theme $cursor_dir;fi

# window button - to left
gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:'
}

usage()
{
cat <<EOF
./setup -i

-i    install beautify pack
-r    remove beautify pack
-n    pull newest source to install

-d    debug
-h    show this message
EOF
}


remove()
{
rm -rf $HOME/.themes/WhiteSur-*
rm -rf $HOME/.local/share/icons/WhiteSur*
}


main()
{
task=(config use_stable pull_source arrange)
if [[ $1 == "new" ]];then unset task[1];fi
for t in "${task[@]}"
do
	$t
done
echo done
}


case $1 in
	-d|--debug)
	mydebug
	;;
	-i|--install)
	main
	;;
	-r|--remove)
	remove
	;;
	-n|--new)
	main "new"
	;;
	-h|--help)
	usage
	exit 1
	;;
	*|--*)
	usage
	exit 1
	;;
esac
