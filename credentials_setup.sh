#!/bin/bash

################################################################################
#
# Sets up crendtials.json
#
# Note: All variables not defined in this script, are exported from
# 'linuxPMI.sh', 'installer-prep.sh', and 'linux-master-installer.sh'
#
################################################################################
#
    read -p "We will now create a new credentials.json. Press [Enter] to continue."

    echo -e "\n-------------"
    echo "${cyan}This field is required and cannot be left blank${nc}"
    while true; do
        read -p "Enter your bot token (it is not bot secret, it should be ~59 characters long): " token
        if [[ -n $token ]]; then break; fi
    done
    echo "Bot token: $token"
    echo "-------------"

    echo -e "\n-------------"
    echo "${cyan}This field is required and cannot be left blank${nc}"
    while true; do
        read -p "Enter your own ID: " ownerid
        if [[ -n $ownerid ]]; then break; fi
    done
    echo "Owner ID: $ownerid"
    echo "-------------"

    echo -e "\n-------------"
    read -p "Enter your Google API key: " googleapi
    echo "Google API Key: $googleapi"
    echo "-------------"

    echo -e "\n-------------"
    read -p "Enter your Mashape Key: " mashapekey
    echo "Mashape Key: $mashapekey"
    echo "-------------"

    echo -e "\n-------------"
    read -p "Enter your OSU API Key: " osu
    echo "OSU API Key: $osu"
    echo "-------------"

    echo -e "\n-------------"
    read -p "Enter your Cleverbot API Key: " cleverbot
    echo "Cleverbot API Key: $cleverbot"
    echo "-------------"

    echo -e "\n-------------"
    read -p "Enter your Twitch Client ID: " twitchcid
    echo "Twitch Client ID: $twitchcid"
    echo "-------------"

    echo -e "\n-------------"
    read -p "Enter your Location IQ API Key: " locationiqapi
    echo "Location IQ API Key: $locationiqapi"
    echo "-------------"

    echo -e "\n-------------"
    read -p "Enter your Timezone DB API Key: " timedbapi
    echo "Timezone DB API Key: $timedbapi"
    echo "-------------"

    if [[ -f NadekoBot/src/NadekoBot/credentials.json ]]; then
        echo "Backing up current 'credentials.json'..."
        mv NadekoBot/src/NadekoBot/credentials.json NadekoBot/src/NadekoBot/credentials.json.bak
        echo "Updating 'credentials.json'..."
    else
        echo "Creating 'credentials.json'..."
        touch NadekoBot/src/NadekoBot/credentials.json
        sudo chmod +x NadekoBot/src/NadekoBot/credentials.json
    fi
    echo "{
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
    \"TotalShards\": 1
    }" > NadekoBot/src/NadekoBot/credentials.json

    echo -e "\n${green}Finished creating 'credentials.json'${nc}"
    read -p "Press [Enter] to return the the installer menu"
