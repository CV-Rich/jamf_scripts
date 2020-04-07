#!/bin/sh
#####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#	auto-installVSCode.sh -- Installs the latest version of Visual Studio Code
#
# SYNOPSIS
#	sudo auto-installVSCode.sh
#
####################################################################################################
#
# HISTORY
#
#	Version: 1.0
#
#	- Griffin Holt, 08.20.2019
#	- Github: https://github.com/griffinbholt
#
####################################################################################################
# Script to download and install VS Code directly from the Internet
# Only works on Intel systems.

# Are we running on Intel?
if [ '`/usr/bin/uname -p`'="i386" -o '`/usr/bin/uname -p`'="x86_64" ]; then
		# Assignment of global variables
		protocolDomain='https://code.visualstudio.com'
		zipfile="VSCode.zip"
		logfile="/Library/Logs/VSCodeInstallScript.log"

		# Begin writing to a log file
		/bin/echo "--" >> ${logfile}
		/bin/echo "Parsing through $protocolDomain in order to find the download URL for VSCode." >> ${logfile}

		# Find the release page for the new update
		newUpdatePage=$(curl $protocolDomain/updates)

		# Remove the redirection clause in order to obtain the URL for the new update page
		redirectClause='Found. Redirecting to '
		newUpdatePage=${newUpdatePage#${redirectClause}}

		# Find the download page for the specific new update and revision (NOTE: The download for the Linux URL is very similar to the Mac URL, and is therefore parsed from this page)
		linuxPath='/linux-x64/stable'
		linuxURL=$(curl $protocolDomain/$newUpdatePage | sed -n 's/.*href="\([^"]*\).*/\1/p' | grep "$linuxPath")

		# Remove the path to the Linux download and replace it with the path to the Mac download
		latestUpdateURL=${linuxURL%${linuxPath}}
		macPath='/darwin/stable'
		macDownloadPage="$latestUpdateURL$macPath"

		# Curl the resulting download page. It redirects to the actual download URL for the zip file
		macDownloadURL=$(curl $macDownloadPage)
		url=${macDownloadURL#${redirectClause}}

		# Kill any open sessions of VSCode
		/bin/echo "Killing any open sessions of Visual Studio Code." >> ${logfile}
		osascript -e 'quit app "Code"'

		# Remove the previous version of VSCode
		/bin/echo "Removing the previous version of Visual Studio Code." >> ${logfile}
		rm -rf /Applications/Visual\ Studio\ Code.app

		# Download the latest version from the parsed url via 'curl'
		/bin/echo "`date`: Downloading latest version." >> ${logfile}
		/usr/bin/curl -s -o /tmp/${zipfile} ${url}

		# Unzip the compressed .app and move it to /Applications
		/bin/echo "Unzipping the compressed file of the latest version and moving it to /Applications." >> ${logfile}
		unzip /tmp/${zipfile} -d /Applications

		# Remove the leftover zip file from the /tmp cache
		/bin/echo "Removing the .zip file from /tmp." >> ${logfile}
		rm -f /tmp/${zipfile}

		# Change the permissions and owndership of the .app file in order to remove it from the 'Downloaded from Internet' quarantine
		/bin/echo "Removing new application from 'Downloaded from Internet' quarantine." >> ${logfile}
		chmod -R 755 /Applications/Visual\ Studio\ Code.app
		chown -R root:wheel /Applications/Visual\ Studio\ Code.app
else
	/bin/echo "`date`: ERROR: This script is for Intel Macs only." >> ${logfile}
fi

exit 0
