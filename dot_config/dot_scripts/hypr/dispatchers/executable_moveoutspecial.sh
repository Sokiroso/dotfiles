#!/bin/bash
activeWindow=$(hyprctl activewindow -j)

if [[ $1 == "silent" ]]; then 
    silent="silent"
fi

if [[ $(echo $activeWindow | jq -r '.workspace.name') =~ ^special:(.*) ]]; then 
    hyprctl dispatch movetoworkspace$silent "$(hyprctl activeworkspace -j | jq '.id')";
fi

