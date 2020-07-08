#!/bin/sh
#Script auto fix time on hackintosh
#OSX: 10.6 and above

DAEMON_PATH=/Library/LaunchDaemons/
BIN_PATH=/usr/local/bin/
TMP_PATH=/tmp/
TIME_FIX_FILE=localtime-toggle
TIME_DAEMON_FILE=org.osx86.localtime-toggle.plist

echo "Downloading required file"
sudo curl -o $TMP_PATH$TIME_FIX_FILE "https://raw.staticdn.net/xiaoMGithub/LocalTime-Toggle/master/sbin/localtime-toggle"
sudo curl -o $TMP_PATH$TIME_DAEMON_FILE "https://raw.staticdn.net/xiaoMGithub/LocalTime-Toggle/master/Library/LaunchDaemons/org.osx86.localtime-toggle.plist"

if [ ! -d "$BIN_PATH" ] ; then
    mkdir "$BIN_PATH" ;
fi

echo "Copy file to destination place..."
sudo cp -R $TMP_PATH$TIME_FIX_FILE $BIN_PATH
sudo cp -R $TMP_PATH$TIME_DAEMON_FILE $DAEMON_PATH
sudo rm $TMP_PATH$TIME_FIX_FILE
sudo rm $TMP_PATH$TIME_DAEMON_FILE

echo "Chmod localtime-toggle..."
sudo chmod +x $BIN_PATH$TIME_FIX_FILE
sudo chown root $DAEMON_PATH$TIME_DAEMON_FILE
sudo chmod 644 $DAEMON_PATH$TIME_DAEMON_FILE

echo "Load Localtime-toggle..."
if sudo launchctl list | grep --quiet localtime-toggle; then
    echo "Stopping existing localtime-toggle daemon."
    sudo launchctl unload $DAEMON_PATH$TIME_DAEMON_FILE
fi
sudo launchctl load -w $DAEMON_PATH$TIME_DAEMON_FILE

echo "Done!"
