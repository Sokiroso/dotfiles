#!/bin/bash
activeworkspace=$(echo $(hyprctl activeworkspace -j) | jq -r '.id');
hyprctl dispatch togglespecialworkspace "subworkspace:$activeworkspace";