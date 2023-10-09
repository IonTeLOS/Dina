#! /bin/bash
## /usr/bin/dina.sh

# This is a helper script to start Dina web browser. Dina is a minimal browser built with tauri and Pake. It uses the webkit rendering engine. 
# This script launches a local server using flask and opens Dina in localhost to redirect to the url user-chosen url. If no url is chosen, Dina opens last chosen url or the default url at first launch. After launch the server instance is terminated.
# Dina (https://github.com/iontelos/Dina) is maintained by Ion@TeLOS (teloslinux@protonmail.com). 
# Pake is a credited external project. Learn more about Pake at https://github.com/tw93/Pake

url=$1
if [ "$url" != "" ]
then
truncate -s 0 /usr/bin/templates/index.html
echo -e '<!DOCTYPE html>\n<html> \n<head>\n<title>Google</title>\n<meta charset="UTF-8" /> \n<meta http-equiv="refresh" content="0; URL='$url'">\n</head>\n<body>\n<p><b>Loading..</b></p>\n</body>\n</html>' >> /usr/bin/templates/index.html &&
python3 /usr/bin/dina-run-flask.py &
sleep 1 &&
/usr/bin/dina &
sleep 5 &&
/usr/bin/dina-title.sh
ps -ef | grep "dina-run-flask" | awk '{print $2}' | xargs kill &
exit
else
echo "loading last user's choice.."
python3 /usr/bin/dina-run-flask.py &
sleep 1 &&
/usr/bin/dina &
sleep 5 &&
/usr/bin/dina-title.sh
ps -ef | grep "dina-run-flask" | awk '{print $2}' | xargs kill &
exit
fi
