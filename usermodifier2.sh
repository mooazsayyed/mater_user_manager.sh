#!/bin/bash

# Define a log file path
log_file="/var/log/user_modification.log"

# Function to log messages to the log file and echo them
log_message() {
    local message="$1"
    local timestamp="$(date '+%Y-%m-%d %H:%M:%S')"

    # Log the message to the log file
    echo "$timestamp - $message" >> "$log_file"

    # Echo the message to the console
    echo "$message"
}

read -p "Enter username to modify: " user
if id "$user" &>/dev/null; then
    log_message "User '$user' exists."
else
    log_message "User '$user' does not exist."
    exit 1  # Exit the script if the user doesn't exist
fi

log_message "User details for '$user':"
id "$user"

echo "What do you want to change?"
read -p "Enter 1 for username and 2 for password: " chg
if [ "$chg" == 1 ]; then
    read -p "Enter new username: " newusername
    sudo usermod -l "$newusername" "$user"
    log_message "Username changed from '$user' to '$newusername'."
elif [ "$chg" == 2 ]; then
    echo "Changing password ..."
    sudo passwd "$user"
    log_message "Password changed for user '$user'."
else
    log_message "Invalid option selected: $chg"
    echo "Please pick a valid option."
fi
