#! /bin/bash 
## /usr/bin/dina-install.sh

# This is a helper script to launch a dialog powered by yad (https://github.com/v1cont/yad) and let the user choose a website to "install", that is to create a .desktop file - shortcut, so that the user can launch the website from the system menu. The website will be opened in Dina. All site shortcuts (and Dina itself) share the same profile and cookies. Yad package installation is "recommended" during Dina's installation. 
# Dina is a minimal browser built with tauri and Pake. It uses the webkit rendering engine. 
# A separate app (https://github.com/iontelos/get-favicon) is downloaded at runtime to fetch suitable website favicons from the Internet. get-favicon is placed in your ~/.locan/bin/ directory.
# Dina (https://github.com/iontelos/Dina) is maintained and packaged by Ion@TeLOS (teloslinux@protonmail.com). 
# Pake is a credited external project. Learn more about Pake at https://github.com/tw93/Pake

YAD=/usr/bin/yad
if test -f "$YAD"; then
    echo "yad is installed, continuing.."
else
echo "yad is not installed, exiting.."
notify-send -a Dina -i dina-browser "Install yad to use this feature" &
exit
fi

mkdir -p ~/.local/bin
mkdir -p ~/.config/dina/webappicons

check-app()
{
FAVAPP=/home/$USER/.local/bin/get-favicon
if test -f "$FAVAPP"; then
    echo "$FAVAPP exists"
else
echo "downloading get-favicon app from GitHub"
notify-send -a Dina -i dina-browser "Please wait.." "downloading additional required component" &
wget https://github.com/IonTeLOS/get-favicon/releases/download/public/get-favicon -O $HOME/.local/bin/get-favicon && 
chmod a+x $HOME/.local/bin/get-favicon
fi
}

write-desktop()
{
du -a -h $HOME/.config/dina/webappicons/"$NAME"/*.png

if [ $? -eq 1 ]
then
ICON=dina-browser
echo "no suitable icon found, using default Dina icon.."
else
TICON=$(du -a -h $HOME/.config/dina/webappicons/"$NAME"/*.png | sort -n -r | head -n 1)
ICON="${TICON#*K}"
echo "icon is: $ICON"
fi

echo "
[Desktop Entry]
Version=1.0
Type=Application
Comment="$NAME" webapp powered by Dina
Icon=$ICON
Exec=/usr/bin/dina-browser-direct $ADDRESS & sleep 7 && xdotool search --onlyvisible --class "$ADDRESS" set_window --name "$NAME"
Name="$NAME"
Categories=WebApps;
StartupWMClass=$ADDRESS" | sudo -u $USER tee -a "$HOME/.local/share/applications/$NAME.desktop"
echo "webapp is ready"
notify-send -a Dina -i dina-browser "Your new webapp is ready, enjoy!" "You can launch it from the menu" &
}

choose-name()
{
# choose webapp's name
TITLE="Install website with Dina | step 2/2"
ENTRYLABEL="<b> Enter webapp's name : </b>"
ENTRYTEXT=""
ICON="dina-browser"
scmd=$( yad --width=500 --center --window-icon="$ICON" --borders 15 --name="${0##*/}" --title="$TITLE" --image="install" --entry --entry-label="$ENTRYLABEL" --entry-text="$ENTRYTEXT" --editable --button="<b>  Next</b>"!"media-play"!"complete webapp's creation":0 --button=" Cancel"!"cancel"!"abort and close this dialog":"pkill -f dina-install.sh" )

[[ -z "$scmd" ]] && exit 0

# run command
case $scmd in
   *)
      NAME=$scmd
      echo "chosen webapp's name is: $NAME"
      mkdir -p $HOME/.config/dina/webappicons/"$NAME" &&     
      $HOME/.local/bin/get-favicon $ADDRESS "$NAME" $HOME/.config/dina/webappicons/"$NAME" &&
      write-desktop
esac
}

choose-url()
{
check-app
# choose website to create a webapp for
TITLE="Install website with Dina | step 1/2 "
ENTRYLABEL="<b> Enter webapp's address : </b>"
ENTRYTEXT="https://"
ICON="dina-browser"
rcmd=$( yad --width=500 --center --window-icon="$ICON" --borders 15 --name="${0##*/}" --title="$TITLE" --image="install" --entry --entry-label="$ENTRYLABEL" --entry-text="$ENTRYTEXT" --editable --button="<b>  Next</b>"!"media-play"!"procceed to next step":0 --button="<b>  Remove</b>"!"remove"!"remove existing webapps":"dina-remove-apps.sh" --button=" Cancel"!"cancel"!"close this dialog":"pkill -f dina-install.sh" )

[[ -z "$rcmd" ]] && exit 0

# run command
case $rcmd in
   *)
      space=" |'"
      fullstop="."
      if [[ $rcmd != http* ]] && [[ $rcmd == *"$fullstop"* ]]; then
      ADDRESS="https://"$rcmd
      echo "chosen address is: $ADDRESS"
      elif [[ $rcmd != http* ]] && [[ $rcmd =~ $space ]]; then
      notify-send -a Dina -i dina-browser "Not a valid url, try again.." &
      dina-install.sh &
      exit
      elif [[ $rcmd != http* ]] && [[ $rcmd != *"$fullstop"* ]]; then
      notify-send -a Dina -i dina-browser "Not a valid url, try again.." &
      dina-install.sh &
      exit
      else
      ADDRESS=$rcmd
      echo "chosen web address is: $ADDRESS"
      fi
choose-name 
esac
}

choose-url &
exit
