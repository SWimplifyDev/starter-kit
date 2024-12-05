#!/bin/bash

init(){
    echo "You are on init"
}

update(){
    echo "You are on Update"
}

case "$1" in
    init)
        init
        ;;
    update)
        update
        ;;
    *)
        echo "Usage: pyease {init | update}"
        ;;
esac