#!/bin/bash
# doc: https://wiki.hyprland.org/IPC/

function handleEvent {
    local eventName="${1%%>>*}"  
    local eventData="${1#*>>}"

    echo "[$(date +"%H:%M:%S")]----------------"
    echo "eventName: $eventName"
    echo "eventData: $eventData"

    
    case "$eventName" in
        activewindowv2 )
            activewindowAddress="0x$eventData"
            ;;
    esac
}

socat - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do 
    handleEvent "$line"
done