#!/bin/bash
#
# Downloads and updates NadekoBot.
#
########################################################################################
#### [ Variables ]


bak_credentials="NadekoBot.bak/output/NadekoBot/credentials.json"
new_credentials="NadekoBot/output/NadekoBot/credentials.json"
bak_database="NadekoBot.bak/output/NadekoBot/bin/"
new_database="NadekoBot/output/NadekoBot/bin/"
notcoreapp_version="netcoreapp3.1"


#### End of [ Variables ]
########################################################################################
#### [ Functions ]


clean_up() {
    ####
    # FUNCTION INFO:
    #
    # Cleans up any loose ends/left over files.
    #
    # @param $1 Determines whether or not this function kills the script's parent
    #           processes.
    ####

    # Files to be removed.
    local installer_files=("credentials_setup.sh" "installer_prep.sh"
        "prereqs_installer.sh" "nadeko_latest_installer.sh"
        "nadeko_master_installer.sh")

    echo "Cleaning up files and directories..."
    # NOTE: Unsure if this if statement is needed.
    if [[ -d $_WORKING_DIR/tmp ]]; then rm -rf "$_WORKING_DIR"/tmp; fi
    # Remove the NadekoBot code that was just downloaded.
    if [[ -d $_WORKING_DIR/NadekoBot ]]; then rm -rf "$_WORKING_DIR"/NadekoBot; fi
    ## Remove all files in the 'installer_files' array, if they exist.
    for file in "${installer_files[@]}"; do
        if [[ -f $_WORKING_DIR/$file ]]; then rm "$_WORKING_DIR"/"$file"; fi
    done

    ## Restore the old code, if it exists.
    if [[ -d $_WORKING_DIR/NadekoBot.bak ]]; then
        echo "Restoring from 'NadekoBot.bak'..."
        mv -f "$_WORKING_DIR"/NadekoBot.bak "$_WORKING_DIR"/NadekoBot || {
            echo "${_RED}Failed to restore from 'NadekoBot.bak'" >&2
            echo "${_CYAN}Manually rename 'NadekoBot.bak' to 'NadekoBot'$_NC"
        }
    fi

    if [[ $1 = true ]]; then
        echo "Killing parent processes..."
        kill -9 "$_NADEKO_MASTER_INSTALLER_PID" "$_INSTALLER_PREP_PID"
        echo "Exiting..."
        exit 1
    fi
}


#### End of [ Functions ]
########################################################################################
#### [ Error Trapping ]


# Executes when the user uses 'Ctrl + Z' or 'Ctrl + C'.
trap 'echo -e "\n\nScript forcefully stopped"
    clean_up
    echo "Killing parent processes..."
    kill -9 "$_NADEKO_MASTER_INSTALLER_PID" "$_INSTALLER_PREP_PID"
    echo "Exiting..."
    exit 1' \
    SIGINT SIGTSTP SIGTERM


#### End of [ Error Trapping ]
########################################################################################
#### [ Prepping ]


## NOTE: The commented code below will only be applicable in later PRs. Please ignore it
## for now.
# 'active' is used on Linux and 'running' is used on macOS
#if [[ $nadeko_service_status = "active" || $nadeko_service_status = "running" ]]; then
    # B.1. $nadeko_service_active = true when '$nadeko_service_name' is active, and is
    # used to indicate to the user that the service was stopped and that they will need
    # to start it
#    nadeko_service_active=true
#    service_actions "stop_service" "false"
#fi


#### End of [ Prepping ]
########################################################################################
#### [ Main ]

####################################################################################
######## [ Create Backup, Then Update ]

## Create a backup of NadekoBot, if it currently exists.
if [[ -d NadekoBot ]]; then
    echo "Backing up NadekoBot as 'NadekoBot.bak'..."
    mv -f NadekoBot NadekoBot.bak || {
        echo "${_RED}Failed to back up NadekoBot$_NC" >&2
        echo -e "\nPress [Enter] to return to the installer menu"
        clean_up "false"
    }
fi

echo "Downloading NadekoBot..."
git clone -b 1.9 --recursive --depth 1 https://gitlab.com/Kwoth/NadekoBot || {
    echo "${_RED}Failed to download NadekoBot$_NC" >&2
    clean_up "true"
}

