#! /bin/bash 
## /usr/bin/dina-add-mark.sh

# This is a helper script to launch a dialog powered by yad (https://github.com/v1cont/yad) and let the user add a bookmark for Dina web browser. 
# If yad is not installed, a notification informs the user about it and suggests installing it. Yad package installation is "recommended" during Dina's installation. 
# Bookmarks are saved in a text file under ~/.config/dina/bookmarks.txt, which you can manually edit.
# Dina is a minimal browser built with tauri and Pake. It uses the webkit rendering engine. 
# Dina (https://github.com/iontelos/Dina) is maintained and packaged by Ion@TeLOS (teloslinux@protonmail.com). 
# Pake is a credited external project. Learn more about Pake at https://github.com/tw93/Pake

addmark()
{
# choose web address to navigate to
TITLE="Dina marks"
ENTRYLABEL="<b> Enter web address of bookmark :</b>"
ENTRYTEXT="https://"
ICON="dina-browser"
rcmd=$( yad --width=500 --center --window-icon="$ICON" --borders 15 --name="${0##*/}" --title="$TITLE" --image="bookmarks" --entry --entry-label="$ENTRYLABEL" --entry-text="$ENTRYTEXT" --editable --button="<b>  Add</b>"!"add"!"click here to add bookmark":0 --button=" Cancel"!"cancel"!"close this dialog":"pkill -f dina-add-mark.sh" )

[[ -z "$rcmd" ]] && exit 0

# run command
case $rcmd in
   *)
      space=" |'"
      fullstop="."
      if [[ $rcmd != http* ]] && [[ $rcmd == *"$fullstop"* ]]; then
      echo "https://$rcmd \n" >> ~/.config/dina/bookmarks.txt &
      notify-send -a Dina -i dina-browser "Bookmark added" &
      exit
      fi
      if [[ $rcmd != http* ]] && [[ $rcmd =~ $space ]]; then
      notify-send -a Dina -i dina-browser "This is not a valid web address" &
      exit
      fi
      if [[ $rcmd != http* ]] && [[ $rcmd != *"$fullstop"* ]]; then
      notify-send -a Dina -i dina-browser "This is not a valid web address" &
      exit
      else
      echo "$rcmd \n" >> ~/.config/dina/bookmarks.txt &
      notify-send -a Dina -i dina-browser "Bookmark added" &
      exit
      fi
esac

exit 0
}

addmark || notify-send -a Dina "Install yad to use this feature" -i dina-browser &
pkill -f dina-marks.sh
exit
