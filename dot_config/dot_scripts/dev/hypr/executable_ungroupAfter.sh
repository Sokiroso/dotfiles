#!/bin/bash

if [[ -z $1 ]]; then
    exit 0
fi

activewindow=$(hyprctl activewindow -j)
group=($(echo $activewindow | jq -r '.grouped[]'))

# if [[ ${#group[@]} != 0 && ${#group[@]} != 1 &&]]; then
if [[ ${#group[@]} == 2 ]]; then
    group=(${group[@]/$(echo $activewindow | jq -r '.address')/})
    if [[ $(hyprctl -- dispatch $1) == "Invalid dispatcher" ]]; then
        echo "Invalid dispatcher"
        exit 1
    fi
    hyprctl dispatch focuswindow address:${#group[-1]}
    hyprctl dispatch togglegroup


    case "$1" in
        closewindow )
            if [[ $eventData == $targetwindowAddress ]]; then
                echo "window closed"
                exit 0
            fi
        ;;
    esac
fi

