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
    PURPLE_COLOR="\033[1;34m" #
    RESET_COLOR="\033[0m"    # Reset    
    }
# Function to print info messages
  info() {
    local message=$1
    echo -e "[${INFO_COLOR}info${RESET_COLOR}] ${message}"
  }

  # Function to print success messages
  success() {
    local message=$1
    echo -e "[${SUCCESS_COLOR}success${RESET_COLOR}] ${message}"
  }

  # Function to print warning messages
  warning() {
    local message=$1
    echo -e "[${WARNING_COLOR}warning${RESET_COLOR}] ${message}"
  }

  # Function to print error messages
  error() {
    local message=$1
    echo -e "[${ERROR_COLOR}error${RESET_COLOR}] ${message}"
  }

  header(){
    local text=$1
    echo -e "${PURPLE_COLOR}${text}${RESET_COLOR}"
  }

}

MessagePrinter
int 
########################## End Message Printer Code ##########################

############# Header ##################
print_header() {
    SCRIPT_NAME="pyease"
    VERSION="1.0.0"
    AUTHOR="Daniel Rodriguez"
    DESCRIPTION="https://github.com/SWimplifyDev/starter-kit"
    echo ""
    header "##########################################################"
    header " $SCRIPT_NAME - Version $VERSION"
    header " Author: $AUTHOR"
    header " Description: $DESCRIPTION"
    header "##########################################################"
    echo ""
}
################# End Header #############

help() {
    header "#################### HELP ###########################################################"
    echo "Usage: pyease {init | run | save_req | install_req | update_req | clean | help}"
    echo ""
    echo "Commands:"
    echo "  init          - Initializes the project setup (e.g., creates .venv, main.py, etc.)."
    echo "  run           - Runs the project or starts the application."
    echo "  save_req      - Saves the project's current requirements (e.g., via pip freeze)."
    echo "  install_req   - Installs the project's required dependencies."
    echo "  update_req    - Updates the project's dependencies."
    echo "  clean         - Cleans up the project by removing unnecessary files or directories."
    echo "  help          - Displays this help message."
    header "#####################################################################################"
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

# Function to set or remove venv
venv(){
    case $1 in
        set)
            if [ ! -d "$VENV_DIR" ]; then
                python3 -m venv $VENV_DIR
                success "Virtual environment created at '$VENV_DIR'."
            else
                info "Virtual environment already set."
            fi
            ;;
        remove)
            if [ -d "$VENV_DIR" ]; then
                if rm -r "$VENV_DIR"; then
                    success "venv deleted successfully."
                else
                    error "Could not delete the virtual environment"
                    exit 1
                fi
            else
                info "venv does not exist."
            fi
            ;;
        activate)
            if [ -f "$VENV_DIR/bin/activate" ]; then
                source $VENV_DIR/bin/activate
                info "Running from Unix"
                python_version=$(python --version)
                info "$python_version"
            elif [ -f "$VENV_DIR/Scripts/activate" ]; then
                source $VENV_DIR/Scripts/activate
                info "Running from Win"
                python_version=$(python --version)
                info "$python_version"
            fi
            ;;
        deactivate)
            if [[ -n "$VIRTUAL_ENV" ]]; then
                deactivate
                success "Virtual environment deactivated."
            else
                info "No virtual environment is activated."
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
                    exit 1
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
    pip install --upgrade pip
    template set
    code_editor open
}

run(){
    python $MAIN_TEMPLATE_FILE
}

requirements(){
    case $1 in
        save)
            pip freeze > $REQUIREMENTS_FILE
            success "Requirements saved."
            ;;
        install)
            if [ -e "$REQUIREMENTS_FILE" ]; then
                pip install -r $REQUIREMENTS_FILE
                success "All requirements are installed."
            else
                error "There are not $REQUIREMENTS_FILE available"
            fi
            ;;
        update)
            # Get the list of outdated packages
            outdated=$(pip list --outdated)
            # Check if the output is not empty
            if [[ -z "$outdated" ]]; then
                info "All packages are up-to-date."
            else
                warning "There are outdated packages:"
                echo "$outdated"
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
    requirements remove
    gitignore remove
    venv deactivate
}
###
case "$1" in
    init)
        init
        ;;
    run)
        run
        ;;
    save_req)
        requirements save
        ;;
    install_req)
        requirements install
        ;;
    update_req)
        requirements update
        ;;
    clean)
        clean
        ;;
    help)
        help
        ;;
    *)
        error "Usage: pyease {init | run | save_req | install_req | update_req | clean | help}"
        ;;
esac