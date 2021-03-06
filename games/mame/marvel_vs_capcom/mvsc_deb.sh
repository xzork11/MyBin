#!/bin/bash

path="/tmp/roms"
zip="marvcap.zip"
rom="mvsc.zip"

if [ ! -f "/usr/games/mame" ]
then
  sudo apt-get install mame -y
fi

mkdir "$path"
cd "$path"


wget -c "https://dl.dropbox.com/s/ui7zs7vcrw6q1qs/mavelcap.zip" -O "$zip"
unzip -o "$zip"

mame $rom -rompath "$path"
