#! /bin/bash 
## /usr/bin/dina-nav.sh

# This is a helper script to launch a dialog powered by yad (https://github.com/v1cont/yad) and let the user choose their startpage for Dina web browser. 
# If yad is not installed, a notification informs the user about it and suggests installing it. Yad package installation is "recommended" during Dina's installation. 
# Dina is a minimal browser built with tauri and Pake. It uses the webkit rendering engine. 
# By using this script you can select a web address to navigate to with Dina. 
# After selection, the script hands over control to dina.sh script which handles launching Dina browser at the web address of your choice. 
# Dina (https://github.com/iontelos/Dina) is maintained and packaged by Ion@TeLOS (teloslinux@protonmail.com). 
# Pake is a credited external project. Learn more about Pake at https://github.com/tw93/Pake

navigate()
{
# choose web address to navigate to
TITLE="Navigate with Dina"
ENTRYLABEL="<b> Enter web address to visit :</b>"
ENTRYTEXT="https://"
ICON="dina-browser"
rcmd=$( yad --width=500 --center --window-icon="$ICON" --borders 15 --name="${0##*/}" --title="$TITLE" --image="epiphany-browser" --entry --entry-label="$ENTRYLABEL" --entry-text="$ENTRYTEXT" --editable --button="<b>  Navigate</b>"!"media-play"!"click here to launch browser":0 --button=" Cancel"!"cancel"!"close this dialog":"pkill -f dina-nav.sh" )

[[ -z "$rcmd" ]] && exit 0

# run command
case $rcmd in
   *)
      space=" |'"
      fullstop="."
      if [[ $rcmd != http* ]] && [[ $rcmd == *"$fullstop"* ]]; then
      /usr/bin/dina.sh "https://"$rcmd &
      exit
      fi
      if [[ $rcmd != http* ]] && [[ $rcmd =~ $pattern ]]; then
      /usr/bin/dina.sh "https://www.google.com/search?q=""$rcmd" &
      exit
      fi
      if [[ $rcmd != http* ]] && [[ $rcmd != *"$fullstop"* ]]; then
      /usr/bin/dina.sh "https://www.google.com/search?q="$rcmd &
      exit
      else
      /usr/bin/dina.sh $rcmd &
      exit
      fi
esac

exit 0
}

navigate || notify-send -a Dina "Install yad to use this feature" -i dina-browser &
exit
