#!/bin/bash

set -e

ANSIBLE_VERSION="11.*"      # https://pypi.org/project/ansible/
PYYAML_VERSION="6.*"        # https://pypi.org/project/pyaml/
JINJA2_VERSION="3.*"        # https://pypi.org/project/Jinja2/
ANSIBLE_LINT_VERSION="25.*" # https://pypi.org/project/ansible-lint/

VENV_DIR="${HOME}/.venv/ansible${ANSIBLE_VERSION%%.*}"

if ! command -v python3 &> /dev/null; then
    echo "Python3 is not installed. Please install it using Homebrew: 'brew install python3'"
    exit 1
fi

if ! command -v pip3 &> /dev/null; then
    echo "pip3 is not installed. Please install it: 'python3 -m ensurepip --upgrade'"
    exit 1
fi

echo "This script will install ansible $ANSIBLE_VERSION in virtual environment at $VENV_DIR using python3..."
read -p "Do you want to proceed? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Exiting..."
    exit 1
fi

echo "Creating virtual environment in $VENV_DIR..."
python3 -m venv "$VENV_DIR"

echo "Activating virtual environment..."
source "$VENV_DIR/bin/activate"

echo "Upgrading pip..."
pip3 install --upgrade pip

echo "Installing Ansible and dependencies..."
pip3 install \
    "ansible==${ANSIBLE_VERSION}" \
    "PyYAML==${PYYAML_VERSION}" \
    "Jinja2==${JINJA2_VERSION}" \
    "ansible-lint==${ANSIBLE_LINT_VERSION}" \
    "netaddr==1.3.0"

echo "Installed packages:"
pip3 freeze

echo "Installing Ansible Galaxy requirements..."
ansible-galaxy install -r requirements.yml

echo "Deactivating virtual environment..."
deactivate

echo "Setup complete. To activate the virtual environment, run: source $VENV_DIR/bin/activate"
