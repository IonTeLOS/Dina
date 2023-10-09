#! /bin/bash 
## /usr/bin/dina-search.sh

# This is a helper script to launch a dialog powered by yad (https://github.com/v1cont/yad) and let the user enter keyword(s) to initiate a web search by launching chosen popular search engine using Dina web browser. 
# If yad is not installed a notification informs the user about it and suggests installing it. Yad package installation is "recommended" during Dina's installation. 
# Dina is a minimal browser built with tauri and Pake. It uses the webkit rendering engine. 
# By using this script you can select a popular search engine to use for your web searches with Dina browser. 
# After entering your search terms, the script hands over control to dina.sh script which handles launching Dina browser at the web address of your choice. 
# Dina (https://github.com/iontelos/Dina) is maintained by Ion@TeLOS (teloslinux@protonmail.com). 
# Pake is a credited external project. Learn more about Pake at https://github.com/tw93/Pake

searchweb()
{
TITLE="Dina Search"
ICON="dina-browser"
ENGINES=$(yad --width=50 --center --window-icon="$ICON" --borders 15 --name="${0##*/}" --title="$TITLE" --image="epiphany-browser" --form --field="  Choose search engine:CB" Google\!Bing\!Yahoo\!DuckDuckGo\!searX\!Brave\!Wikipedia\!YouTube\!Baidu\!Yandex\!Ecosia)
SELECTION="`echo $ENGINES | cut -d "|" -f 1`"
echo "using '$SELECTION' search engine"

fullstop="."

TITLE="Dina Search"
ENTRYLABEL="<b>Search the Internet for.. :</b>"
ENTRYTEXT="type here"
ICON="dina-browser"
scmd=$( yad --width=35 --center --window-icon="$ICON" --borders 15 --name="${0##*/}" --title="$TITLE" --image="epiphany-browser" --entry --entry-label="$ENTRYLABEL" --entry-text="$ENTRYTEXT" --editable --button="<b>Search</b>"!"find"!"click here to start your search":0 --button="Cancel"!"cancel"!"close this dialog":"pkill -f dina-search.sh" )

[[ -z "$scmd" ]] && exit 0

# run command
case $scmd in
   *)
      if [[ $scmd = https://* ]] && [[ $scmd == *"$fullstop"* ]]; then
      /usr/bin/dina.sh $scmd &
      exit
      fi
      if [ $SELECTION == "Google" ]
      then
      /usr/bin/dina.sh "https://www.google.com/search?q=$scmd"
      exit
      fi
      if [ $SELECTION == "Bing" ]
      then
      /usr/bin/dina.sh "https://bing.com/search?q=$scmd"
      exit
      fi
      if [ $SELECTION == "Yahoo" ]
      then
      /usr/bin/dina.sh "https://search.yahoo.com/search?p=$scmd"
      exit
      fi
      if [ $SELECTION == "DuckDuckGo" ]
      then
      /usr/bin/dina.sh "https://duckduckgo.com/?va=n&t=h_&q=$scmd"
      exit
      fi
      if [ $SELECTION == "searX" ]
      then
      /usr/bin/dina.sh "https://paulgo.io/search?q=$scmd"
      exit
      fi
      if [ $SELECTION == "Brave" ]
      then
      /usr/bin/dina.sh "https://search.brave.com/search?q=$scmd"
      exit
      fi
      if [ $SELECTION == "Wikipedia" ]
      then
      /usr/bin/dina.sh "https://www.wikipedia.org/wiki/$scmd"
      exit
      fi
      if [ $SELECTION == "YouTube" ]
      then
      /usr/bin/dina.sh "https://www.youtube.com/results?search_query=$scmd"
      exit
      fi
      if [ $SELECTION == "Baidu" ]
      then
      /usr/bin/dina.sh "https://www.baidu.com/s?wd=$scmd&rsv_spt=3&rsv_bp=0&ie=utf-8&tn=baiduhome_pg"
      exit
      fi
      if [ $SELECTION == "Yandex" ]
      then
      /usr/bin/dina.sh "https://yandex.ru/search/?text=$scmd"
      exit
      fi
      if [ $SELECTION == "Ecosia" ]
      then
      /usr/bin/dina.sh "https://www.ecosia.org/search?method=index&q=$scmd"
      exit
      else
      /usr/bin/dina.sh "https://www.google.com/search?q=$scmd"
      exit
      fi
      
esac

exit 0
}

searchweb &
exit
