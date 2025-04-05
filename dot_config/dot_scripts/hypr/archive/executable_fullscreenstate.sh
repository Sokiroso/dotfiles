#!/bin/bash
fullscreenValue="1"  # default
targetwindow=$(hyprctl activewindow -j)
targetworkspace=$(hyprctl workspaces -j | jq -r --arg workspaceID $(echo $targetwindow | jq -r '.workspace.id') '.[] | select(.id == ($workspaceID | tonumber))')

# get fullscreenValue
if [[ -n "$1" ]]; then
    if [[ ! $1 =~ ^[1-3]$ ]]; then
        echo "invalid fullscreenstate value"
        echo "value can be 1 - maximize, 2 - fullscreen, 3 - maximize and fullscreen"
        exit 2
    fi
    fullscreenValue=$1
fi

# if target window already fullscreen
if [[ -n "$2" && $(hyprctl activewindow -j | jq '.fullscreen') != "0" ]]; then
    hyprctl dispatch fullscreenstate 0
    exit 0
fi

# hasfullscreen?
if [[ $(echo $targetworkspace | jq -r '.hasfullscreen') == "true" && !($(echo $targetwindow | jq -r '.fullscreen') =~ ^[1-3]$) ]]; then
    echo "workspace already have fullscreen window"
    exit 0
fi

# is pinned?
if [[ $(echo $targetwindow | jq -r '.pinned') == "true" ]]; then
    hyprctl dispatch pin
    hyprctl dispatch tagwindow +wasPinned
    hyprctl dispatch fullscreenstate $fullscreenValue
else
    hyprctl dispatch fullscreenstate $fullscreenValue
    exit 0
fi

targetmonName=$(echo $targetworkspace | jq -r '.monitor')
targetwindowAddress=$(echo $targetwindow | jq -r '.address')

activewindowAddress=$targetwindowAddress

function handleEvent {
    local eventName="${1%%>>*}"  
    local eventData="${1#*>>}"

    case "$eventName" in
        activewindowv2 )
            activewindowAddress="0x$eventData"
            ;;
        fullscreen )
            if [[ $activewindowAddress == $targetwindowAddress && $eventData == "0" ]]; then
                hyprctl dispatch pin address:$targetwindowAddress
                hyprctl -- dispatch tagwindow -wasPinned address:$targetwindowAddress
                echo "window exit full screen"
                exit 0
            fi
            ;;
        closewindow )
            if [[ $eventData == $targetwindowAddress ]]; then
                echo "window closed"
                exit 0
            fi
            ;;
        workspacev2 )
            local workspaceID="${eventData%%,*}"  
            local workspaceName="${eventData#*,}"
            local monName=$(hyprctl workspaces -j | jq -r --arg workspaceID "$workspaceID" '.[] | select(.id == ($workspaceID | tonumber)) | .monitor' )
            
            if [[ $monName == $targetmonName ]]; then
                hyprctl -- dispatch movetoworkspace $workspaceID, address:$targetwindowAddress
                hyprctl dispatch fullscreenstate 0
                echo "workspace has changed"
            fi
            ;;
        activespecial )
            local workspaceName="${eventData%,*}"
            local monName="${eventData##*,}"

            if [[ "$workspaceName" != "" && $monName == $targetmonName ]]; then
                hyprctl -- dispatch movetoworkspace $workspacename, address:$targetwindowAddress
                hyprctl dispatch fullscreenstate 0
                echo "special workspace opened"
            fi
            ;;
    esac
}

socat - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do 
    handleEvent "$line"
done