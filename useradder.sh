#!/bin/bash

# Read the user file name
read -p "Enter the user file name (e.g., /home/mooaz/bashfriday/newusers.txt): " userfile

default_password="ChangeMe123"  # Set a default password here

# Check if the user file exists
if [ ! -f "$userfile" ]; then
    echo "User file '$userfile' not found."
    exit 1
fi

# Read usernames from the file into an array
usernames=($(cat "$userfile" | tr 'A-Z' 'a-z'))

# Loop through the array and create users
for username in "${usernames[@]}"; do
    # Check if the user already exists
    if id "$username" &>/dev/null; then
        echo "User '$username' already exists. Skipping."
    else
        # Create the user with the default password
        useradd -m -s /bin/bash "$username"
        echo "$username:$default_password" | chpasswd
        echo "User '$username' created with password: $default_password"
    fi
done

echo "${#usernames[@]} users have been created"

# Display the newly created users
tail -n "${#usernames[@]}" /etc/passwd
