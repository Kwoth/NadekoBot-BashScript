#!/bin/bash
#
# linuxAIO acts as the intermediary between the system NadekoBot is being hosted on and
# the 'installer_prep.sh'. To prevent any conflicts with updates to the installer, this
# script has as little code as deemed necessary.
#
########################################################################################
#### [ Development Variables ]
#### The variables below are for dev/testing purpouses (!!! DO NOT MODIFY !!!).


# Used to keep track of changes to 'linuxAIO.sh'.
# Refer to the '[ Prepping ]' section of 'installer_prep.sh' for more information.
export linuxAIO_revision="9"
# Determines which repository from what user is used by the installer.
installer_repo="StrangeRanger/NadekoBot-BashScript"


#### End of [ Development Variables ]
########################################################################################
#### [ Configuration Variables ]
#### The variables below are used to modify some of the actions of the installer and CAN
#### BE modified by the end user.


# Determines from which branch the installer will use.
# master = The latest stable code
# dev    = Non-production ready code (may break your system)
#
# Default: master
installer_branch="testing"

# Determines whether or not the installer can be run as the root user:
# true  = can be run with root privilege
# false = cannot be run with root privilege (recommended)
#
# Default: false
allow_run_as_root=false


#### End of [ Configuration Variables ]
########################################################################################
#### [ Variables ]
#### Variables that aren't Development or Configurable specific.


export raw_url="https://raw.githubusercontent.com/$installer_repo/$installer_branch"


#### End of [ Variables ]
########################################################################################
#### [ Main ]


# If executed with root privilege and $allow_run_as_root is false...
if [[ $EUID = 0 ]] && [[ $allow_run_as_root = false ]]; then
    echo "\033[1;31mPlease run this script without root privilege" >&2
    echo "\033[0;36mWhile you will be performing specific tasks with root" \
        "privilege, running the installer in it's entirety as root is not" \
        "recommended\033[0m"
    echo -e "\nExiting..."
    exit 1
fi

echo "Downloading the latest installer..."
curl "$raw_url"/installer_prep.sh -o installer_prep.sh || {
    echo "Failed to download 'installer_prep.sh'" >&2
    echo -e "\nExiting..."
    exit 1
}
sudo chmod +x installer_prep.sh && ./installer_prep.sh


#### End of [ Main ]
########################################################################################
