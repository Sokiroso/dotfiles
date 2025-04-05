#!/bin/bash
# doc: https://wiki.hyprland.org/IPC/

function handleEvent {
    local eventName="${1%%>>*}"  
    local eventData="${1#*>>}"

    # echo "[$(date +"%H:%M:%S")]----------------"
    # echo "eventName: $eventName"
    # echo "eventData: $eventData"


    case "$eventName" in
        openwindow )
            local eventData=($(echo $eventData | tr ',' ' '))
            WINDOWADDRESS="0x${eventData[0]}"
            WORKSPACENAME="${eventData[1]}"
            WINDOWCLASS="${eventData[2]}"
            WINDOWTITLE="${eventData[3]}"
            echo "$WINDOWADDRESS"
            echo "$WORKSPACENAME"
            echo "$WINDOWCLASS"
            echo "$WINDOWTITLE"
            echo "----------------------"

            if [[ $WINDOWCLASS == "org.telegram.desktop" ]]; then 
                hyprctl -- dispatch focuswindow address:$WINDOWADDRESS}
                hyprctl -- dispatch togglefloating
                # hyprctl -- dispatch resizewindowpixel 700 0, address:$WINDOWADDRESS
                # hyprctl -- dispatch movetoworkspace $workspaceID, address:$targetwindowAddress
                # hyprctl -- dispatch focuswindow address:${activegroup[$1-1]}
            fi
            ;;
    esac
}

socat - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do 
    handleEvent "$line"
done


