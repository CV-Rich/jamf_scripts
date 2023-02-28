#!/bin/bash

cd /var
mkdir ./cajonvalley
cd /var/cajonvalley
curl -L -O "https://PublicWebStorage/CV_logo_480x480.png"
curl -L -O "https://PublicWebStorage/RK2-OBPier2021.jpeg"
curl -L -O "https://PublicWebStorage/DigitalCitizenDesktop_v2.jpg"
chmod 777 ./CV_logo_480x480.png
chmod 777 ./RK2-OBPier2021.jpeg
chmod 777 ./DigitalCitizenDesktop_v2.jpg