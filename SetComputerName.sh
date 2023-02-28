#!/bin/sh

# Set Computer Name
# Written By Rich Koeberlein
# January 2021

# Used during student and staff laptop enrollment.

# The user is requested to enter the computer Asset Tag number within a text box.
idNumberEntered=$(sudo osascript -e 'display dialog "Enter the 6 digit District ID NO of your computer." default answer ""')
idNumber=$( echo "$idNumberEntered" | /usr/bin/awk -F "text returned:" '{print $2}' )

# The user is requested to enter the Building which is their home school within a text box.
locationEntered=$(sudo osascript -e 'display dialog "What Site are you assigned to? (Two Digits Please Type AN, AV, BO, CH, CR, CV, DO, MM, HD, LC, etc... All District Office is DO" default answer ""')
location=$( echo "$locationEntered" | /usr/bin/awk -F "text returned:" '{print $2}' )

# The user is asked to enter their Network Name within a text box.
networkNameEntered=$(sudo osascript -e 'display dialog "What is What is your Network Name? (ex: your email address before @cajonvalley)" default answer ""')
networkName=$( echo "$networkNameEntered" | /usr/bin/awk -F "text returned:" '{print $2}' )

# Set ComputerName using variables created above
/usr/sbin/scutil --set ComputerName "$location-$idNumber-$networkName"

# Set HostName using variables created above
/usr/sbin/scutil --set HostName "$location-$idNumber-$networkName"

# Set LocalHostName using variables created above
/usr/sbin/scutil --set LocalHostName "$location-$idNumber-$networkName"

# Submit New Name to Jamf

sudo jamf setComputerName -name "$location-$idNumber-$networkName"

# Submit Asset Tag to Jamf

sudo jamf recon -assetTag "$idNumber"

# Update Jamf inventory data

sudo jamf recon
