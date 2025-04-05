#!/bin/bash

if [[ !(-n $1 && $1 =~ ^[0-9]+$) ]]; then
    echo invalid tab number
    exit 2
fi

activegroup=($(hyprctl activewindow -j | jq -r '.grouped[]'))

if [[ ${#activegroup[@]} == 0 || $1 -le ${#activegroup[@]} ]]; then
    hyprctl dispatch focuswindow address:${activegroup[$1-1]}
fi
echo ok
exit 0