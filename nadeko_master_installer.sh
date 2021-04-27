#!/bin/bash

while true; do
    echo "Welcome to NadekoBot."
    echo ""
    echo "1. Download NadekoBot"
    echo "2. Run NadekoBot in the background"
    echo "3. Run NadekoBot in the background with auto restart"
    echo "4. Stop NadekoBot"
    echo "5. Display '$nadeko_service_name' logs in follow mode"
    echo "6. Install prerequisites"
    echo "7. Set up credentials.json"
    echo "8. Exit"
    read -r choice
    case "$choice" in
        1)
            # Downloads 'nadeko_latest_installer.sh' and executes it
            ;;
        2)
            # Executes function to start/restart NadekoBot in the background, 
            # using a daemon service
            ;;
        3)
            # Executes function to start/restart NadekoBot in the background
            # with auto restart, using a daemon service
            ;;
        4)
            # Executes code to stop nadeko.service
            ;;
        5)
            # Executes code to monitor and see the output of NadekoBot/'nadeko.service'
            ;;
        6)
            # Downloads 'prereqs_installer.sh' and executes it
            ;;
        7)
            # Downloads 'credentials_setup.sh' and executes it
            ;;
        8)
            clean_exit "0" "Exiting"
            ;;
        *)
            clear -x
            echo "${red}Invalid input: '$choice' is not a valid option$nc" >&2
            ;;
    esac
done
