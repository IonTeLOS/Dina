#! /bin/bash 
## /usr/bin/dina-search.sh

## Copyright: 2023, Ion@TeLOS
## License: GPL-3.0+

# This is a helper script to launch a dialog powered by yad (https://github.com/v1cont/yad) for the user to manage some basic Dina browser settings. 
# If yad is not installed, a notification informs the user about it and suggests installing it. Yad package installation is "recommended" during Dina's installation. 
# Dina is a minimal browser built with tauri and Pake and uses the WebKit rendering engine. 
# By using this script you can select startpage behavior, making search engine default, resetting startpage, global reset to reinitialize app and adding/removing Dina to/from autostart programs for kiosk-like use.  
# Pake is a credited external project with its own license. Learn more about Pake at https://github.com/tw93/Pake
# Dina (https://github.com/iontelos/Dina) is maintained by Ion@TeLOS (teloslinux@protonmail.com). 

ARGUMENT=$1

YAD=/usr/bin/yad
if test -f "$YAD"; then
    echo "yad is installed, continuing.."
else
echo "yad is not installed, exiting.."
notify-send -a Dina "Install yad to use this feature" -i dina-browser &
exit
fi

DINATERM=/usr/bin/dinaterm

if [[ $ARGUMENT = --dinaterm ]]
then
if test -f "$DINATERM"; 
then
echo "dinaterm is installed, launching it.."
dinaterm &
exit
else
echo "dinaterm is not installed"
notify-send -a Dina -i dina-browser "Install DinaTerm extension to use this feature" &
yad --window-icon=dina-browser --center --on-top --title="Get this Dina extension" --image=terminal --borders=10 --timeout=25 --timeout-indicator="bottom" --text="\n\t<b>Install DinaTerm extension to enjoy a fully functional terminal running inside Dina Browser! \n\nYou will be prompted to enter your password</b>" --width 400;result=$?;echo $result &
fi
if [[ $result -eq 0 ]]
then
notify-send -a Dina -i dina-browser "Adding a new extension to Dina" "please wait and enter password when needed.."
wget https://github.com/IonTeLOS/dinaterm/releases/download/local/dinaterm_0.1-1_amd64.deb -O /tmp/dinaterm.deb &&
pkexec apt-get install /tmp/dinaterm.deb -y &&
notify-send -a Dina -i dina-browser "DinaTerm Extension has been added, launching.."
dinaterm &
exit
else
echo "	You canceled extension's installation"
exit
fi
fi

DINAFILES=/usr/bin/dinafiles

if [[ $ARGUMENT = --dinafiles ]]
then
if test -f "$DINAFILES"; 
then
echo "dinafiles is installed, launching it.."
dinafiles &
exit
else
echo "dinafiles is not installed"
notify-send -a Dina -i dina-browser "Install DinaFiles extension to use this feature" &
yad --window-icon=dina-browser --center --on-top --title="Get this Dina extension" --image=terminal --borders=10 --timeout=25 --timeout-indicator="bottom" --text="\n\t<b>Install DinaFiles extension to enjoy a file manager inside Dina Browser! \n\nYou will be prompted to enter your password</b>" --width 400;result=$?;echo $result &
fi
if [[ $result -eq 0 ]]
then
notify-send -a Dina -i dina-browser "Adding a new extension to Dina" "please wait and enter password when needed.."
wget https://github.com/IonTeLOS/dinafiles/releases/download/local/dinafiles_0.1-1_amd64.deb -O /tmp/dinafiles.deb &&
pkexec apt-get install /tmp/dinafiles.deb -y &&
notify-send -a Dina -i dina-browser "DinaFiles Extension has been added, launching.."
dinafiles &
exit
else
echo "	You canceled extension's installation"
exit
fi
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
ENGINES=$(yad --width=50 --center --window-icon="$ICON" --borders 15 --name="${0##*/}" --title="$TITLE" --image="find" --form --field="  Choose search engine:CB" Google\!Bing\!Yahoo\!DuckDuckGo\!searX\!Brave\!Wikipedia\!YouTube\!Baidu\!Yandex\!Naver\!Ecosia --button="<b>Choose</b>"!"find"!"choose a search engine":0 --button="<b>  Remove</b>"!"remove"!"remove default searchengine":"rm $HOME/.config/dina/searchengine.txt" --button="Cancel"!"cancel"!"close this dialog":"pkill -f dina-settings.sh")
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
      if [ $SELECTION == "Naver" ]
      then
      touch -a $HOME/.config/dina/searchengine.txt
      echo "https://search.naver.com/search.naver?where=nexearch&query=" > ~/.config/dina/searchengine.txt &
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

