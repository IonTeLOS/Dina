#! /bin/bash
## /usr/bin/dina-remove-apps.sh

## Copyright: 2023, Ion@TeLOS
## License: GPL-3.0+

# This is a helper script to remove "installed" webapps by deleting corresponding files. 
# Dina is a minimal browser built with tauri and Pake and uses the WebKit rendering engine. 
# Pake is a credited external project with its own license. Learn more about Pake at https://github.com/tw93/Pake
# Dina (https://github.com/iontelos/Dina) is maintained by Ion@TeLOS (teloslinux@protonmail.com). 

notify-send -a Dina -i dina-browser "To remove webapp(s).." "just delete the .desktop files and folders holding the icon and site title" & 
xdg-open $HOME/.local/share/applications
xdg-open $HOME/.config/dina/webappicons
exit
