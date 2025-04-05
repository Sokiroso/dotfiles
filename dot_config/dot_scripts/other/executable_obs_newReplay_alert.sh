#!/bin/bash

DIR_TO_WATCH="$HOME/files/records/obs"

inotifywait -m -e create --format '%f' "$DIR_TO_WATCH" | while read FILE; do
    msg="replay saved"
    echo "$msg"
    hyprctl notify 1 2000 "rgb(55ff55)" "fontsize:20  $msg" 
done
