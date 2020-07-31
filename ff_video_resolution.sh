#!/bin/bash
echo $1,$(ffprobe "$1" 2>&1 | grep Stream | grep Video | awk '{print $11}')

horizontal=$(ffprobe "$1" 2>&1 | grep Stream | grep Video | awk '{print $11}' | awk -Fx '{ print $2 }')

echo "Horizontal resolution: $horizontal"
if (($horizontal<800)) #Effective 1080 seems to be 800 as seen in Plex media descriptions of "HD"
then
  echo SD
else
  echo HD
fi
