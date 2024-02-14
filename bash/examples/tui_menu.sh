#!/bin/bash

show_menu() {
    local options=("Option 1" "Option 2" "Option 3" "Special Option" "Exit")
    local choice

    while true; do
        clear
        echo "[ Menu ]"
        echo "-----------------------------"
        for i in "${!options[@]}"; do
            echo " $((i+1)). ${options[$i]}"
        done
        echo "-----------------------------"
        read -p "Choose one: " choice
        case $choice in
            1|2|3) echo "You've chosen option #$choice" ;;
            4) echo "You've chosen special option!" ;;
            5) echo "Terminated..." && exit ;;
            *) echo "Choose correct one!" ;;
        esac
        read -s -n 1 -r -p "Press any key to continue..."
    done
}

show_menu
