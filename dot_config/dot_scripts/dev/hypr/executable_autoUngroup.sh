#!/bin/bash
# doc: https://wiki.hyprland.org/IPC/

function handleEvent {
    local eventName="${1%%>>*}"  
    local eventData="${1#*>>}"

    case "$eventName" in
        moveoutofgroup )
            WINDOWADDRESS=$eventData
            ;;
        # closewindow )
        #     activewindowAddress="0x$eventData"
        #     ;;
        # movewindowv2 )
        #     ;;
        # changefloatingmode )
        #     ;;
        # togglegroup )
        #     ;;
        # empty )
        #     ;;
        # empty )
        #     ;;
        # empty )
        #     ;;
        # empty )
        #     ;;
        # empty )
        #     ;;
        # empty )
        #     ;;
    esac
}

# socat - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do 
#     echo "$(date +"%H:%M:%S") $line"
#     handleEvent "$line"
# done

function getGroups {
    echo "$(hyprctl clients -j | jq -r '[.[].grouped | select(length > 0) | join("-")] | unique | .[]')"
}

function updateActivegroups {
    activegroups=($(getGroups))
}

function destroyGroup {
    local serchWindow=$1
    activegroups=($(getGroups))
}

updateActivegroups
echo "${activegroups[@]}"

