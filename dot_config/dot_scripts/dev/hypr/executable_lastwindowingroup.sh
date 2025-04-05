#!/bin/bash

array=()

getGroups() {
    local value1="$(hyprctl clients -j | jq -rc '.[] | .grouped' | sort -u | tr -d '[]' | sed '/^$/d' | tr ',' ' ')"
    while IFS= read -r line; do
        # echo "Group: $line"
        array=($line)
    done <<< "$value1"
    echo "${array[1]}"
}
getGroups


# function handleEvent {
#     local eventName="${1%%>>*}"  
#     local eventData="${1#*>>}"

#     case "$eventName" in
#         togglegroup )
#             echo "togglegroup"
#             ;;
#         moveintogroup )
#             echo "moveintogroup"
#             ;;
#         moveoutofgroup )
#             echo "moveoutofgroup"
#             ;;
#         closewindow )
#             echo "closewindow"
#             ;;
#     esac
# }

# socat - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do 
#     handleEvent "$line"
# done