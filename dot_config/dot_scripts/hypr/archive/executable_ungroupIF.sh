#!/bin/bash

activewindow=$(hyprctl activewindow -j)
group=($(echo $activewindow | jq -r '.grouped[]'))

if [[ ${#group[@]} == $1 ]]; then
    hyprctl dispatch togglegroup
    hyprctl dispatch focuswindow address:$(echo $activewindow | jq -r '.address')}
fi