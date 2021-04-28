#!/bin/bash
#
# This script looks at the operating system, architecture, bit type, etc., to
# determine whether or not the system is supported by NadekoBot. Once the system
# is deemed as supported, the master installer will be downloaded and executed.
#
# Note: All variables not defined in this script, are exported from
# 'linuxAIO.sh'.
# 
########################################################################################
#### [ Exported and/or Globally Used Variables ]


# Used to keep track of changes to 'linuxAIO.sh'.
# Refer to the '[ Prepping ]' section of this script for more information.
current_linuxAIO_revision="9"

export yellow=$'\033[1;33m'
export green=$'\033[0;32m'
export cyan=$'\033[0;36m'
export red=$'\033[1;31m'
export nc=$'\033[0m'
export clrln=$'\r\033[K'
export grey=$'\033[0;90m'
export installer_prep_pid=$$

# The '--no-hostname' flag for journalctl only works with systemd 230 and later.
if (($(journalctl --version | grep -oP "[0-9]+" | head -1) >= 230)) 2>/dev/null; then
    export no_hostname="--no-hostname"
fi


#### End of [ Exported and/or Globally Used Variables ]
########################################################################################
#### [ Error Traps ]


clean_exit() {
    ####
    # FUNCTION INFO:
    #
    # Cleanly exit the installer by removing files that aren't required unless
    # the installer is currently being run.
    #
    # @param $1 Exit status code.
    # @param $2 Output text.
    # @param $3 Determines if 'Cleaning up...' needs to be printed with a
    #           new-line symbol.
    ####

    # Files to be removed.
    local installer_files=("credentials_setup.sh" "installer_prep.sh"
        "prereqs_installer.sh" "nadeko_latest_installer.sh"
        "nadeko_master_installer.sh")

    if [[ $3 = true ]]; then
        echo "Cleaning up..."
    else
        echo -e "\nCleaning up..."
    fi

    ## Removes files specified in 'installer_files'.
    for file in "${installer_files[@]}"; do
        if [[ -f $file ]]; then rm "$file"; fi
    done

    echo "$2..."
    exit "$1"
}

# Executes when the user uses 'Ctrl + Z' or 'Ctrl + C'.
trap 'echo -e "\n\nScript forcefully stopped"
    clean_exit "1" "Exiting" "true"' \
    SIGINT SIGTSTP SIGTERM


#### End of [ Error Traps ]
########################################################################################
#### [ Prepping ]


## Downloads latest version of 'linuxAIO.sh' if $linuxAIO_revision and 
## $current_linuxAIO_revision aren't of equal value.
if [[ $linuxAIO_revision != "$current_linuxAIO_revision" ]]; then
    ####
    # MORE INFO:
    #
    # Since 'linuxAIO.sh' remains on the user's system, any changes to the code
    # that are pushed to github are never applied. whenever this
    # $linuxAIO_revision and $current_linuxAIO_revision do not match, the newest
    # version of 'linuxAIO.sh' is retrieved from github.
    ####

    # Save the value of 'installer_branch' specified in 'linuxAIO.sh', to be set
    # in the new 'linuxAIO.sh'.
    installer_branch=$(grep 'export installer_branch=' linuxAIO.sh | awk -F '"' '{print $2}');

    echo "$yellow'linuxAIO.sh' is not up to date$nc"
    echo "Downloading latest 'linuxAIO.sh'..."
    curl "$raw_url"/linuxAIO.sh -o linuxAIO.sh || {
        echo "${red}Failed to download latest 'linuxAIO.sh'...$nc" >&2
        clean_exit "1" "Exiting" "true"
    }

    echo "Applying set configurations to 'linuxAIO.sh'..."
    sed -i "s/export installer_branch=.*/export installer_branch=\"$installer_branch\"/" linuxAIO.sh
    sudo chmod +x linuxAIO.sh  # Set execution permission
    echo "${cyan}Re-execute 'linuxAIO.sh' to continue$nc"
    # TODO: Figure out a way to get exec to work, instead of exiting script
    clean_exit "0" "Exiting" "true"
fi

# Change the working directory to the location of the executed scrpt.
cd "$(dirname "$0")" || {
    echo "${red}Failed to change working directory" >&2
    echo "${cyan}Change your working directory to that of the executed" \
        "script$nc"
    clean_exit "1" "Exiting" "true"
}

