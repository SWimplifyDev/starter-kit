# Starter Kit Dev Project

This repository contains shell scripts to automate the initial setup of various programming projects. Each script is designed to save time and establish a standardized project structure, ready for coding.

## Scripts

### `pyease` - Python Project Starter

The `pyease` script automates the creation of a Python project with a virtual environment, VS Code settings, and essential project files.

#### Features

- Creates a `.venv` folder for virtual environment management.
- Generates `.vscode/settings.json` for project-specific VS Code configurations.
- Sets up a `.gitignore` file tailored for Python projects.
- Creates a `main.py` file, ready to start coding.
- Additional functionality for streamlined project setup.

#### Usage

You can run the `pyease` script in two ways:

##### 1. Direct Execution from the URL

Run the script directly from its URL using `curl` and `source`:

```bash
source <(curl -fsSL https://raw.githubusercontent.com/SWimplifyDev/starter-kit/main/pyease.sh) [options]
```

This method ensures you always use the latest version of the script without downloading it locally.

#### 2. Download and Run Locally

Download the script and run it locally:

1. Clone the repository or download the script:

```bash
curl -O https://raw.githubusercontent.com/SWimplifyDev/starter-kit/main/pyease.sh
```

2. Run the script:

```bash
source pyease.sh [options]
```

#### Options

| Option        | Description                                                                 |
|---------------|-----------------------------------------------------------------------------|
| `init`        | Initializes the project setup:                                              |
|               | - Creates a `.venv` folder for virtual environment.                         |
|               | - Generates `.vscode/settings.json` to configure VS Code to use the `.venv`.|
|               | - Creates a `.gitignore` to avoid submitting `.venv` to the repository.     |
|               | - Creates a `main.py` file to start coding right away.                      |
| `run`         | Runs the project or starts the application.                                 |
| `save_req`    | Creates a `requirements.txt` file if one does not already exist.            |
| `install_req` | Installs the project's required dependencies.                               |
| `update_req`  | Updates the project's dependencies.                                         |
| `clean`       | Cleans up the project by removing unnecessary files or directories.         |
| `help`        | Displays this help message.                                                 |

#### Examples

```bash
# Run the script with all features directly from the URL
source <(curl -fsSL https://raw.githubusercontent.com/SWimplifyDev/starter-kit/main/pyease.sh) init

# Run the script locally to create only a virtual environment and a main.py file
source pyease.sh init
```

#### Prerequisites

- Bash installed on your system.
- Python installed on your system (version 3.6 or higher is recommended).
- Ensure the script has execution permissions if running locally. Use `chmod +x pyease.sh` if necessary.

#### Contributing

Feel free to contribute new features or scripts to this repository. Fork the repo, make your changes, and submit a pull request!

<!-- #### Notes

Access the raw content:
```bash
https://raw.githubusercontent.com/SWimplifyDev/starter-kit/main/pyease.sh
```

Run the script from github:

```bash
curl -fsSL https://raw.githubusercontent.com/SWimplifyDev/starter-kit/main/pyease.sh | bash
```

with commands

```bash
curl -fsSL -H "Cache-Control: no-cache" https://raw.githubusercontent.com/SWimplifyDev/starter-kit/main/pyease.sh | bash -s -- init
```

Run the script from github using source
```bash
source <(curl -fsSL https://raw.githubusercontent.com/SWimplifyDev/starter-kit/main/pyease.sh)
```

with commands

```bash
source <(curl -fsSL https://raw.githubusercontent.com/SWimplifyDev/starter-kit/main/pyease.sh) init
```

Download the script:

```bash
curl -fsSL https://raw.githubusercontent.com/SWimplifyDev/starter-kit/main/pyease.sh -o pyease.sh
```

Then run it from local:

```bash
bash pyease.sh init
```

or using source

```bash
source pyease.sh init
``` -->