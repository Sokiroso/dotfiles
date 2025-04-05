#!/bin/bash

SOCKET="/tmp/my_socket.sock"

# Удаляем старый сокет, если он существует
[ -e $SOCKET ] && rm $SOCKET

echo "Сервер запущен, использование сокета $SOCKET..."
socat -d -d - UNIX-LISTEN:$SOCKET,fork,reuseaddr <<- EOF
    while true; do
        echo "Сообщение от сервера: $(date)"
        sleep 1
    done
EOF
