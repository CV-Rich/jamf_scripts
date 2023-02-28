#!/bin/bash

## Installs Rosetta from rosetta script / policy
jamf policy -event rosetta

date >> /var/log/jamf.log

## Installs these from custom scripts / policys

## Branding
jamf policy -event custombrand
## NomAD Login
jamf policy -event nomad-ad
## NomAD
jamf policy -event nomad
## NomAD Configs (Configutation Profiles did not work well for us)
jamf policy -event nomadconfig

## This resets the login window to switch to the nomAD Login we created
killall -HUP loginwindow


## Wait for user to be logged in

dockStatus=$(pgrep -x Dock)
log "Waiting for Desktop"
while [ "$dockStatus" == "" ]; do
  log "Desktop is not loaded. Waiting."
  sleep 2
  dockStatus=$(pgrep -x Dock)
done

## more installs below

jamf policy -event chrome -verbose
jamf policy -event sophos -verbose

jamf policy -event deploySharpDrivers -verbose
jamf policy -event dockfix -verbose






