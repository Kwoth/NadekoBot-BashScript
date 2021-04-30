#!/bin/bash
#
# The master/main installer for macOS and Linux Distributions.
#
########################################################################################
#### [ Variables and Functions ]
#### The variables and functions below are designed specifically for either
#### macOS or linux distribution.


export _NADEKO_MASTER_INSTALLER_PID=$$

# More stuff to be added in later PRs.


#### End of [ Variables and Functions ]
########################################################################################
#### [ Main ]

while true; do
    echo "Welcome to NadekoBot."
    echo ""
    echo "1. Download NadekoBot"
    echo "2. Run NadekoBot in the background"
    echo "3. Run NadekoBot in the background with auto restart"
    echo "4. Stop NadekoBot"
    #echo "5. Display '$nadeko_service_name' logs in follow mode"
    echo "5. Display '<nadeko service name>' logs in follow mode"
    echo "6. Install prerequisites"
    echo "7. Set up credentials.json"
    echo "8. Exit"
    read -r choice
    case "$choice" in
        1)
            # Download latest version of 'nadeko_latest_installer.sh'.
            curl -s "$_RAW_URL"/nadeko_latest_installer.sh -o nadeko_latest_installer.sh || {
                echo "${_RED}Failed to download latest 'nadeko_latest_installer.sh'...$_NC" >&2
                clean_exit "1" "Exiting" "true"
            }

            clear -x  # Clears screen of current content.
            printf "We will now download/update NadekoBot. "
            read -rp "Press [Enter] to begin."
            sudo chmod +x nadeko_latest_installer.sh && ./nadeko_latest_installer.sh

            # Rexecutes the new/downloaded version of 'installer_prep.sh'
            exec "$_INSTALLER_PREP"
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
            echo "${_RED}Invalid input: '$choice' is not a valid option$_NC" >&2
            ;;
    esac
done


#### End of [ Main ]
################################################################################
