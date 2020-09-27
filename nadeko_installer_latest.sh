#!/bin/bash

################################################################################
#
# Downloads and updates nadeko
#
# Note: All variables not defined in this script, are exported from
# 'linuxPMI.sh', 'installer-prep.sh', and 'linux-master-installer.sh'.
#
################################################################################
#
# [ Functions ]
#
################################################################################
#
    # Cleans up any loose ends/left over files
    clean_up() {
        local installer_files=("credentials_setup.sh" "installer_prep.sh"
            "nadeko_installer_latest.sh" "nadeko_master_installer.sh" "NadekoARB.sh"
            "NadekoARBU.sh" "NadekoB.sh" "prereqs_installer.sh")

        echo "Cleaning up files and directories..."
        if [[ -d tmp ]]; then rm -rf tmp; fi
        if [[ -d NadekoBot ]]; then rm -rf NaadekoBot; fi
        for file in "${installer_files[@]}"; do
            if [[ -f $file ]]; then rm "$file"; fi
        done

        # TODO: Rename NadekoBot.old to NadekoBot_Old (something like that)
        if [[ -d NadekoBot.bak ]]; then
            echo "Restoring from 'NadekoBot.bak'"
            mv -f NadekoBot.bak NadekoBot || {
                echo "${red}Failed to restore from 'NadekoBot.old'" >&2
                echo "${cyan}Manually rename 'NadekoBot.old' to 'NadekoBot'${nc}"
            }
        fi

        if [[ $1 = "true" ]]; then
            echo "Killing parent processes..."
            kill -9 "$nadeko_master_installer_pid" "$installer_prep_pid"
            echo "Exiting..."
            exit 1
        fi
    }

