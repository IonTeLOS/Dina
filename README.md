# Dina
Dina - tiny web browser for Linux

This little project is actually a small collection of bash scripts (visualized with the help of yad). Pake ( which is built on tauri )  is used in the background. Webkit is the rendering engine.

The idea is simple: A flask server runs on localhost and serves a local html file that redirects to the web address the user each chooses as startpage. User's choice is done with the help of a dialog. The startpage last chosen serves as a homepage when the app is launched again, until a new choice is made. 

Dina supports bookmarks, searching the Internet with several popular (and some unpopular!) search engines and webapp installation, ie. creating .desktop files that serve as a menu shortcut for any user-favorite websites. Bear in mind that all these "apps" plus Dina share the same profile and cookies. 

Take a look at Dina-core repository https://github.com/IonTeLOS/Dina-core (a fork of Pake https://github.com/tw93/Pake) to get an idea about the backend of Dina. The executable of Dina is prebuilt (locally or on Github Actions) and points at localhost, port 8001. You can build your own following Pake instructions. This project is not affiliated with Pake. Icons for webapps are sourced from the Internet with the help of get-favicon (https://github.com/IonTeLOS/get-favicon), which is downloaded at runtime. The .deb package of Dina is built using dpkg-deb. It has been tested and has been found to be working in Debian and Ubuntu, stable, testing and unstable. PLease report any issues you may find.

The basic idea behind Dina is to have a modern minimalistic browser which has a very small download size (less than 6 MB) and small installed size (approx. 23 MB - most essential extra components - dependencies are typically already present in a modern Linux system). This means that Dina can easily serve the purpose of a second, auxilliary browser.

My plans include experimenting also with luakit as backend for the same end goal. pyQtWebEngine is also in the radar and I may share a not-so-tiny effort I am working on.

Dina is not low on memory resources though. Nobody is perfect..

dina.deb is hosted on packagecloud
add the repository: 
curl -s https://packagecloud.io/install/repositories/ion/telos/script.deb.sh | sudo bash
update - install dina
