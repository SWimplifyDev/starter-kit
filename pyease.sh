#!/bin/bash

# TO BE RUN ON UNIX/MACOS/GitBash-WINDOWS use "source script-name.sh" command to run on shell
##################################################################################################
# This script will set you up a fresh virtual enviroment of your version of python installed     #
# into your machine, if there is not already one with the DIR name of '.venv'. Virtual enviroment#
# will be activated and then it will look for requirements.txt to be installed on your virtual   #
# machine, if so you have the choice whether to install them or not.                             #
##################################################################################################

################## Message Printer #######################

# Define the "MessagePrinter" class using functions
MessagePrinter(){
    # Function to initialize the class (like a constructor)
    int(){
    INFO_COLOR="\033[1;36m"  # Cyan
    SUCCESS_COLOR="\033[1;32m" # Green
    WARNING_COLOR="\033[1;33m" # Yellow
    ERROR_COLOR="\033[1;31m"   # Red
    RESET_COLOR="\033[0m"    # Reset    
    }
# Function to print info messages
  info() {
    local message=$1
    echo -e "${INFO_COLOR}[info]${RESET_COLOR} ${message}"
  }

  # Function to print success messages
  success() {
    local message=$1
    echo -e "${SUCCESS_COLOR}[success]${RESET_COLOR} ${message}"
  }

  # Function to print warning messages
  warning() {
    local message=$1
    echo -e "${WARNING_COLOR}[warning]${RESET_COLOR} ${message}"
  }

  # Function to print error messages
  error() {
    local message=$1
    echo -e "${ERROR_COLOR}[error]${RESET_COLOR} ${message}"
  }

}

MessagePrinter
int #this
########################## End Message Printer Code ##########################

############# Header ##################
print_header() {
    SCRIPT_NAME="pyease"
    VERSION="1.0.0"
    AUTHOR="Daniel Rodriguez"
    DESCRIPTION="https://github.com/SWimplifyDev/starter-kit"
    echo ""
    echo -e "\033[1;34m########################################################\033[0m"  # Blue header line
    echo -e "\033[1;34m $SCRIPT_NAME - Version $VERSION \033[0m"
    echo -e "\033[1;34m Author: $AUTHOR \033[0m"
    echo -e "\033[1;34m Description: $DESCRIPTION\033[0m"
    echo -e "\033[1;34m########################################################\033[0m"  # Blue footer line
    echo ""
}
#mahhfg cghnage
################# End Header ##########################

print_header
# Folder names to be created
VENV_DIR=".venv"
VSCODE_DIR=".vscode"

# Settings for VScode
VSCODE_JSON_FILE="settings.json"
python_interpreter_path="$PWD/$VENV_DIR/bin/python"
json_content="{\"python.defaultInterpreterPath\": \"$python_interpreter_path\"}"

# Create a venv if it does not exist
set_venv(){
    if [ ! -d "$VENV_DIR" ]; then
        python3 -m venv $VENV_DIR
        success "Virtual environment created at '$VENV_DIR'."
    else
        info "Virtual environment already exists."
    fi
}


# Create vscode settings if they dont exist
set_vscode_settings(){
    if [ ! -d "$VSCODE_DIR" ]; then
        mkdir "$VSCODE_DIR"
        touch "$VSCODE_DIR/$VSCODE_JSON_FILE"
        echo "$json_content" > "$VSCODE_DIR/$VSCODE_JSON_FILE"
        success "VSCode Settings created at '$VSCODE_DIR'."
    else
        info "VSCode Settings already exists."
    fi
}

# Delete the venv
delete_venv(){
    if [ -d "$VENV_DIR" ]; then
        info "Attempting to delete the virtual environment..."
        if rm -r "$VENV_DIR"; then
            success "Deleted successfully."
        else
            error "Could not delete the virtual environment"
            exit 1
        fi
    else
        info "Virtual environment does not exist."
    fi
}

# Delete vscode settings
delete_vscode_settings(){
    if [ -d "$VSCODE_DIR" ]; then
        info "Attempting to delete vscode settings..."
        if rm -r "$VSCODE_DIR"; then
            success "Deleted successfully."
        else
            error "Could not delete vscode settings"
            exit 1
        fi
    else
        info "vscode settings dont not exist."
    fi
}

# Initialize a python project
init(){
    set_venv
    set_vscode_settings
    source $VENV_DIR/bin/activate
}

update(){
    echo "You are on Update"
}

# Delete venv and vscode settings
clean(){
    delete_venv
    delete_vscode_settings
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