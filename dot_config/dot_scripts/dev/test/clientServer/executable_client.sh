#!/bin/bash

SOCKET="/tmp/my_socket.sock"

# Подключение к сокету и непрерывное чтение данных
echo "Подключение к сокету $SOCKET..."
while true; do
    socat - UNIX-CONNECT:$SOCKET | while read -r line; do
        echo "Получено: $line"
    done
done
