#! /bin/bash 
## /usr/bin/dina-remove-mark.sh

## Copyright: 2023, Ion@TeLOS
## License: GPL-3.0+

# This is a helper script to launch a dialog powered by yad (https://github.com/v1cont/yad) and let the user select a Dina bookmark to remove.
# If yad is not installed, a notification informs the user about it and suggests installing it. Yad package installation is "recommended" during Dina's installation. 
# Bookmarks are saved in a text file under ~/.config/dina/bookmarks.txt, which you can manually edit.
# Dina is a minimal browser built with tauri and Pake and uses the webkit rendering engine.  
# Pake is a credited external project with its own license. Learn more about Pake at https://github.com/tw93/Pake
# Dina (https://github.com/iontelos/Dina) is maintained by Ion@TeLOS (teloslinux@protonmail.com). 

YAD=/usr/bin/yad
if test -f "$YAD"; then
    echo "yad is installed, continuing.."
else
echo "yad is not installed, exiting.."
notify-send -a Dina "Install yad to use this feature" -i dina-browser &
exit
fi

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
rcmd=$( yad --center --width=500 --height=100 --borders 15 --window-icon="$ICON" --title="$TITLE" --image="bookmarks" --text-align="center" --text="$ENTRYLABEL" --button="<b> Remove</b>","remove","remove selected bookmark":0 --button="Cancel","cancel","close this dialog":"pkill -f dina-remove-mark.sh" --form --item-separator="," --field="":CB "$(paste -s -d"," < ~/.config/dina/bookmarks.txt)" | sed 's/|$//')

[[ -z "$rcmd" ]] && exit 0

# run command to remove bookmark
case $rcmd in
   *) 
      grep -v $rcmd ~/.config/dina/bookmarks.txt > /tmp/bookmarks.txt && mv /tmp/bookmarks.txt ~/.config/dina/bookmarks.txt &
      notify-send -a Dina -i dina-browser "Bookmark removed" &
      esac
exit

}

removemark || notify-send -a Dina -i dina-browser "Something went wrong, exiting.." &
pkill -f dina-marks.sh &
exit
