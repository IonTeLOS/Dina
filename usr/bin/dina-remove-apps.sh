#! /bin/bash
## /usr/bin/dina-remove-apps.sh

# This is a helper script to remove "installed" webapps by deleting corresponding files. 
# Dina is a minimal browser built with tauri and Pake. It uses the webkit rendering engine. 
# Dina (https://github.com/iontelos/Dina) is maintained by Ion@TeLOS (teloslinux@protonmail.com). 
# Pake is a credited external project. Learn more about Pake at https://github.com/tw93/Pake

notify-send -a Dina -i dina-browser "Delete the .desktop files and the folders holding the corresponding icons to remove the app you want" & 
xdg-open $HOME/.local/share/applications
xdg-open $HOME/.config/dina/webappicons
exit
