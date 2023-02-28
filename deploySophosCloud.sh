####################################################################################################
#
# Install Latest Version of Sophos Anti-Virus
#
####################################################################################################

# Checks if Sophos is already installed and stops the install if it is
if [ -d "/Applications/Sophos Endpoint.app" ]; then
  echo "Sophos is already installed."         
  echo "Installation Cancelled"
  exit
fi

#Mount Install Directory and Run Installer
mkdir /Volumes/Sophos | mount_smbfs //user:password@www.domain.com/share/SophosInstall /Volumes/Sophos
cd /Volumes/Sophos/
"./Sophos Installer.app/Contents/MacOS/Sophos Installer" --install

diskutil unmount force /Volumes/Sophos


echo "Sophos was successfully installed!"
exit
else
  echo "Download failed, please try again later or check your network connection.";
fi



