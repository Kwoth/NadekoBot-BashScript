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
    #echo "2. Run NadekoBot in the background"
    echo "2. Run Nadeko (Normally)"
    #echo "3. Run NadekoBot in the background with auto restart"
    echo "3. Run Nadeko with Auto Restart in this session"
    #echo "4. Stop NadekoBot"
    echo "4. Auto-Install Prerequisites (For Ubuntu, Debian and CentOS)"
    #echo "5. Display '<nadeko service name>' logs in follow mode"
	echo "5. Auto-Install pm2 (For pm2 information, see README!)"
    #echo "6. Install prerequisites"
	echo "6. Start Nadeko in pm2 (Complete option 6 first!)"
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
            # TODO: Replace the code below in future PRs.
            echo ""
			echo "Running Nadeko Normally, if you are running this to check Nadeko, use .die command on discord to stop Nadeko."
			curl -s "$_RAW_URL"/nadeko_run.sh -o nadeko_run.sh &&
                bash nadeko_run.sh
			echo ""
			echo "Welcome back to NadekoBot."
			sleep 2s
            ;;
        3)
            # TODO: Replace the code below in future PRs.
            echo ""
            echo "Running Nadeko with Auto Restart you will have to close the session to stop the auto restart."
            sleep 5s
            curl -s "$_RAW_URL"/NadekoAutoRestartAndUpdate.sh -o NadekoAutoRestartAndUpdate.sh &&
                bash NadekoAutoRestartAndUpdate.sh
            echo ""
            echo "That did not work?"
            sleep 2s
            ;;
        4)
            # TODO: Replace the code below in future PRs.
            echo ""
            echo "Getting the Auto-Installer for Debian/Ubuntu"
            curl -s "$_RAW_URL"/nadekoautoinstaller.sh -o nadekoautoinstaller.sh &&
                bash nadekoautoinstaller.sh
            echo ""
            echo "Welcome back..."
            sleep 2s
            ;;
        5)
            # TODO: Replace the code below in future PRs.
            echo ""
            echo "Starting the setup for pm2 with NadekoBot. This only has to be done once."
            curl -s "$_RAW_URL"/nadekopm2setup.sh -o nadekopm2setup.sh &&
                bash nadekopm2setup.sh
            echo ""
            echo "Welcome back..."
            sleep 2s
            ;;
        6)
            # TODO: Replace the code below in future PRs.
            echo ""
            echo "Getting the pm2 startup options for NadekoBot.."
            curl -s "$_RAW_URL"/nadekobotpm2start.sh -o nadekobotpm2start.sh &&
                bash nadekobotpm2start.sh
            echo ""
            sleep 2s
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
