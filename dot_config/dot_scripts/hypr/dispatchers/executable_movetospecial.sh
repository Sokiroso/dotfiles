#!/bin/bash
activeWindow=$(hyprctl activewindow -j)

if [[ $2 == "silent" ]]; then 
    silent="silent"
fi

if [[ $(echo $activeWindow | jq -r '.workspace.name') = "special:$1" ]]; then 
    $(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/moveoutspecial.sh
else
    hyprctl dispatch movetoworkspace$silent "special:$1";
fi

