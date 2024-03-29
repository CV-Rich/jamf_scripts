﻿#!/bin/sh
#####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#       installZoom4ARM.sh -- Installs or updates Zoom
#
# SYNOPSIS
#       sudo installZoom4ARM.sh
#
####################################################################################################
#
# HISTORY
#
#       Version: 1.0
#
#       - Shannon Johnson, 28.9.2018
#       (Adapted from the FirefoxInstall.sh script by Joe Farage, 18.03.2015)
#       (Modified for CVUSD use by Rich Koeberlein, 2021.01.15)
#
####################################################################################################
# Script to download and install Zoom.
# Only works on arm64 systems.
#

# Set preferences - set to anything besides "true" to disable
hdvideo="true"
# ssodefault="true"
ssohost="YourHostnameHere.zoom.us"


# choose language (en-US, fr, de)
lang=""
# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 1 AND, IF SO, ASSIGN TO "lang"
if [ "$4" != "" ] && [ "$lang" = "" ]; then
        lang=$4
else
        lang="en-US"
fi

pkgfile="Zoom.pkg"
plistfile="us.zoom.config.plist"
logfile="/Library/Logs/ZoomInstallScript.log"

# Are we running on Intel?
if [ '`/usr/bin/uname -p`'="arm64" ]; then
        ## Get OS version and adjust for use with the URL string
        OSvers_URL=$( sw_vers -productVersion | sed 's/[.]/_/g' )

        ## Set the User Agent string for use with curl
        userAgent="Mozilla/5.0 (Macintosh; Intel Mac OS X ${OSvers_URL}) AppleWebKit/535.6.2 (KHTML, like Gecko) Version/5.2 Safari/535.6.2"

        # Get the latest version of Reader available from Zoom page.
        latestver=$(/usr/bin/curl -s -A "$userAgent" https://zoom.us/client/latest/ | grep 'Zoom.pkg' | awk -F'/' '{print $3}')
        echo "Latest Version is: $latestver"

        # Get the version number of the currently-installed Zoom, if any.
        if [ -e "/Applications/zoom.us.app" ]; then
                currentinstalledver=$(/usr/bin/defaults read /Applications/zoom.us.app/Contents/Info CFBundleShortVersionString)
                echo "Current installed version is: $currentinstalledver"
                if [ "${latestver}" = "${currentinstalledver}" ]; then
                        echo "Zoom is current. Exiting"
                        exit 0
                fi
        else
                currentinstalledver="none"
                echo "Zoom is not installed"
        fi

        url="https://zoom.us/client/latest/Zoom.pkg?archType=arm64?"

        echo "Latest version of the URL is: $url"
        echo "$(date): Download URL: $url" >> ${logfile}

        # Compare the two versions, if they are different or Zoom is not present then download and install the new version.
        if [ "${currentinstalledver}" != "${latestver}" ]; then

                # Construct the plist file for preferences
                echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
                 <!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
                 <plist version=\"1.0\">
                 <dict>
                        <key>nogoogle</key>
                        <string>1</string>
                        <key>nofacebook</key>
                        <string>1</string>
                        <key>ZDisableVideo</key>
                        <true/>
                        <key>ZAutoJoinVoip</key>
                        <true/>
                        <key>ZDualMonitorOn</key>
                        <true/>" >> /tmp/"${plistfile}"

                if [ "${ssohost}" != "" ]; then
                        echo "
                        <key>ZAutoSSOLogin</key>
                        <true/>
                        <key>ZSSOHost</key>
                        <string>$ssohost</string>" >> /tmp/"${plistfile}"
                fi

                echo "<key>ZAutoFullScreenWhenViewShare</key>
                        <true/>
                        <key>ZAutoFitWhenViewShare</key>
                        <true/>" >> /tmp/"${plistfile}"

                if [ "${hdvideo}" = "true" ]; then
                        echo "<key>ZUse720PByDefault</key>
                        <true/>" >> /tmp/"${plistfile}"
                else
                        echo "<key>ZUse720PByDefault</key>
                        <false/>" >> /tmp/"${plistfile}"
                fi

                echo "<key>ZRemoteControlAllApp</key>
                        <true/>
                </dict>
                </plist>" >> /tmp/"${plistfile}"

                # Download and install new version
                # /bin/echo "$(date): Current Zoom version: ${currentinstalledver}" >> ${logfile}
                # /bin/echo "$(date): Available Zoom version: ${latestver}" >> ${logfile}
                # /bin/echo "$(date): Downloading newer version." >> ${logfile}
                /usr/bin/curl -L -o /tmp/${pkgfile} "${url}"
                # /bin/echo "$(date): Installing PKG..." >> ${logfile}
                /usr/sbin/installer -allowUntrusted -pkg /tmp/${pkgfile} -target /

                /bin/sleep 10
                # /bin/echo "$(date): Deleting downloaded PKG." >> ${logfile}
                /bin/rm /tmp/${pkgfile}

                #double check to see if the new version got updated
                newlyinstalledver=$(/usr/bin/defaults read /Applications/zoom.us.app/Contents/Info CFBundleShortVersionString)
        if [ "${latestver}" = "${newlyinstalledver}" ]; then
                # /bin/echo "$(date): SUCCESS: Zoom has been updated to version ${newlyinstalledver}" >> ${logfile}
                # /Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType hud -title "Zoom Installed" -description "Zoom has been updated." &
        # else
                # /bin/echo "$(date): ERROR: Zoom update unsuccessful, version remains at ${currentinstalledver}." >> ${logfile}
                /bin/echo "--" >> ${logfile}
                        exit 1
                fi

        # If Zoom is up to date already, just log it and exit.
        else
                /bin/echo "$(date): Zoom is already up to date, running ${currentinstalledver}." >> ${logfile}
        /bin/echo "--" >> ${logfile}
        fi
else
        /bin/echo "$(date): ERROR: This script is for M1 Macs only." >> ${logfile}
fi

exit 0