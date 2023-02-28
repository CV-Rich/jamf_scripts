#!/bin/sh

cd /tmp

if [[ -d "/tmp/Sophos Installer.app" ]]; then
    rm -rf /tmp/Sophos*
fi

# Update the URL as indicated in Sophos Admin Panel
curl -O https://YourURL-FromAdminPanel/SophosInstall.zip
unzip SophosInstall.zip

chmod a+x ./Sophos\ Installer.app/Contents/MacOS/Sophos\ Installer
chmod a+x ./Sophos\ Installer.app/Contents/MacOS/tools/com.sophos.bootstrap.helper

./Sophos\ Installer.app/Contents/MacOS/Sophos\ Installer --install

exit 0