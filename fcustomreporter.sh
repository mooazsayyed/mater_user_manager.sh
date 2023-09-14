#!/bin/bash

# Define the default output directory for user reports
report_filename="/var/log/user_report_$(date +"%Y%m%d%H%M%S").txt"
user_input_array=()

# ANSI escape codes for text formatting
bold=$(tput bold)
normal=$(tput sgr0)
red=$(tput setaf 1)
green=$(tput setaf 2)
blue=$(tput setaf 4)

# Function to customize the report based on user preferences
options_to_include() {
    user_input_array=()
    x=5

    echo "${bold}${blue}Customize User Report${normal}"
    echo "---------------------"
    echo "1. ${bold}Include Username${normal}"
    echo "2. ${bold}Include Full Name${normal}"
    echo "3. ${bold}Include Home Directory${normal}"
    echo "4. ${bold}Include Account Creation Date${normal}"
    echo "5. ${bold}Include Last Logged Info${normal}"
    echo "6. ${bold}Exit and Stop${normal}"
    echo "7. ${bold}Generate Report${normal}"

    while [ $x -le 7 ]; do
        read -p "Enter your desired option number or enter 6 to exit: " input

        if [ -z "$input" ]; then
            break  # Exit the loop if the input is empty
        elif [ "$input" == 6 ]; then
            exit
        elif [ "$input" == 7 ]; then
            report_generation
        else
            # Append the input to the array
            user_input_array+=("$input")
        fi
    done
}

# Function to generate the user report
report_generation() {
    if [ ${#user_input_array[@]} -eq 0 ]; then
        echo "${red}No options selected. Please customize the report.${normal}"
        sleep 2
        return
    fi

    # Generate a unique report filename based on the timestamp
    report_filename="/var/log/user_report_$(date +"%Y%m%d%H%M%S").txt"
    home_directory=$(eval echo ~"$user")

    echo "${bold}${green}Generating user report...${normal}"
    echo "${bold}${blue}Selected Options: ${user_input_array[@]}${normal}"

    # Initialize the report content
    report_content="${bold}${red}User Account Report${normal}\n"
    report_content+="Generated on: $(date)\n\n"

    # Retrieve user's home directory
    report_content+="${bold}Username:${normal} $user\n"
    report_content+="${bold}Home Directory:${normal} $home_directory\n"

    # Retrieve user's full name (if available)
    full_name=$(getent passwd "$user" | cut -d: -f5)
    if [ -n "$full_name" ]; then
        report_content+="${bold}Full Name:${normal} $full_name\n"
    fi
    # Retrieve account creation date
    creation_date=$(sudo passwd -S "$user" | awk '{print $3}')
    if [ -n "$creation_date" ]; then
        report_content+="${bold}Account Creation Date:${normal} $creation_date\n"
    fi

    # Add more user attributes as needed

    # Save the report to the specified path
    echo -e "$report_content" > "$report_filename"

    echo "${bold}${green}User report has been generated and saved to: $report_filename${normal}"  # Print the report path
}

# Main script

echo "${bold}${blue}User Account Reports${normal}"
echo "---------------------"
echo ""

# Customize and generate the user report
read -p "Enter username for user: " user
options_to_include
