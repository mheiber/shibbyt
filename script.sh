#!/usr/bin/env bash
cd "$(dirname "$0")"
source ./config.sh
pixlet render ./main.star --magnify 10 \
    TIDE_STATION="$TIDE_STATION"  \
    LAT="$LAT" LONG="$LONG" &&
osascript -e 'tell application "Finder" to set desktop picture to POSIX file "/Users/mheiber/px/main.webp"' &&
cp ./main.webp two.webp &&
osascript -e 'tell application "Finder" to set desktop picture to POSIX file "/Users/mheiber/px/two.webp"'
