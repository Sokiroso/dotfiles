#!/bin/bash

if [[ -z $1 ]]; then
    specialName=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .specialWorkspace.name')
else
    specialName=$(hyprctl monitors -j | jq -r --arg monName $1 '.[] | select(.name == $monName) | .specialWorkspace.name')
fi

if [[ $specialName != "" ]] then
    hyprctl dispatch togglespecialworkspace ${specialName#special:}
fi