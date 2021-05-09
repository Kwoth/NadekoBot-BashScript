#!/bin/bash
#
# The master/main installer for macOS and Linux Distributions.
#
########################################################################################
#### [ Variables and Functions ]


# Keeps track of this script's process id, in case it needs to be manually killed.
export _NADEKO_MASTER_INSTALLER_PID=$$


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
            echo "Downloading 'nadeko_latest_installer.sh'..."
            
            # Download latest version of 'nadeko_latest_installer.sh'.
            curl -s "$_RAW_URL"/nadeko_latest_installer.sh -o nadeko_latest_installer.sh || {
                echo "${_RED}Failed to download latest 'nadeko_latest_installer.sh'...$_NC" >&2
                clean_exit "1" "Exiting" "true"
            }
            clear -x  # B.1. Clears screen of current content.
            sudo chmod +x nadeko_latest_installer.sh && ./nadeko_latest_installer.sh

            # Rexecutes the new/downloaded version of 'installer_prep.sh', so that all
            # changes are applied.
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
            ## Please ignore the commented code below. It will be used in later PRs.
            #if [[ $disabled_7 = true ]]; then
            #    echo "${red}Option 7 is currently disabled${nc}"
            #    continue
            #fi

            echo "Downloading 'credentials_setup.sh'..."

            # Download latest version of 'credentials_setup.sh'.
            curl -s "$_RAW_URL"/credentials_setup.sh -o credentials_setup.sh || {
                echo "${_RED}Failed to download latest 'credentials_setup.sh'...$_NC" >&2
                clean_exit "1" "Exiting" "true"
            }
            clear -x  # B.1.
            sudo chmod +x credentials_setup.sh && ./credentials_setup.sh
            clear -x  # B.1.
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
