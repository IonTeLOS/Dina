#! /bin/bash
## /usr/bin/dina-title.sh

## Copyright: 2023, Ion@TeLOS
## License: GPL-3.0+

# This is a helper script to set the window title for Dina web browser. 
# Dina is a minimal browser built with tauri and Pake and uses the WebKit rendering engine. 
# Pake is a credited external project with its own license. Learn more about Pake at https://github.com/tw93/Pake
# Dina (https://github.com/iontelos/Dina) is maintained by Ion@TeLOS (teloslinux@protonmail.com). 

xdotool search --onlyvisible --class "dina" set_window --name ""$USER"@Dina"
echo "Dina window title set"
exit

