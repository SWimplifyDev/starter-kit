#!/bin/bash

# TO BE RUN ON UNIX/MACOS/GitBash-WINDOWS use "source script-name.sh" command to run on shell
##################################################################################################
# This script will set you up a fresh virtual enviroment of your version of python installed     #
# into your machine, if there is not already one with the DIR name of '.venv'. Virtual enviroment#
# will be activated and then it will look for requirements.txt to be installed on your virtual   #
# machine, if so you have the choice whether to install them or not.                             #
##################################################################################################

################## Message Printer #######################
source <(curl -fsSL https://raw.githubusercontent.com/SWimplifyDev/bash/main/message-printer.sh)
# Import Print Functions
MessagePrinter
int 
########################## End Message Printer Code ######

is_windows() {
    if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" ]]; then
        return 0
    elif uname -s | grep -qE '^(MINGW|MSYS|CYGWIN)'; then
        return 0
    elif [[ -n "$WINDIR" || -n "$SystemRoot" ]]; then
        return 0
    else
        return 1
    fi
}

init_system_comands(){
    if is_windows; then
        SYS_INFO="Running on Windows"
        VENV_CMD="py -m venv $VENV_DIR"
        SCRIPT_FOLDER="Scripts"
        ACTIVE_VENV_CMD="source $VENV_DIR/$SCRIPT_FOLDER/activate"
        UPGRADE_PIP_CMD="$VENV_DIR/Scripts/python.exe -m pip install --upgrade pip"
        RUN_CODE_CMD="py $MAIN_TEMPLATE_FILE"
    else
        SYS_INFO="Running on Unix"
        VENV_CMD="python3 -m venv $VENV_DIR"
        SCRIPT_FOLDER="bin"
        ACTIVE_VENV_CMD="source $VENV_DIR/$SCRIPT_FOLDER/activate"
        UPGRADE_PIP_CMD="pip install --upgrade pip"
        RUN_CODE_CMD="python $MAIN_TEMPLATE_FILE"
    fi

}


############# Header ##################
print_header() {
    SCRIPT_NAME="pyease"
    VERSION="1.0.0"
    AUTHOR="Daniel Rodriguez"
    DESCRIPTION="https://github.com/SWimplifyDev/starter-kit"
    echo ""
    header "----------------------------------------------------------"
    header " $SCRIPT_NAME - Version $VERSION"
    header " Author: $AUTHOR"
    header " Description: $DESCRIPTION"
    header "----------------------------------------------------------"
    echo ""
}
################# End Header #############

help() {
    header "-------------------- HELP --------------------------------------------------------------"
    echo "Commands:"
    echo "  init          - Initializes the project setup:"
    echo "                 - Creates a .venv folder for virtual environment."
    echo "                 - Generates .vscode/settings.json to configure VS Code to use the .venv."
    echo "                 - Creates a .gitignore to avoid submitting .venv to the repository."
    echo "                 - Creates a main.py file to start coding right away."
    echo "  run           - Runs the project or starts the application."
    echo "  save_req      - Creates a requirements.txt file if one does not already exist."
    echo "  install_req   - Installs dependencies if a requirements.txt file is available."
    echo "  outdated_req  - Checks if requirements are outdated."
    echo "  update_req    - Updates the project's dependencies."
    echo "  clean         - Removes the .venv and .vscode folders."
    echo "  help          - Displays this help message."
    header "----------------------------------------------------------------------------------------"
}

# Foldes to be created
VENV_DIR=".venv"
VSCODE_DIR=".vscode"

# Files to be created
VSCODE_SETTINGS_FILE="settings.json"
GITIGNORE_FILE=".gitignore"
MAIN_TEMPLATE_FILE="main.py"
REQUIREMENTS_FILE="requirements.txt"

python_interpreter_path="$PWD/$VENV_DIR/bin/python"
json_content="{\"python.defaultInterpreterPath\": \"$python_interpreter_path\"}"

init_system_comands

python_interpreter_path="$PWD/$VENV_DIR/$SCRIPT_FOLDER/python"
json_content="{\"python.defaultInterpreterPath\": \"$python_interpreter_path\"}"


# Functions to applied to .venv
venv(){
    case $1 in
        set)
            # If .venv folder does not exist
            if [ ! -d "$VENV_DIR" ]; then
                # Create .venv as venv virtual environment
                eval $VENV_CMD
                # If previuos command went well
                if [ $? -eq 0 ]; then
                    success "Virtual environment created at '$VENV_DIR'."
                else
                    error "Virtual environment could not be created."
                fi
            else
                info "Virtual environment already set."
            fi
            ;;
        remove)
            # If .venv folder exist
            if [ -d "$VENV_DIR" ]; then
                if rm -r "$VENV_DIR"; then
                    success ".venv deleted successfully."
                else
                    error "Could not delete the virtual environment"
                fi
            else
                info ".venv does not exist."
            fi
            ;;
        activate)
            info "$SYS_INFO"
            # Activate venv

            if eval $ACTIVE_VENV_CMD; then
                if python_version=$(python --version 2>/dev/null); then
                    info "$python_version"
                    info "upgrading pip"
                    venv upgrade_pip
                else
                    error ".venv python version missmatch with the python version installed on your machine"
                    info "Try commands: clean init, to start fresh."
                fi
            else
                error "venv could not be activated"
                info "Try commands: clean init, to start fresh."
            fi
            ;;
        upgrade_pip)
            # Upgrade pip with latest version
            if venv is_activated; then
                eval $UPGRADE_PIP_CMD
            else
                error "pip upgrade cant be done, venv is not activated."
            fi
            ;;
        deactivate)
            if venv is_activated; then
                deactivate
                success "Virtual environment deactivated."
            else
                info "No virtual environment is activated."
            fi
            ;;
        is_activated)
            # Verify if .venv is activated
            if [[ -n "$VIRTUAL_ENV" ]]; then
                # True
                return 0
            else
                # False
                return 1
            fi
            ;;
        *)
            error "Unknown action: $1"
            ;;
    esac
}

