#! /bin/bash 
## /usr/bin/dina-search.sh

# This is a helper script to launch a dialog powered by yad (https://github.com/v1cont/yad) for the user to manage some basic Dina settings. 
# If yad is not installed a notification informs the user about it and suggests installing it. Yad package installation is "recommended" during Dina's installation. 
# Dina is a minimal browser built with tauri and Pake. It uses the webkit rendering engine. 
# By using this script you can select startpage behavior, making search engine default, resetting startpage and adding Dina to autostart programs for kiosk-like use.  
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

startpage()
{
mkdir -p ~/.config/dina

TITLE="Dina Settings"
ENTRYLABEL="<b>Set your startpage : </b>"
ENTRYTEXT="type here"
ICON="dina-browser"
hcmd=$( yad --width=500 --center --window-icon="$ICON" --borders 15 --name="${0##*/}" --title="$TITLE" --image="home" --entry --entry-label="$ENTRYLABEL" --entry-text="$ENTRYTEXT" --editable --button="<b>  Set</b>"!"media-play"!"click here to set startpage":0 --button="<b>  Remove</b>"!"remove"!"Remove startpage and use default behaviour":"rm $HOME/.config/dina/startpage.txt" --button=" Cancel"!"cancel"!"close this dialog":"pkill -f dina-settings.sh" )

[[ -z "$hcmd" ]] && exit 0

# run command
case $hcmd in
   *)
      space=" |'"
      fullstop="."
      if [[ $hcmd != http* ]] && [[ $hcmd == *"$fullstop"* ]]; then
      touch -a $HOME/.config/dina/startpage.txt
      echo "https://"$hcmd > ~/.config/dina/startpage.txt &
      notify-send -a Dina -i dina-browser "Startpage has been set"
      exit
      fi
      if [[ $hcmd != http* ]] && [[ $hcmd =~ $space ]]; then
      notify-send -a Dina -i dina-browser "This is not a valid url, try again.."
      exit
      fi
      if [[ $hcmd != http* ]] && [[ $hcmd != *"$fullstop"* ]]; then
      notify-send -a Dina -i dina-browser "This is not a valid url, try again.."
      exit
      else
      touch -a $HOME/.config/dina/startpage.txt
      echo $hcmd > ~/.config/dina/startpage.txt &
      notify-send -a Dina -i dina-browser "Startpage has been set"
      exit
      fi
esac

exit 0
}

