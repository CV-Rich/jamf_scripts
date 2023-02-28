#!/bin/bash

# # Variables used in this script
SILHOUETTE_URL='https://ourLocalURL/SS_V4.5.180.001_M6R.dmg'
DMG_PATH='/var/ourLocalFolderPath/SS_V4.5.180.001_M6R.dmg'

# # Download requested file using curl and placing it in it's desired location
/usr/bin/curl -L --silent "${SILHOUETTE_URL}" --output "${DMG_PATH}"

# # Checks for the DMG before continuing 
if [ -a "${DMG_PATH}" ]; then

# # Attach the Disk Image
/usr/bin/hdiutil attach "${DMG_PATH}"

# # Move app from Disk Image to Applications folder
# LOGGED_USER=$(stat -f "%Su" /dev/console);
mv "/Volumes/Silhouette\ Studio/Silhouette\ Studio.app" "/Applications/Silhouette\ Studio.app"   
    
# # Unmount the disk image
/usr/bin/hdiutil detach /Volumes/Silhouette\ Studio

# # Delete the disk image
rm -R "${DMG_PATH}"


else

echo "Silhouette Studio Not Found"

fi


##### Created by:
##### Rich Koeberlein
##### February 17, 2023
