#!/bin/bash
activeworkspace=$(echo $(hyprctl activeworkspace -j) | jq -r '.id');
hyprctl dispatch movetoworkspace "special:subworkspace:$(hyprctl activeworkspace -j) | jq -r '.id')";