# Function to set or remove vscode settings
vscode(){
    case $1 in
        set)
            if [ ! -d "$VSCODE_DIR" ]; then
                mkdir "$VSCODE_DIR"
                touch "$VSCODE_DIR/$VSCODE_SETTINGS_FILE"
                echo "$json_content" > "$VSCODE_DIR/$VSCODE_SETTINGS_FILE"
                success "VSCode Settings created at '$VSCODE_DIR'."
            else
                info "VSCode Settings already set."
            fi
            ;;
        remove)
            if [ -d "$VSCODE_DIR" ]; then
                if rm -r "$VSCODE_DIR"; then
                    success "vscode settings deleted successfully."
                else
                    error "Could not delete vscode settings"
                fi
            else
                info "vscode settings dont not exist."
            fi
            ;;
        *)
            error "Unknown action: $1"
            ;;
    esac
}

# Function to set or remove .gitignore
gitignore(){
    case $1 in
        set)
            if [ ! -e "$GITIGNORE_FILE" ]; then
                echo ".venv" > "$GITIGNORE_FILE"
                echo ".vscode" >> "$GITIGNORE_FILE"
                echo ".DS_Store" >> "$GITIGNORE_FILE"
                echo "__pycache__" >> "$GITIGNORE_FILE"
                success ".gitignore file created."
            else
                info ".gitignore already set"
            fi
            ;;
        remove)
            if [ -e ".gitignore" ]; then
                rm .gitignore
            fi
            ;;
        *)
            error "Unknown action: $1"
            ;;  
    esac
}

