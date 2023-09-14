#!/bin/bash

# Define the output file for the user report
report_file="/var/log/user_report.txt"

# Function to generate user reports
generate_user_report() {
    local username="$1"
    local report="$2"

    echo "User Report for: $username" >> "$report"
    echo "-----------------------------" >> "$report"

    # Retrieve user information and add it to the report
    user_info=$(grep -E "^$username:" /etc/passwd)
    echo "User Info: $user_info" >> "$report"

    # Retrieve user's home directory
    home_directory=$(eval echo ~"$username")
    echo "Home Directory: $home_directory" >> "$report"

    # Add more user attributes as needed

    echo "" >> "$report"  # Add an empty line between reports
}

# Create a new report file (or overwrite an existing one)
echo "User Account Reports" > "$report_file"
echo "Generated on: $(date)" >> "$report_file"
echo "" >> "$report_file"

# Get a list of all user accounts
user_list=$(cut -d: -f1 /etc/passwd)

# Loop through each user and generate a report
for user in $user_list; do
    generate_user_report "$user" "$report_file"
done

echo "User reports have been generated and saved to: $report_file"
