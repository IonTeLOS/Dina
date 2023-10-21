# Dina
Dina - tiny web browser for Linux

This little project is actually a small collection of bash scripts (optionally visualized with the help of yad, command line access is included). Pake https://github.com/tw93/Pake , which is built on tauri, is used in the background. WebKit is the rendering engine.

The idea is simple: A flask server runs on localhost and serves a local html file that redirects to the web address that the user chose as startpage. User's choice is done with the help of a dialog or at the command line. The startpage last chosen serves as startpage when the app is launched again, until a new choice is made or a permanent startpage is set. 

Dina supports bookmarks, searching the Internet with several popular (and some unpopular!) search engines, fullscreen autostart ("kiosk mode") and webapp creation, that means creating .desktop files that serve as menu shortcuts for websites. Bear in mind that all these "apps" plus Dina itself share the same profile and cookies. Naturally, this profile is separate from the profile in your other browsers. Dina supports clearing the cache and re-initializing the application. 

Take a look at Dina-core repository https://github.com/IonTeLOS/Dina-core, a fork of Pake, to get an idea about the backend of Dina. The executable of Dina is prebuilt (locally or on GitHub Actions) and points at localhost, port 8001. You can build your own Dina-core following Pake instructions. This project is not affiliated with Pake. Icons for webapps are sourced from the Internet with the help of get-favicon app (https://github.com/IonTeLOS/get-favicon), which is downloaded at runtime. The .deb package of Dina itself is built using dpkg-buildpackage. Dina Browser has been tested and has been found to be working in Debian and Ubuntu, including stable, testing and unstable branches. It should work on other Debian-based distributions too. Please report any issues you may face. Suggestions are welcome. 

The goal of Dina is to offer a modern, minimalistic browser, which has a very small download size (less than 5 MB), small installed size (approx. 23 MB ) and few dependencies. Most essential components - dependencies are typically already present in a modern Linux system (particularly on gtk based desktop environments) and are frequently updated anyway. This means that Dina can easily serve the purpose of a second, auxilliary browser, a webapp creation tool or a browser for a kiosk setup.

My near future plans include experimenting with luakit as backend for the same end goal. pyQt5WebEngine is also in the radar and I may share a not-so-tiny project I am working on.

Dina now supports two extensions: 
- DinaTerm, the terminal emulator https://github.com/IonTeLOS/dinaterm, which enables you to run a fully functional terminal in the browser powered by pyxterm.js
- DinaFiles, the file manager https://github.com/IonTeLOS/dinafiles is a complete file manager inside Dina powered by filebrowser

both extensions can optionally run on your "other" browser too

More extensions may follow. 

Dina is not low on memory resources though. Nobody is perfect..

see the command-line options: dina-browser --help

To add the repository to install Dina and keep it updated :

wget -qO - https://iontelos.github.io/appy/KEY.gpg | sudo gpg --dearmor -o /usr/share/keyrings/appy.gpg

sudo curl -s --compressed -o /etc/apt/sources.list.d/telos.list "https://iontelos.github.io/appy/telos.list"

sudo apt clean

sudo apt update

sudo apt install dina
