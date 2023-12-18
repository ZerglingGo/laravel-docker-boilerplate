#!/bin/sh

docker compose build

if [ $? -eq 0 ]; then
    echo -e "\n=======================================\n\e[1;32m\tCompleted build laravel\e[0m\n=======================================\n"

    echo -e 'You can running server to execute command below:'
    echo -e '    docker compose up'
fi