searchengine()
{

mkdir -p ~/.config/dina

TITLE="Dina Settings"
ENTRYLABEL="<b>Choose your search engine : </b>"
ENTRYTEXT="type here"
ICON="dina-browser"
ENGINES=$(yad --width=50 --center --window-icon="$ICON" --borders 15 --name="${0##*/}" --title="$TITLE" --image="find" --form --field="  Choose search engine:CB" Google\!Bing\!Yahoo\!DuckDuckGo\!searX\!Brave\!Wikipedia\!YouTube\!Baidu\!Yandex\!Ecosia --button="<b>Choose</b>"!"find"!"choose a search engine":0 --button="<b>  Remove</b>"!"remove"!"remove default searchengine":"rm $HOME/.config/dina/searchengine.txt" --button="Cancel"!"cancel"!"close this dialog":"pkill -f dina-settings.sh")
SELECTION="`echo $ENGINES | cut -d "|" -f 1`"
echo "using '$SELECTION' search engine"
notify-send -a Dina -i dina-browser "Default search engine has been set"
[[ -z "$ENGINES" ]] && exit 0

# run command
case $ENGINES in
   *)
      if [ $SELECTION == "Google" ]
      then
      touch -a $HOME/.config/dina/searchengine.txt
      echo "https://www.google.com/search?q=" > ~/.config/dina/searchengine.txt &
      exit
      fi
      if [ $SELECTION == "Bing" ]
      then
      touch -a $HOME/.config/dina/searchengine.txt
      echo "https://bing.com/search?q=" > ~/.config/dina/searchengine.txt &
      exit
      fi
      if [ $SELECTION == "Yahoo" ]
      then
      touch -a $HOME/.config/dina/searchengine.txt
      echo "https://search.yahoo.com/search?p=" > ~/.config/dina/searchengine.txt &
      exit
      fi
      if [ $SELECTION == "DuckDuckGo" ]
      then
      touch -a $HOME/.config/dina/searchengine.txt
      echo "https://duckduckgo.com/?va=n&t=h_&q=$scmd" > ~/.config/dina/searchengine.txt &
      exit
      fi
      if [ $SELECTION == "searX" ]
      then
      touch -a $HOME/.config/dina/searchengine.txt
      echo "https://paulgo.io/search?q=" > ~/.config/dina/searchengine.txt &
      exit
      fi
      if [ $SELECTION == "Brave" ]
      then
      touch -a $HOME/.config/dina/searchengine.txt
      echo "https://search.brave.com/search?q=" > ~/.config/dina/searchengine.txt &
      exit
      fi
      if [ $SELECTION == "Wikipedia" ]
      then
      touch -a $HOME/.config/dina/searchengine.txt
      echo "https://www.wikipedia.org/wiki/" > ~/.config/dina/searchengine.txt &
      exit
      fi
      if [ $SELECTION == "YouTube" ]
      then
      touch -a $HOME/.config/dina/searchengine.txt
      echo "https://www.youtube.com/results?search_query=" > ~/.config/dina/searchengine.txt &
      exit
      fi
      if [ $SELECTION == "Baidu" ]
      then
      touch -a $HOME/.config/dina/searchengine.txt
      echo "https://www.baidu.com/s?wd=" > ~/.config/dina/searchengine.txt &
      exit
      fi
      if [ $SELECTION == "Yandex" ]
      then
      touch -a $HOME/.config/dina/searchengine.txt
      echo "https://yandex.ru/search/?text=" > ~/.config/dina/searchengine.txt &
      exit
      fi
      if [ $SELECTION == "Ecosia" ]
      then
      touch -a $HOME/.config/dina/searchengine.txt
      echo "https://www.ecosia.org/search?method=index&q=" > ~/.config/dina/searchengine.txt &
      exit
      fi
      
esac

exit 0
}


choosesetting()
{
TITLE="Dina Settings"
ICON="dina-browser"
SETS=$(yad --width=50 --center --window-icon="$ICON" --borders 15 --name="${0##*/}" --title="$TITLE" --image="settings" --form --field="  Choose what to change:CB" Startpage\!Search-engine\!Reset-startpage\!Autostart\!Cancel-autostart)
SELECTION="`echo $SETS | cut -d "|" -f 1`"
echo "using '$SELECTION' setting"

if [[ $SELECTION == "Startpage" ]]
then
startpage
exit
fi

if [[ $SELECTION == "Search-engine" ]]
then
searchengine
exit
fi

if [[ $SELECTION == "Reset-startpage" ]]
then
rm $HOME/.config/dina/startpage.txt
cp /usr/bin/templates/index-backup.html /usr/bin/templates/index.html &&
notify-send -a Dina -i dina-browser "Startpage succesfully reset"
exit
fi

if [[ $SELECTION == "Autostart" ]]
then
mkdir -p /home/$USER/.config/autostart
cp /usr/share/applications/dina-fullscreen.desktop /home/$USER/.config/autostart/ &&
notify-send -a Dina -i dina-browser "Dina will autostart in fullscreen next time you log in"
exit
fi

if [[ $SELECTION == "Cancel-autostart" ]]
then
rm /home/$USER/.config/autostart/dina-fullscreen.desktop &&
notify-send -a Dina -i dina-browser "Dina autostart cancelled"
exit
fi

exit 0
}

export -f startpage
export -f searchengine

choosesetting &
exit