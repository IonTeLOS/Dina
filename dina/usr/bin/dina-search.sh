#! /bin/bash 
## /usr/bin/dina-search.sh

# This is a helper script to launch a dialog powered by yad (https://github.com/v1cont/yad) and let the user enter keyword(s) to initiate a web search by launching chosen popular search engine using Dina web browser. 
# If yad is not installed a notification informs the user about it and suggests installing it. Yad package installation is "recommended" during Dina's installation. 
# Dina is a minimal browser built with tauri and Pake. It uses the webkit rendering engine. 
# By using this script you can select a popular search engine to use for your web searches with Dina browser. 
# After entering your search terms, the script hands over control to dina.sh script which handles launching Dina browser at the web address of your choice. 
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

choose-searchengine()
{
TITLE="Dina Search"
ICON="dina-browser"
ENGINES=$(yad --width=50 --center --window-icon="$ICON" --borders 15 --name="${0##*/}" --title="$TITLE" --image="find" --form --field="  Choose search engine:CB" Google\!Bing\!Yahoo\!DuckDuckGo\!searX\!Brave\!Wikipedia\!YouTube\!Baidu\!Yandex\!Ecosia --button="<b>Choose</b>"!"find"!"choose a search engine for this search":0 --button="Cancel"!"cancel"!"close this dialog":"pkill -f dina-search.sh")
SELECTION="`echo $ENGINES | cut -d "|" -f 1`"
echo "using '$SELECTION' as search engine this time"
[[ -z "$ENGINES" ]] && exit 0

# run command
case $ENGINES in
   *)
      if [ $SELECTION == "Google" ]
      then
      SEARCHENGINE="https://www.google.com/search?q="
      fi
      if [ $SELECTION == "Bing" ]
      then
      SEARCHENGINE="https://bing.com/search?q="
      fi
      if [ $SELECTION == "Yahoo" ]
      then
      SEARCHENGINE="https://search.yahoo.com/search?p="
      fi
      if [ $SELECTION == "DuckDuckGo" ]
      then
      SEARCHENGINE="https://duckduckgo.com/?va=n&t=h_&q=$scmd"
      fi
      if [ $SELECTION == "searX" ]
      then
      SEARCHENGINE="https://paulgo.io/search?q="
      fi
      if [ $SELECTION == "Brave" ]
      then
      SEARCHENGINE="https://search.brave.com/search?q="
      fi
      if [ $SELECTION == "Wikipedia" ]
      then
      SEARCHENGINE="https://www.wikipedia.org/wiki/"
      fi
      if [ $SELECTION == "YouTube" ]
      then
      SEARCHENGINE="https://www.youtube.com/results?search_query="
      fi
      if [ $SELECTION == "Baidu" ]
      then
      SEARCHENGINE="https://www.baidu.com/s?wd="
      fi
      if [ $SELECTION == "Yandex" ]
      then
      SEARCHENGINE="https://yandex.ru/search/?text="
      fi
      if [ $SELECTION == "Ecosia" ]
      then
      SEARCHENGINE="https://www.ecosia.org/search?method=index&q="
      fi
      searchweb      
esac

exit 0
}

searchweb()
{

fullstop="."

TITLE="Dina Search"
ENTRYLABEL="<b>Search the Internet for.. :</b>"
ENTRYTEXT="type here"
ICON="dina-browser"
scmd=$( yad --width=35 --center --window-icon="$ICON" --borders 15 --name="${0##*/}" --title="$TITLE" --image="search" --entry --entry-label="$ENTRYLABEL" --entry-text="$ENTRYTEXT" --editable --button="<b>Search</b>"!"find"!"start your Internet search":0 --button="<b>Change</b>"!"edit"!"change your default search engine":"bash -c dina-settings.sh searchengine" --button="Cancel"!"cancel"!"close this dialog":"pkill -f dina-search.sh" )

[[ -z "$scmd" ]] && exit 0

# run command
case $scmd in
   *) 
      if [[ $scmd = https://* ]] && [[ $scmd == *"$fullstop"* ]]; then
      dina-browser-direct $scmd &
      echo "a url has been entered, skipping search, opening url.." &
      exit
      fi
      
      dina-browser-direct $SEARCHENGINE"$scmd" &
      echo "opening url.." &
      echo $SEARCHENGINE$scmd &
      exit

esac

exit 0
}

DEFAULTENGINE=$HOME/.config/dina/searchengine.txt
if test -f "$DEFAULTENGINE"
then
SEARCHENGINE=$(head -n 1 $HOME/.config/dina/searchengine.txt)
searchweb &
echo "using default search engine: $SEARCHENGINE"
else
choose-searchengine &
fi

exit
