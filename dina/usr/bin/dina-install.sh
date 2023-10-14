#! /bin/bash 
## /usr/bin/dina-install.sh

## Copyright: 2023, Ion@TeLOS
## License: GPL-3.0+

# This is a helper script to launch a dialog powered by yad (https://github.com/v1cont/yad) and let the user choose a website to "install", that is to create a .desktop file - shortcut, so that the user can launch the website from the system menu. The website will be opened in Dina. All site shortcuts (and Dina itself) share the same profile and cookies. Yad package installation is "recommended" during Dina's installation. 
# If yad dialog app is not installed, a notification informs the user about it and suggests installing it. Yad package installation is "recommended" during Dina's installation.
# Dina is a minimal browser built with tauri and Pake and uses the WebKit rendering engine. 
# A separate app (https://github.com/iontelos/webapp-helper) is downloaded at runtime to fetch suitable website favicons from the Internet and get the site's title. webapp-helper is saved in your ~/.locan/bin/ directory.
# Pake is a credited external project with its own license. Learn more about Pake at https://github.com/tw93/Pake
# Dina (https://github.com/iontelos/Dina) is maintained and packaged by Ion@TeLOS (teloslinux@protonmail.com). 

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
HELPER=/home/$USER/.local/bin/webapp-helper
if test -f "$HELPER"; then
    echo "$HELPER is installed, continuing.."
else
echo "downloading webapp-helper app from GitHub, please wait.."
notify-send -a Dina -i dina-browser "Please wait.." "downloading additional required component" &
wget https://github.com/IonTeLOS/webapp-helper/releases/download/public/webapp-helper -O $HOME/.local/bin/webapp-helper && 
chmod a+x $HOME/.local/bin/webapp-helper
fi
}

write-desktop()
{
echo "
[Desktop Entry]
Version=1.0
Type=Application
Comment=Webapp of "$DOMAIN" powered by Dina
Icon=$ICON
Exec=/usr/bin/dina-browser-direct $ADDRESS & sleep 7 && xdotool search --onlyvisible --class "$DOMAINAME" set_window --name "$NAME"
Name="$NAME"
Categories=WebApps;Network;
StartupWMClass=$DOMAINAME" | sudo -u $USER tee -a "$HOME/.local/share/applications/$DOMAINAME.desktop"
sleep 2 &&
chmod a+x $HOME/.local/share/applications/$DOMAINAME.desktop
update-desktop-database &
echo "webapp is ready, launching.."
notify-send -a Dina -i dina-browser "Your new webapp is ready, enjoy!" "Launching.." &
/usr/bin/dina-browser-direct $ADDRESS & sleep 7 && xdotool search --onlyvisible --class "$DOMAINAME" set_window --name "$NAME"
Name="$NAME" &
exit
}

choose-name()
{
notify-send -a Dina -i dina-browser "Working in the background" "Please wait.." &
DOMAIN=$(basename $ADDRESS)
DOMAINAME=$(basename $ADDRESS | sed 's/\.//g')
mkdir -p $HOME/.config/dina/webappicons/"$DOMAINAME" &&
      
$HOME/.local/bin/webapp-helper $ADDRESS "$DOMAINAME" $HOME/.config/dina/webappicons/"$DOMAINAME" || true
      
APPTITLE=$(head -n 2 $HOME/.config/dina/webappicons/"$DOMAINAME"/site-title.txt)
if [[ ${#APPTITLE} -gt 120 ]] || [[ ${#APPTITLE} -le 1 ]]
then 
APPTITLE="Webapp of $DOMAIN"
fi

# choose webapp's name
TITLE="Install website with Dina | step 2/2"
ENTRYLABEL="<b> Enter webapp's name or directly click Next to use site's title : </b>"
ENTRYTEXT="*Title*"
ICON="dina-browser"
scmd=$( yad --width=500 --center --window-icon="$ICON" --borders 15 --name="${0##*/}" --title="$TITLE" --image="install" --entry --entry-label="$ENTRYLABEL" --entry-text="$ENTRYTEXT" --editable --button="<b>  Next</b>"!"media-play"!"complete webapp's creation":0 --button=" Cancel"!"cancel"!"abort and close this dialog":"pkill -f dina-install.sh" )

[[ -z "$scmd" ]] && exit 0

# run command
case $scmd in
   *) 
      du -a -h $HOME/.config/dina/webappicons/"$DOMAINAME"/*.png
      if [ $? -eq 1 ]
      then
      ICON=dina-browser
      echo "no suitable icon found, using default Dina icon.."
      else
      TICON=$(du -a -h $HOME/.config/dina/webappicons/"$DOMAINAME"/*.png | sort -n -r | head -n 1)
      ICON="${TICON#*K}"
      echo "icon is: $ICON"
      fi
      NAME=$scmd
      n=${#NAME}
      if [[ n -lt 2 ]] || [[ $NAME == *Title* ]]
      then
      NAME=$APPTITLE
      fi
      echo "chosen webapp's name is: $NAME"
      write-desktop &&
      exit
esac
}

choose-url()
{
check-app
# choose website to create a webapp for
TITLE="Install website with Dina | step 1/2 "
ENTRYLABEL="<b> Enter website's address : </b>"
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

choose-url
exit
