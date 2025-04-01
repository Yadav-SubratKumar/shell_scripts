#!/bin/bash

if [[ $1 == "-c" || $1 == "--create" ]]; then
    # Create a user
    read -p "Enter Username: " uname
    read -p "Enter Password: " pwd

    # Check if user exists
    if id -u "$uname" > /dev/null 2>&1; then
        echo "User already exists, try a different name."
    else
        sudo useradd "$uname"
        echo "$uname:$pwd" | sudo chpasswd
        echo "User created successfully."
    fi

elif [[ $1 == "-d" || $1 == "--delete" ]]; then
    # Delete a user
    read -p "Enter Username: " uname

    # Check if user exists
    if id -u "$uname" > /dev/null 2>&1; then
        read -p "Want to keep the home directory (yes/no)? " home_del
        if [[ $home_del == "yes" ]]; then
            sudo deluser "$uname"
        else
            sudo deluser --remove-home "$uname"
        fi
        echo "User deleted successfully."
    else
        echo "User does not exist."
    fi

elif [[ $1 == "-r" || $1 == "--reset" ]]; then
    # Check if user exists
    read -p "Enter Username: " uname
    if id -u "$uname" > /dev/null 2>&1; then
        read -p "Enter password" pwd
        echo "$uname:$pwd" | sudo chpasswd
        echo "Password changed for $uname"
    else
        echo "User does not exists "

    fi
elif [[ $1 == "ls" || $1 == "--list" ]]; then

    awk -F'[/:]' '{if ($3 >= 1000 && $3 != 65534) print $1, $3,$7,"/",$8}' /etc/passwd
elif [[ $1 == "--help" ]]; then
        echo "This script lets you to handle user management task like user creation (-c,--create), deletion (-d, --delete) reset password (-r, --reset) and list users (ls, --list)"


else
    echo "Invalid option. Use -c/--create to create a user or -d/--delete to delete a user."
fi
