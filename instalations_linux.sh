#!/bin/bash

# ---------	#
#	CURL	#
# ---------	#

# Function to install curl if not already installed
install_curl() {
	if command -v curl > /dev/null 2>&1; then
		echo "Curl already installed\n"
		return
	fi
	sudo apt update
	sudo apt install -y curl
	echo "Curl installation completed successfully\n"
}

# ---------	#
#	VSCODE	#
# ---------	#

# Function to determine the platform
get_platform() {
	platform=$(uname)
	case $platform in
		"Linux") echo "linux";;
		*) echo "Unsupported platform"; exit 1;;
	esac
}

# Function to determine the latest version of Visual Studio Code
get_latest_vscode_version() {
	version=$(curl -sL https://code.visualstudio.com/sha/ | grep -o '"url":"[^"]*"' | grep -m 1 'stable.*\.deb' | cut -d '"' -f 4)
	echo "$version"
}

# Function to download the file
download_file() {
	url="$1"
	file_name="${url##*/}"
	if [ -e "$file_name" ]; then
		echo "The file was already downloaded\n"
	else
		curl -o "$file_name" -L "$url"
	fi
}

# Function to install the downloaded file
install_file() {
	file="$1"
	chmod +x "$file"
	sudo apt install ./"$file"
	sudo apt install apt-transport-https
	sudo apt update
	sudo apt install code
}

# Function to install visual studio code
install_vscode() {
	if command -v code > /dev/null 2>&1; then
		echo "Visual Studio Code already installed\n"
	else
		install_curl
		latest_version=$(get_latest_vscode_version)
		echo "Latest version of Visual Studio Code link: $latest_version"
		download_file "$latest_version"
		file_name="${latest_version##*/}"
		echo "Downloaded file: $file_name"
		install_file "$file_name"
		echo "VSCode installation completed successfully\n"
	fi
}

# ---------	#
#	Git		#
# ---------	#

# Function to install Git
install_git() {
	if command -v git > /dev/null 2>&1; then
		echo "Git is already installed\n"
	else
		sudo apt update
		sudo apt-get install git
		echo "Git installation completed successfully\n"
	fi
}


# Function to prompt user for instalation choice
prompt_user() {
	while true; do
		echo "What do you want to install?"
		echo "1. Curl command"
		echo "2. Visual Studio Code"
		echo "3. Git"
		echo "4. Python3"
		echo "5. Exit\n"
		read -p "Enter your choice: " choice
		case $choice in
			1) install_curl;;
			2) install_vscode;;
			3) install_git;;
			4) echo "Feature coming soon...\n";;
			5) exit;;
			*) echo "Invalid choice\n";;
		esac
	done
}

main() {
	get_platform
	prompt_user
}

main
