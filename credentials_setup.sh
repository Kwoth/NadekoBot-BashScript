#!/bin/bash
#
# Sets up crendtials.json
#
# Note: All variables not defined in this script, are exported from
# 'linuxPMI.sh', 'installer_prep.sh', and 'nadeko_master_installer.sh'.
#
# TODO: I'll be making some more in depth changes to this file in the future.
#
################################################################################
#### [ Variables ]


credentials="NadekoBot/src/NadekoBot/credentials.json"
bak_credentials="NadekoBot/src/NadekoBot/credentials.json.bak"


#### End of [ Variables ]
########################################################################################
#### [ Main ]


read -rp "We will now create a new 'credentials.json'. Press [Enter] to continue."

echo -e "\n-------------"
echo "${_CYAN}This field is required and cannot be left blank"
echo "Field 1 of 9$_NC"
while true; do
    read -rp "Enter your bot token (it is not bot secret, it should be ~59 characters long): " token
    if [[ -n $token ]]; then break; fi
done
echo "Bot token: $token"
echo "-------------"

echo -e "\n-------------"
echo "${_CYAN}This field is required and cannot be left blank"
echo "Field 2 of 9$_NC"
while true; do
    read -rp "Enter your own ID: " ownerid
    if [[ -n $ownerid ]]; then break; fi
done
echo "Owner ID: $ownerid"
echo "-------------"

echo -e "\n-------------"
echo "${_CYAN}Field 3 of 9$_NC"
read -rp "Enter your Google API Key: " googleapi
echo "Google API Key: $googleapi"
echo "-------------"

echo -e "\n-------------"
echo "${_CYAN}Field 4 of 9$_NC"
read -rp "Enter your Mashape Key: " mashapekey
echo "Mashape Key: $mashapekey"
echo "-------------"

echo -e "\n-------------"
echo "${_CYAN}Field 5 of 9$_NC"
read -rp "Enter your OSU API Key: " osu
echo "OSU API Key: $osu"
echo "-------------"

echo -e "\n-------------"
echo "${_CYAN}Field 6 of 9$_NC"
read -rp "Enter your Cleverbot API Key: " cleverbot
echo "Cleverbot API Key: $cleverbot"
echo "-------------"

echo -e "\n-------------"
echo "${_CYAN}Field 7 of 9$_NC"
read -rp "Enter your Twitch Client ID: " twitchcid
echo "Twitch Client ID: $twitchcid"
echo "-------------"

echo -e "\n-------------"
echo "${_CYAN}Field 8 of 9$_NC"
read -rp "Enter your Location IQ API Key: " locationiqapi
echo "Location IQ API Key: $locationiqapi"
echo "-------------"

echo -e "\n-------------"
echo "${_CYAN}Field 9 of 9$_NC"
read -rp "Enter your Timezone DB API Key: " timedbapi
echo "Timezone DB API Key: $timedbapi"
echo -e "-------------\n"

## Back up credentials by renameing them to $bak_credentials.
if [[ -f $credentials ]]; then
    echo "Backing up current 'credentials.json' as 'credentials.json.bak'..."
    mv $credentials $bak_credentials
    echo "Creating new 'credentials.json'..."
## Create a new 'credentials.json' file.
else
    echo "Creating 'credentials.json'..."
    touch $credentials
    sudo chmod +x $credentials
fi

echo -e "{
    \"Token\": \"$token\",
    \"OwnerIds\": [
        $ownerid
    ],
    \"GoogleApiKey\": \"$googleapi\",
    \"MashapeKey\": \"$mashapekey\",
    \"OsuApiKey\": \"$osu\",
    \"CleverbotApiKey\": \"$cleverbot\",
    \"TwitchClientId\": \"$twitchcid\",
    \"LocationIqApiKey\": \"$locationiqapi\",
    \"TimezoneDbApiKey\": \"$timedbapi\",
    \"Db\": null,
    \"TotalShards\": 1 \
}" > $credentials

echo -e "\n${_GREEN}Finished creating 'credentials.json'$_NC"
read -rp "Press [Enter] to return the the installer menu"


#### End of [ Main ]
########################################################################################