# If the _DISTRO isn't Darwin and '/tmp/NuGetScratch' exists...
if [[ -d /tmp/NuGetScratch && $_DISTRO != "Darwin" ]]; then
    echo "Modifying ownership of '/tmp/NuGetScratch' and '/home/$USER/.nuget'"
    # Due to permission errors cropping up every now and then, especially when the
    # installer is executed with root privileges, it's neccessary to make sure that 
    # '/tmp/NuGetScratch' and '/home/$USER/.nuget' is owned by the user the installer is
    # currently being executed under.
    sudo chown -R "$USER":"$USER" /tmp/NuGetScratch /home/"$USER"/.nuget || {
        echo "${_RED}Failed to to modify the ownership of '/tmp/NuGetScratch' and/or" \
            "'/home/$USER/.nuget'" >&2
        # NOTE: Unsure if the echo below is needed or not.
        echo "${_CYAN}You can ignore this if you were not prompted about locked" \
            "files/permission errors while attempting to download dependencies$_NC"
    }
fi

echo "Building NadekoBot..."
cd NadekoBot || {
    echo "${_RED}Failed to change working directory$_NC" >&2
    clean_up "true"
}
dotnet build --configuration Release || {
    echo "${_RED}Failed to build NadekoBot$_NC" >&2
    clean_up "true"
}
cd "$_WORKING_DIR" || {
    echo "${_RED}Failed to return to the project's root directory$_NC" >&2
    clean_up "true"
}

if [[ -d NadekoBot.old && -d NadekoBot.bak || ! -d NadekoBot.old && -d NadekoBot.bak ]]; then
    echo "Copping 'credentials.json' to new version..."
    cp -f "$bak_credentials" "$new_credentials" &>/dev/null
    echo "Copping database to the new version..."
    cp -RT "$bak_database" "$new_database" &>/dev/null
    
    ## Checks if an old netcoreapp version exists, then moves the database in it, to the
    ## new netcorapp version.
    while read -r netcoreapp; do
        if [[ $netcoreapp != "$notcoreapp_version" ]]; then
            echo "${_YELLOW}WARNING: Old netcoreapp version detected$_NC"
            echo "Moving database to new netcoreapp version..."
            cp -RT "$new_database"/Release/"$netcoreapp"/data/NadekoBot.db \
                    "$new_database"/Release/"$notcoreapp_version"/data/NadekoBot.db \
                    &>/dev/null || {
                echo "${_RED}Failed to move database$_NC" >&2
                clean_up "true"
            }
            echo "Removing '$netcoreapp'..."
            rm -rf "$new_database"/Release/"$netcoreapp" || {
                echo "${_RED}Failed to move '$netcoreapp' to active directory" >&2
                echo -e "${_CYAN}Please manually remove '$netcoreapp' before continuing" \
                    "\nLocation: $_WORKING_DIR/$new_database/Release/$netcoreapp$_NC"
            }
        fi
    done < <(ls "$_WORKING_DIR"/"$new_database"/Release/)

    echo "Copping other data to the new version..."
    cp -RT NadekoBot.bak/src/NadekoBot/data/ NadekoBot/src/NadekoBot/data/
    # TODO: Add error handling???
    rm -rf NadekoBot.old && mv -f NadekoBot.bak NadekoBot.old
fi

## NOTE: The commented code below will only be applicable in later PRs. Please ignore it
## for now.
#if [[ $_DISTRO != "Darwin" ]]; then
#    if [[ -f $nadeko_service ]]; then
#        echo "Updating '$nadeko_service_name'..."
#        create_or_update="update"
#    else
#        echo "Creating '$nadeko_service_name'..."
#        create_or_update="create"
#    fi
#
#    echo -e "$nadeko_service_content" | sudo tee "$nadeko_service" &>/dev/null &&
#            sudo systemctl daemon-reload || {
#        echo "${_RED}Failed to $create_or_update '$nadeko_service_name'$_NC" >&2
#        b_s_update="Failed"
#    }
#fi


######## End of [ Create Backup, Then Update ]
####################################################################################
######## [ Clean Up and Present Results ]


echo -e "\n${_GREEN}Finished downloading/updating NadekoBot$_NC"

## NOTE: The commented code below will only be applicable in later PRs. Please ignore it
## for now.
#if [[ $b_s_update ]]; then
#    echo "${_YELLOW}WARNING: Failed to $create_or_update '$nadeko_service_name'$_NC"
#fi
# B.1.
#if [[ $nadeko_service_active ]]; then
#    echo "${_CYAN}NOTE: '$nadeko_service_name' was stopped to update" \
#        "NadekoBot and has to be started using the run modes in the" \
#        "installer menu$_NC"
#fi

read -rp "Press [Enter] to apply any existing changes to the installers"


######## End of [ Clean Up and Present Results ]
####################################################################################

#### End of [ Main ]
########################################################################################
