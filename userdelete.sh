#!/bin/bash

# Read the user file name
read -p "Enter the user file name (e.g., /home/mooaz/bashfriday/deleteusers.txt): " userfile

# Check if the user file exists
if [ ! -f "$userfile" ]; then
    echo "User file '$userfile' not found."
    exit 1
fi

# Read usernames from the file into an array
usernames=($(cat "$userfile" | tr 'A-Z' 'a-z'))

# Loop through the array and delete users
for username in "${usernames[@]}"; do
    # Check if the user exists
    if id "$username" &>/dev/null; then
        echo "Deleting user '$username'..."
        sudo userdel -r "$username"
        echo "User '$username' and their home directory have been deleted."
    else
        echo "User '$username' does not exist. Skipping."
    fi
done

echo "${#usernames[@]} users have been deleted"
