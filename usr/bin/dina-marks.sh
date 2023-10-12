#! /bin/bash 
## /usr/bin/dina-marks.sh

# This is a helper script to launch a dialog powered by yad (https://github.com/v1cont/yad) and let the user choose a bookmarked website to navigate to.
# If yad is not installed a notification informs the user about it and suggests installing it. Yad package installation is "recommended" during Dina's installation. 
# Bookmarks are saved in a text file under ~/.config/dina/bookmarks.txt, which you can manually edit.
# By using this script you can also select to add a bookmark from the open dialog.
# Dina is a minimal browser built with tauri and Pake. It uses the webkit rendering engine.  
# Dina (https://github.com/iontelos/Dina) is maintained by Ion@TeLOS (teloslinux@protonmail.com). 
# Pake is a credited external project. Learn more about Pake at https://github.com/tw93/Pake

YAD=/usr/bin/yad
if test -f "$YAD"; then
    echo "yad is installed, continuing.."
else
echo "yad is not installed, exiting.."
notify-send -a Dina "Install yad to use this feature" -i dina-browser &
exit
fi

mkdir -p ~/.config/dina
touch -a ~/.config/dina/bookmarks.txt

showmarks()
{
TITLE="Dina Marks"
ICON="dina-browser"
ENTRYLABEL="Choose a bookmark to open in Dina "
rcmd=$( yad --center --width=500 --height=100 --borders 15 --window-icon="$ICON" --title="$TITLE" --image="bookmarks" --text-align="center" --text="$ENTRYLABEL" --button="<b> Open</b>","media-play","open selected bookmark":0 --button="<b> Add</b>","add","add a new bookmark":"bash -c dina-add-mark.sh" --button="<b> Remove</b>","remove","remove a bookmark":"bash -c dina-remove-mark.sh" --button="Cancel","cancel","close this dialog":"pkill -f dina-marks.sh" --form --item-separator="," --field="":CB "$(paste -s -d"," < ~/.config/dina/bookmarks.txt)" | sed 's/|$//')

[[ -z "$rcmd" ]] && exit 0

# run command open bookmark
case $rcmd in
   *)
      /usr/bin/dina-browser-direct $rcmd
      esac   
exit
}

showmarks || notify-send -a Dina -i dina-browser "Something went wrong, exiting.." &
exit