# Function to create a main.py file as template
template(){
    case $1 in
        set)
            if [ ! -e "$MAIN_TEMPLATE_FILE" ]; then
                echo "from datetime import datetime" > "$MAIN_TEMPLATE_FILE"
                echo " " >> "$MAIN_TEMPLATE_FILE"
                echo "print(f'Hello pyease, time:{datetime.now()}')" >> "$MAIN_TEMPLATE_FILE"
                success "$MAIN_TEMPLATE_FILE file created."
            else
                info "$MAIN_TEMPLATE_FILE already set"
            fi
            ;;
        *)  
            error "Unknown action: $1"
            ;;
    esac
}

code_editor(){
    case $1 in
        open)
            if command -v code &> /dev/null; then
                code .
            else
                warning "Visual Studio Code is not installed or `code` command hasn't been added to your system's PATH."
            fi
            ;;
        *)  
            error "Unknown action: $1"
            ;;
    esac
}

# Initialize a python project
init(){
    print_header
    venv set
    vscode set
    gitignore set
    venv activate
    template set
    code_editor open
}

run(){
    eval $RUN_CODE_CMD
}

requirements(){
    case $1 in
        save)
            if [ ! -e "$REQUIREMENTS_FILE" ]; then
                pip freeze > $REQUIREMENTS_FILE
                success "$REQUIREMENTS_FILE saved."
            else
                error "$REQUIREMENTS_FILE already exist."
            fi
            ;;
        check_outdated)
            # Get the list of outdated packages
            outdated=$(pip list --outdated)
            # Check if the output is not empty
            if [[ -z "$outdated" ]]; then
                info "All packages are up-to-date."
            else
                warning "There are outdated packages:"
                echo "$outdated"
                info "To update packages run command: update_req"
            fi
            ;;
        install)
            if [ -e "$REQUIREMENTS_FILE" ]; then
                pip install -r $REQUIREMENTS_FILE
                if [ $? -eq 0 ]; then
                    success "All requirements are installed."
                     # Check if there are outdated packages
                    check_outdated
                else
                    error "Packages installation failed."
                    info "Try one by one installation."
                fi
               
            else
                error "There are not $REQUIREMENTS_FILE available"
            fi
            ;;
        update)
            outdated=$(pip list --outdated)
            if [[ -z "$outdated" ]]; then
                pip freeze > $REQUIREMENTS_FILE
                info "All packages are up-to-date."
            else
                info "Updating requirements"
                pip install --upgrade $(pip list --outdated | awk 'NR>2 {print $1}')
                pip freeze > $REQUIREMENTS_FILE
                success "Requirements updated."
            fi
            ;;
        remove)
            if [ -e "$REQUIREMENTS_FILE" ]; then
                rm $REQUIREMENTS_FILE
            fi
            ;;
        *)  
            error "Unknown action: $1"
            ;;
    esac
}

# Delete venv and vscode settings
clean(){
    venv remove
    vscode remove
    venv deactivate
}
###
case "$1" in
    init)
        init
        ;;
    run)
        if venv is_activated; then
            run
        else
            error "There is not .venv activated"
            info "First activate a venv by running the command: init"
        fi
        ;;
    save_req)
        if venv is_activated; then
            requirements save
        else
            error "There is not .venv activated"
            info "First activate a venv by running the command: init"
        fi
        ;;
    install_req)
        if venv is_activated; then
            requirements install
        else
            error "There is not .venv activated"
            info "First activate a venv by running the command: init"
        fi
        ;;
    update_req)
        if venv is_activated; then
            requirements update
        else
            error "There is not .venv activated"
            info "First activate a venv by running the command: init"
        fi
        ;;
    outdated_req)
        if venv is_activated; then
            requirements check_outdated
        else
            error "There is not .venv activated"
            info "First activate a venv by running the command: init"
        fi
        ;;
    clean)
        clean
        ;;
    help)
        help
        ;;
    *)
        error "Usage: pyease {init | run | save_req | install_req | update_req | clean | outdated_req | help}"
        ;;
esac