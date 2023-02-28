#!/bin/bash

# # Variables used in this script
SCRATCH_URL='https://github.com/jfo8000/ScratchJr-Desktop/releases/download/v1.3.2/ScratchJr-1.3.2.dmg'
DMG_PATH='/var/cajonvalley/ScratchJr-1.3.2.dmg'

# # Download requested file using curl and placing it in it's desired location
/usr/bin/curl -L --silent "${SCRATCH_URL}" --output "${DMG_PATH}"

# # Checks for the DMG before continuing 
if [ -a "${DMG_PATH}" ]; then

# # Attach the Disk Image
/usr/bin/hdiutil attach "${DMG_PATH}"

# # Move app from Disk Image to Applications folder
# LOGGED_USER=$(stat -f "%Su" /dev/console);
mv "/Volumes/ScratchJr/ScratchJr.app" "/Applications/ScratchJr.app"   
    
# # Unmount the disk image
/usr/bin/hdiutil detach /Volumes/ScratchJr

# # Delete the disk image
rm -R "${DMG_PATH}"


else

echo "ScatchJr Not Found"

fi


##### Created by:
##### Rich Koeberlein
##### February 16, 2023