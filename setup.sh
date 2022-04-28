#!/bin/bash

baseurl='github.com'
mirror_baseurl='hub.fastgit.xyz'

name='vinceliuice'

kde_theme='WhiteSur-kde'
kde_icon='WhiteSur-icon-theme'
kde_cursor='WhiteSur-cursors'

kde_source_dir='kde_source'

c_dir=`pwd`
source_list=(${kde_theme} ${kde_icon} ${kde_cursor})

pull_source(){
    mkdir -p ${kde_source_dir}
    if [[ $1 ]];then baseurl="$1";fi
    echo "[ + ] Pulling from $baseurl"
    for l in "${source_list[@]}"
    do
        if [[ ! -f ${kde_source_dir}/${l}/install.sh ]];then
            sudo rm -rf ${kde_source_dir}/${l}
            git clone https://${baseurl}/${name}/${l}.git ${kde_source_dir}/${l}
        else
            echo "[ + ] Found ${l}"
        fi
    done
}

handle(){
    sudo chmod -R +x ${kde_source_dir}

    # for handle
    for l in "${source_list[@]}"
    do
        cd ${kde_source_dir}/${l}
        # handle sddm
        if [[ ${l} == 'WhiteSur-kde' ]];then
            cd sddm && sudo ./install.sh
            cd ..
        fi
        sudo ./install.sh && cd ../..
    done
}

apply(){
    # theme
    echo "[ + ] Setting theme to $1"
    /usr/bin/plasma-apply-lookandfeel -a $1
    #/usr/bin/plasma-apply-desktoptheme $1

    # icons
    echo "[ + ] Setting icon theme to $2"
    /usr/lib/plasma-changeicons $2

    # cursor
    echo "[ + ] Setting cursor theme to $3"
    /usr/bin/plasma-apply-cursortheme $3

    # wallpaper
    echo "[ + ] Setting Wallpaper to $4"
    /usr/bin/plasma-apply-wallpaperimage $4
}

case $1 in
    -i | --install)
        pull_source
        handle
        apply com.github.vinceliuice.WhiteSur WhiteSur WhiteSur-cursors /usr/share/wallpapers/WhiteSur/contents/images/2560x1440.png
        ;;
    -d | --debug)
        apply org.kde.breezetwilight.desktop breeze breeze_cursors /usr/share/wallpapers/Bamboo/contents/images/5120x2880.png
        ;;
    -f | --fast-install)
        pull_source hub.fastgit.xyz
        handle
        apply com.github.vinceliuice.WhiteSur WhiteSur WhiteSur-cursors /usr/share/wallpapers/WhiteSur/contents/images/2560x1440.png
        ;;
    -m | --mirror-install)
        if [[ ! $2 ]];then
            pull_source ${mirror_baseurl}
        else
            pull_source $2
        fi
        handle
        apply com.github.vinceliuice.WhiteSur WhiteSur WhiteSur-cursors /usr/share/wallpapers/WhiteSur/contents/images/2560x1440.png
        ;;
    **)
cat<<EOF
./setup [arg]

arg:
    -i | --install         install theme
    -d | --debug           restore default theme
    -f | --fast-install    fast install
    -m | --mirror-install  use custom github mirror eg. -m mirror.xxx
    -h | --help            show help
EOF

esac
