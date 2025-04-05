#!/bin/bash
minOpacity="0.4"

setOpacity() {
    local opacity="$1"
    local address="$2"

    local opacityTags=$(hyprctl clients -j | jq -r --arg address "$address" '.[] | select(.address == $address) | .tags[] | select(test("^opacity:"))')

    local currentOpacity=$(echo $opacityTags | tr ' ' '\n' | head -n 1 | sed 's/^opacity://')

    # if no opacity
    if [[ -z $currentOpacity ]]; then
        currentOpacity="1.0"
    fi

    # calc opacity
    case "$1" in
        +*)
            opacity=$(echo "$currentOpacity + ${opacity#+}" | bc)
            ;;
        -*)
            opacity=$(echo "$currentOpacity - ${opacity#-}" | bc)
            ;;
    esac
    echo "$opacity"

    # validate opacity
    if (( $(echo "$opacity < $minOpacity" | bc -l) )); then
        opacity=$minOpacity
    elif (( $(echo "$opacity > 1.0" | bc -l) )); then
        opacity=1.0
    fi

    echo "$opacity"

    case "$opacity" in
        "1.0")
            hyprctl dispatch setprop "address:$address" noblur 0
            opacity=""
            ;;
        *)
            hyprctl dispatch setprop "address:$address" noblur 1
            hyprctl dispatch tagwindow +opacity:$opacity address:$address
            hyprctl keyword windowrulev2 "opacity $opacity, tag:opacity:$opacity"  
            ;;
    esac


    # del all other opacity tags
    echo "$opacityTags" | tr ' ' '\n' | while read line; do
        if ! [[ -z "$line" ]]; then
            if [[ "$line" != "opacity:$opacity" ]]; then {
                hyprctl dispatch -- tagwindow -$line address:$address
            }
            fi
        fi
    done
}

is_float() {
    local num="$1"
    [[ "$num" =~ ^[-+]?[0-9]*\.[0-9]+$ ]]
}

if ! is_float "$1"; then
    echo "value not float"
    exit 1
fi

# get window address
case "$2" in
    0x*)
        window=$2
        ;;
    active|*)
        window=$(echo $(hyprctl activewindow -j) | jq -r '.address')
        ;;
esac

setOpacity $1 $window
