#! /bin/bash
## /usr/bin/dina-title.sh

# This is a helper script to set the window title for Dina web browser. 
# Dina is a minimal browser built with tauri and Pake. It uses the webkit rendering engine. 
# Dina (https://github.com/iontelos/Dina) is maintained by Ion@TeLOS (teloslinux@protonmail.com). 
# Pake is a credited external project. Learn more about Pake at https://github.com/tw93/Pake

xdotool search --onlyvisible --class "dina" set_window --name ""$USER"@Dina"
echo "Dina window title set"
exit
