#!/bin/bash

function handleEvent {
    local eventName="${1%%>>*}"  
    local eventData="${1#*>>}"

    case "$eventName" in
        workspacev2 )
            local workspaceID="${eventData%%,*}"  
            local workspaceName="${eventData#*,}"
            local specialWsName=$(hyprctl monitors -j | jq -r --arg workspaceID $workspaceID '.[] | select(.activeWorkspace.id == ($workspaceID | tonumber)) | .specialWorkspace.name')
            if [[ $specialWsName != "" ]] then
                hyprctl dispatch togglespecialworkspace ${specialWsName#special:}
            fi

            ;;
    esac
}

socat - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do 
    handleEvent "$line"
done