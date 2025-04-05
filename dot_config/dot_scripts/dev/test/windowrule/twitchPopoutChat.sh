#!/bin/bash

chatTitle="(.*? [-—] Chat [-—] Twitch [-—] .*)"

function handle {
  if [[ ${1:0:13} == "windowtitlev2" ]]; then
    window=address:0x${1:15:7}
    if [[ ${1:23} =~ $chatTitle ]]; then
      echo "success"
      hyprctl dispatch setfloating $window
      hyprctl dispatch resizewindowpixel exact 300 1080,$window
      hyprctl dispatch movewindowpixel exact 2048 72,$window
    fi
  fi
}

socat - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do handle "$line"; done