export working_dir="$PWD"
export installer_prep="$working_dir/installer_prep.sh"


#### End of [ Prepping ]
########################################################################################
#### [ Functions ]


detect_sys_info() {
    ####
    # FUNCTION INFO:
    #
    # Identify the operating system, version number, architecture, bit type (32
    # or 64), etc.
    ####

    ## For Linux
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        distro="$ID"
        ver="$VERSION_ID"  # Version: x.x.x...
        sver=${ver//.*/}   # Version: x
        pname="$PRETTY_NAME"
        codename="$VERSION_CODENAME"
    ## For macOS
    else
        distro=$(uname -s)
        if [[ $distro = "Darwin" ]]; then
            ver=$(sw_vers -productVersion)  # macOS version: x.x.x
            sver=${ver%.*}                  # macOS version: x.x
            pname="macOS"
        else
            ver=$(uname -r)
        fi
    fi

    ## Identify bit and architecture type.
    case $(uname -m) in
        x86_64) bits="64"; arch="x64" ;;
        i*86)   bits="32"; arch="x86" ;;
        armv*)  bits="32"; arch="?" ;;
        *)      bits="?";  arch="?" ;;
    esac
}

execute_master_installer() {
    ####
    # FUNCTION INFO:
    #
    # Download and execute 'nadeko_master_installer.sh'.
    ####

    supported=true

    curl -s "$raw_url"/nadeko_master_installer.sh -o nadeko_master_installer.sh || {
        echo "${red}Failed to download 'nadeko_master_installer.sh'$nc" >&2
        clean_exit "1" "Exiting" "true"
    }
    sudo chmod +x nadeko_master_installer.sh && ./nadeko_master_installer.sh || {
        echo "${red}Failed to execute 'nadeko_master_installer.sh'$nc" >&2
        clean_exit "1" "Exiting" "true"
    }
}


#### End of [ Functions ]
########################################################################################
#### [ Main ]


clear -x

detect_sys_info
export distro sver ver arch bits codename
export -f clean_exit

echo "SYSTEM INFO"
echo "Bit Type: $bits"
echo "Architecture: $arch"
printf "Distro: "
# Use $distro if $pname is empty.
if [[ -n $pname ]]; then echo "$pname"; else echo "$distro"; fi
echo "Distro Version: $ver"
echo ""

## Checks if Nadeko and installer are compatible with the operating system.
if [[ $distro = "ubuntu" ]]; then
    if [[ $bits = 64 ]]; then  # A.1. Forcing 64 bit architecture
        case "$ver" in
            16.04) execute_master_installer ;;
            18.04) execute_master_installer ;;
            20.04) execute_master_installer ;;
            *)     supported=false ;;
        esac
    else
        supported=false
    fi
elif [[ $distro = "debian" ]]; then
    if [[ $bits = 64 ]]; then  # A.1.
        case "$sver" in
            9)  execute_master_installer ;;
            10) execute_master_installer ;;
            *)  supported=false ;;
        esac
    else
        supported=false
    fi
elif [[ $distro = "linuxmint" ]]; then
    if [[ $bits = 64 ]]; then  # A.1.
        case "$sver" in
            18) execute_master_installer ;;
            19) execute_master_installer ;;
            20) execute_master_installer ;;
            *)  supported=false ;;
        esac
    else
        supported=false
    fi
elif [[ $distro = "Darwin" ]]; then
    case "$sver" in
        10.14) execute_master_installer ;;
        10.15) execute_master_installer ;;
        11.0)  execute_master_installer ;;
        *)     supported=false ;;
    esac
else
    supported=false
fi

## Provides the user with the option to continue, even if their system isn't officially
## supported.
if [[ $supported = false ]]; then
    echo "${red}Your operating system/Linux Distribution is not OFFICIALLY supported" \
        "the installation, setup, and/or use of NadekoBot$nc" >&2
    read -rp "Would you like to continue with the installation anyways? [y/N] " choice
    choice=$(echo "$choice" | tr '[A-Z]' '[a-z]')  # Convert user input to lowercase.
    case "$choice" in
        y|yes) clear -x; execute_master_installer ;;
        n|no)  clean_exit "0" "Exiting" ;;
        *)     clean_exit "0" "Exiting" ;;
    esac
fi


#### End of [ Main ]
########################################################################################
