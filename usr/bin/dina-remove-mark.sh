#! /bin/bash 
## /usr/bin/dina-remove-mark.sh

# This is a helper script to launch a dialog powered by yad (https://github.com/v1cont/yad) and let the user select a Dina bookmark to remove.
# If yad is not installed a notification informs the user about it and suggests installing it. Yad package installation is "recommended" during Dina's installation. 
# Bookmarks are saved in a text file under ~/.config/dina/bookmarks.txt, which you can manually edit.
# Dina is a minimal browser built with tauri and Pake. It uses the webkit rendering engine.  
# Dina (https://github.com/iontelos/Dina) is maintained by Ion@TeLOS (teloslinux@protonmail.com). 
# Pake is a credited external project. Learn more about Pake at https://github.com/tw93/Pake

file="~/.config/dina/bookmarks.txt"
countlines=$(cat $file | wc -l)
echo $countlines
minlines=1
if [[ $countlines -le $minlines ]]; then
    echo "https://debian.org \n" >> ~/.config/dina/bookmarks.txt
fi

removemark()
{
TITLE="Dina Marks"
ICON="dina-browser"
ENTRYLABEL="Choose a bookmark to remove"
rcmd=$( yad --center --width=500 --height=100 --borders 15 --window-icon="$ICON" --title="$TITLE" --image="bookmarks" --text-align="center" --text="$ENTRYLABEL" --button="<b> Remove</b>","remove","click here to delete selected bookmark":0 --button="Cancel","cancel","close this dialog":"pkill -f dina-remove-mark.sh" --form --item-separator="," --field="":CB "$(paste -s -d"," < ~/.config/dina/bookmarks.txt)" | sed 's/|$//')



[[ -z "$rcmd" ]] && exit 0

# run command remove bookmark
case $rcmd in
   *) 
      grep -v $rcmd ~/.config/dina/bookmarks.txt > /tmp/bookmarks.txt && mv /tmp/bookmarks.txt ~/.config/dina/bookmarks.txt &
      notify-send -a Dina -i dina-browser "Bookmark removed" &
      esac
exit

}

removemark || notify-send -a Dina "Install yad to use this feature" -i dina-browser &
pkill -f dina-marks.sh
exit

