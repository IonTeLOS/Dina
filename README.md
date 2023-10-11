# Dina
Dina - tiny web browser for Linux

This little project is actually a small collection of bash scripts (visualized with the help of yad). Pake ( which is built on tauri )  is used in the background. Webkit is the rendering engine.

The idea is simple: A flask server runs on localhost and serves a local html file that redirects to the web address that the user chose as startpage. User's choice is done with the help of a dialog or in the command line. The startpage last chosen serves as startpage when the app is launched again, until a new choice is made or a permanent startpage is set. 

Dina supports bookmarks, searching the Internet with several popular (and some unpopular!) search engines, configuring fullscreen autostart ("kiosk mode") and webapp creation, that means creating .desktop files that serve as a menu shortcut for any user-favorite websites. Bear in mind that all these "apps" plus Dina itself share the same profile and cookies. Naturally, this profile is separate from the profile in your other browsers. Dina supports clearing the cache and re-initializing the application. Dina also supports some command line arguments to configure its behavior.

Take a look at Dina-core repository https://github.com/IonTeLOS/Dina-core (a fork of Pake https://github.com/tw93/Pake) to get an idea about the backend of Dina. The executable of Dina is prebuilt (locally or on GitHub Actions) and points at localhost, port 8001. You can build your own Dina-core following Pake instructions. This project is not affiliated with Pake. Icons for webapps are sourced from the Internet with the help of get-favicon (https://github.com/IonTeLOS/get-favicon), which is downloaded at runtime. The .deb package of Dina is built using dpkg-deb. It has been tested and has been found to be working in Debian and Ubuntu, including stable, testing and unstable branches. It should work on other Debian-based distributions too. Please report any issues you may face.

The basic idea behind Dina is to have a modern, minimalistic browser, which has a very small download size (less than 5 MB) and small installed size (approx. 23 MB ) and few dependencies. Most essential components - dependencies are typically already present in a modern Linux system) and are frequently updated anyway. This means that Dina can easily serve the purpose of a second, auxilliary browser or a browser for a kiosk setup.

My near future plans include experimenting with luakit as backend for the same end goal. pyQt5WebEngine is also in the radar and I may share a not-so-tiny effort I am working on.

Dina is not low on memory resources though. Nobody is perfect..

dina.deb is hosted on packagecloud
add the repository: 

curl -s https://packagecloud.io/install/repositories/ion/telos/script.deb.sh | sudo bash

sudo apt-get update 

sudo apt-get install dina