extend()
{
TITLE="Dina Settings"
ICON="dina-browser"
EXTENSIONS=$(yad --width=50 --center --window-icon="$ICON" --borders 15 --name="${0##*/}" --title="$TITLE" --image="settings" --form --field="  Extend Dina:CB" Terminal\!Files\!More-coming-soon..)
SEL="`echo $EXTENSIONS | cut -d "|" -f 1`"
echo "selected '$SEL' extension"

[[ -z "$EXTENSIONS" ]] && exit 0

# run command
case $EXTENSIONS in
   *)
   
if [[ $SEL == "Terminal" ]]
then
termi=/usr/bin/dinaterm
if test -f "$termi"; then
    echo "DinaTerm is already installed, exiting.."
    notify-send -a Dina -i dina-browser "DinaTerm is already installed, exiting.." &
    exit
fi    
notify-send -a Dina -i dina-browser "Enter your password when prompted" "to complete installation of selected extension"
wget https://github.com/IonTeLOS/dinaterm/releases/download/local/dinaterm_0.1-1_amd64.deb -O /tmp/dinaterm.deb &&
pkexec apt-get install /tmp/dinaterm.deb -y &&
notify-send -a Dina -i dina-browser "DinaTerm Extension has been added"
dinaterm &
exit
fi

if [[ $SEL == "Files" ]]
then
filebr=$HOME/.local/bin/filebrowser
if test -f "$filebr"; then
    echo "DinaFiles is already installed, exiting.."
    notify-send -a Dina -i dina-browser "DinaFiles is already installed, exiting.." &
    exit
fi    
notify-send -a Dina -i dina-browser "Enter your password when prompted" "to complete installation of selected extension"
wget https://github.com/IonTeLOS/dinafiles/releases/download/local/dinafiles_0.1-1_amd64.deb -O /tmp/dinafiles.deb &&
pkexec apt-get install /tmp/dinafiles.deb -y &&
notify-send -a Dina -i dina-browser "DinaFiles Extension has been added"
dinafiles &
exit
fi

if [[ $SEL == "More-coming-soon.." ]]
then
notify-send -a Dina -i dina-browser "Stay tuned and keep using Dina" "to discover more extension options.."
exit
fi

esac
exit
}

startup()
{
TITLE="Dina Settings"
ICON="dina-browser"
MODES=$(yad --width=50 --center --window-icon="$ICON" --borders 15 --name="${0##*/}" --title="$TITLE" --image="settings" --form --field="  Choose a startup mode:CB" Browser-Default\!Search\!Navigate\!Webapp)
SELECTING="`echo $MODES | cut -d "|" -f 1`"
echo "using '$SELECTING' startup mode"

[[ -z "$MODES" ]] && exit 0

# run command
case $MODES in
   *)
   
if [[ $SELECTING == "Browser-Default" ]]
then
rm $HOME/.config/dina/searchmode &
rm $HOME/.config/dina/navmode &
rm $HOME/.config/dina/appmode &
notify-send -a Dina -i dina-browser "Browser startup mode chosen"
exit
fi

if [[ $SELECTING == "Search" ]]
then
mkdir -p $HOME/.config/dina &
rm $HOME/.config/dina/navmode &
rm $HOME/.config/dina/appmode &
touch $HOME/.config/dina/searchmode &&
notify-send -a Dina -i dina-browser "Search startup mode chosen"
exit
fi

if [[ $SELECTING == "Navigate" ]]
then
mkdir -p $HOME/.config/dina &
rm $HOME/.config/dina/searchmode &
rm $HOME/.config/dina/appmode &
touch $HOME/.config/dina/navmode &&
notify-send -a Dina -i dina-browser "Navigation startup mode chosen"
exit
fi

if [[ $SELECTING == "Webapp" ]]
then
mkdir -p $HOME/.config/dina &
rm $HOME/.config/dina/searchmode &
rm $HOME/.config/dina/navmode &
touch $HOME/.config/dina/appmode &&
notify-send -a Dina -i dina-browser "Webapp startup mode chosen"
exit
fi
esac
exit
}

choosesetting()
{
TITLE="Dina Settings"
ICON="dina-browser"
SETS=$(yad --width=50 --center --window-icon="$ICON" --borders 15 --name="${0##*/}" --title="$TITLE" --image="settings" --form --field="  Choose what to change:CB" Startpage\!Search-engine\!Extensions\!Startup-mode\!Reset-startpage\!Autostart\!Cancel-autostart)
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

if [[ $SELECTION == "Extensions" ]]
then
extend
exit
fi

if [[ $SELECTION == "Startup-mode" ]]
then
startup
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
