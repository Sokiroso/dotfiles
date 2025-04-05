#!/bin/bash
awn=$(echo $(hyprctl activewindow -j) | jq -r '.workspace.name')

if [[ $awn =~ ^special:subworkspace:(.*) ]]; then 
    hyprctl dispatch movetoworkspace "${BASH_REMATCH[1]}";
else 
    activeworkspace=$(echo $(hyprctl activeworkspace -j) | jq -r '.id');
    hyprctl dispatch movetoworkspace "special:subworkspace:$activeworkspace";
fi
