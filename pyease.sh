#!/bin/bash

# TO BE RUN ON UNIX/MACOS/GitBash-WINDOWS use "source script-name.sh" command to run on shell
##################################################################################################
# This script will set you up a fresh virtual enviroment of your version of python installed     #
# into your machine, if there is not already one with the DIR name of '.venv'. Virtual enviroment#
# will be activated and then it will look for requirements.txt to be installed on your virtual   #
# machine, if so you have the choice whether to install them or not.                             #
##################################################################################################

# Folder names to be created
VENV_DIR=".venv"
VSCODE_DIR=".vscode"

# Settings for VScode
VSCODE_JSON_FILE="settings.json"
python_interpreter_path="$PWD/$VENV_DIR/bin/python"
json_content="{\"python.defaultInterpreterPath\": \"$python_interpreter_path\"}"

# Create venv if it does not exist
set_venv(){
    # Check if the virtual enviroment already exists on working DIR
    if [ ! -d "$VENV_DIR" ]; then
        
        # Create a new virtual environment
        python3 -m venv $VENV_DIR
        PID=$!
        echo -n -e "\e[33m Creating virtual environment.\e[0m"
        echo -n -e "\e[33mCreating virtual environment"
        while kill -0 $PID 2>/dev/null; do
          echo -n -e "."
          sleep 1
        done
        echo -e "\e[32mSUCCESS: Virtual environment created at '$VENV_DIR'!\e[0m"
        echo "👍\033[1;32m Virtual environment '$VENV_DIR' created.\033[0m"
        if [ ! -d "$VSCODE_DIR" ]; then
            mkdir "$VSCODE_DIR"
            touch "$VSCODE_DIR/$VSCODE_JSON_FILE"
            echo "$json_content" > "$VSCODE_DIR/$VSCODE_JSON_FILE"
            echo "👍\033[1;32m '$VSCODE_DIR' folder with $VSCODE_JSON_FILE file created.\033[0m"
        fi
    else
        echo -e "⚠️ \033[1;33m Virtual environment '$VENV_DIR' already exists.\033[0m"
    fi
}

delete_venv(){
    echo "Deleting venv"
    rm -r "$VENV_DIR"
    rm -r "$VSCODE_DIR"
    echo "Deleted"
}


# Funcion to initialize a python project
init(){
    set_venv
}

update(){
    echo "You are on Update"
}

clean(){
    delete_venv
}

case "$1" in
    init)
        init
        ;;
    update)
        update
        ;;
    clean)
        clean
        ;;
    *)
        echo "Usage: pyease {init | update}"
        ;;
esac