#
################################################################################
#
# [ Main ]
#
################################################################################
#
    printf "We will now download/update Nadeko. "
    read -p "Press [Enter] to begin."

    ############################################################################
    # Error trapping
    ############################################################################
    # TODO: Figure out how to silently kill a process
    trap "echo -e \"\n\nScript forcefully stopped\"
            clean_up
            echo \"Killing parent processes...\"
            kill -9 \"$linux_master_installer_pid\" \"$installer_prep_pid\"
            echo \"Exiting...\"
            exit 1" \
        SIGINT SIGTSTP SIGTERM

    ############################################################################
    # Prepping
    ############################################################################
    # 'active' is used on Linux and 'running' is used on macOS
    if [[ $nadeko_service_status = "active" || $nadeko_service_status = "running" ]]; then
        # B.1. $nadeko_service_active = true when 'nadeko.service' is
        # active, and is used to indicate to the user that the service was
        # stopped and that they will need to start it
        nadeko_service_active="true"
        echo "Stopping 'nadeko.service'..."
        service_actions "stop_service"
    fi

    ############################################################################
    # Creating backups of current code in '/home/nadeko' then downloads/
    # updates Nadeko
    ############################################################################

    if [[ -d NadekoBot ]]; then
        echo "Backing up NadekoBot as 'NadekoBot.bak'..."
        mv -f NadekoBot NadekoBot.bak || {
            echo "${red}Failed to back up NadekoBot${nc}" >&2
            echo -e "\nPress [Enter] to return to the installer menu"
            clean_exit "1" "Returning to the installer menu"
        }
    fi

    echo "Downloading NadekoBot..."
    git clone -b 1.9 --recursive --depth 1 https://gitlab.com/Kwoth/NadekoBot || {
        echo "${red}Failed to download NadekoBot${nc}" >&2
        clean_up "true"
    }

    if [[ -d /tmp/NuGetScratch ]]; then
        echo "Modifying ownership of /tmp/NuGetScratch"
        sudo chown -R "$USER":"$USER" /tmp/NuGetScratch /home/$USER/.nuget || {
            echo "${red}Failed to to modify ownership of /tmp/NuGetScratch and/or" \
                "/home/$USER/.nuget" >&2
            echo "${cyan}You can ignore this if you are not prompted about" \
                "locked files/permission error while attempting to download" \
                "dependencies${nc}"
        }
    fi

    echo "Downloading Nadeko dependencies..."
    cd NadekoBot || {
        echo "${red}Failed to change working directory${nc}" >&2
        clean_up "true"
    }
    dotnet restore || {
        echo "${red}Failed to download dependencies${nc}" >&2
        clean_up "true"
    }

    echo "Building NadekoBot..."
    dotnet build --configuration Release || {
        echo "${red}Failed to build NadekoBot${nc}" >&2
        clean_up "true"
    }
    cd $root_dir || {
        echo "${red}Failed to return to the project root directory${nc}" >&2
        # TODO: Provide instructions on what to do instead of erasing progress
        clean_up "true"
    }

    # TODO: Find a way to make this smaller
    if [[ -d NadekoBot.old && -d NadekoBot.bak || ! -d NadekoBot.old && -d \
            NadekoBot.bak ]]; then
        echo "Copping 'credentials.json' to new version..."
        cp -f NadekoBot.bak/src/NadekoBot/credentials.json \
            NadekoBot/src/NadekoBot/credentials.json &>/dev/null
        echo "Copping database to the new version"
        cp -RT NadekoBot.bak/src/NadekoBot/bin/ NadekoBot/src/NadekoBot/bin/ &>/dev/null
        cp -RT NadekoBot/src/NadekoBot/bin/Release/netcoreapp1.0/data/NadekoBot.db NadekoBot/src/NadekoBot/bin/Release/netcoreapp2.1/data/NadekoBot.db &>/dev/null
        cp -RT NadekoBot/src/NadekoBot/bin/Release/netcoreapp1.1/data/NadekoBot.db NadekoBot/src/NadekoBot/bin/Release/netcoreapp2.1/data/NadekoBot.db &>/dev/null
        cp -RT NadekoBot/src/NadekoBot/bin/Release/netcoreapp2.0/data/NadekoBot.db NadekoBot/src/NadekoBot/bin/Release/netcoreapp2.1/data/NadekoBot.db &>/dev/null
        mv -f NadekoBot/src/NadekoBot/bin/Release/netcoreapp1.0/data/NadekoBot.db NadekoBot/src/NadekoBot/bin/Release/netcoreapp1.0/data/NadekoBot_old.db &>/dev/null
        mv -f NadekoBot/src/NadekoBot/bin/Release/netcoreapp1.1/data/NadekoBot.db NadekoBot/src/NadekoBot/bin/Release/netcoreapp1.1/data/NadekoBot_old.db &>/dev/null
        mv -f NadekoBot/src/NadekoBot/bin/Release/netcoreapp2.0/data/NadekoBot.db NadekoBot/src/NadekoBot/bin/Release/netcoreapp2.0/data/NadekoBot_old.db &>/dev/null
        echo "Copping other data to the new version..."
        cp -RT NadekoBot_old/src/NadekoBot/data/ NadekoBot/src/NadekoBot/data/ &>/dev/null
        # TODO: Add error handling???
        rm -rf NadekoBot.old && mv -f NadekoBot.bak NadekoBot.old
    fi

    if [[ -f $nadeko_service ]]; then
        echo "Updating 'nadeko.service'..."
        create_or_update="update"
    else
        echo "Creating 'nadeko.service'..."
        create_or_update="create"
    fi

    echo -e "$nadeko_service_content" | sudo tee "$nadeko_service" >/dev/null || {
        echo "${red}Failed to $create_or_update 'nadeko.service'${nc}" >&2
        b_s_update="Failed"
    }

    ############################################################################
    # Cleaning up and presenting results...
    ############################################################################
    echo -e "\n${green}Finished downloading/updating Nadeko${nc}"

    if [[ $b_s_update ]]; then
        echo "${yellow}WARNING: Failed to $create_or_update 'nadeko.service'${nc}"
    fi

    # B.1.
    if [[ $nadeko_service_active ]]; then
        echo "${cyan}NOTE: 'nadeko.service' was stopped to update" \
            "Nadeko and has to be started using the run modes in the" \
            "installer menu${nc}"
    fi

    read -p "Press [Enter] to apply any existing changes to the installers"
