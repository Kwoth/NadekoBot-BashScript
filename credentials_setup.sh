#!/bin/bash
#
# Sets up crendtials.json
#
# Note: All variables not defined in this script, are exported from
# 'linuxPMI.sh', 'installer_prep.sh', and 'nadeko_master_installer.sh'.
#
################################################################################

read -rp "We will now create a new 'credentials.json'. Press [Enter] to continue."

echo -e "\n-------------"
echo "${cyan}This field is required and cannot be left blank"
echo "Field 1 of 9$nc"
while true; do
    read -rp "Enter your bot token (it is not bot secret, it should be ~59 characters long): " token
    if [[ -n $token ]]; then break; fi
done
echo "Bot token: $token"
echo "-------------"

echo -e "\n-------------"
echo "${cyan}This field is required and cannot be left blank"
echo "Field 2 of 9$nc"
while true; do
    read -rp "Enter your own ID: " ownerid
    if [[ -n $ownerid ]]; then break; fi
done
echo "Owner ID: $ownerid"
echo "-------------"

echo -e "\n-------------"
echo "${cyan}Field 3 of 9$nc"
read -rp "Enter your Google API Key: " googleapi
echo "Google API Key: $googleapi"
echo "-------------"

echo -e "\n-------------"
echo "${cyan}Field 4 of 9$nc"
read -rp "Enter your Mashape Key: " mashapekey
echo "Mashape Key: $mashapekey"
echo "-------------"

echo -e "\n-------------"
echo "${cyan}Field 5 of 9$nc"
read -rp "Enter your OSU API Key: " osu
echo "OSU API Key: $osu"
echo "-------------"

echo -e "\n-------------"
echo "${cyan}Field 6 of 9$nc"
read -rp "Enter your Cleverbot API Key: " cleverbot
echo "Cleverbot API Key: $cleverbot"
echo "-------------"

echo -e "\n-------------"
echo "${cyan}Field 7 of 9$nc"
read -rp "Enter your Twitch Client ID: " twitchcid
echo "Twitch Client ID: $twitchcid"
echo "-------------"

echo -e "\n-------------"
echo "${cyan}Field 8 of 9$nc"
read -rp "Enter your Location IQ API Key: " locationiqapi
echo "Location IQ API Key: $locationiqapi"
echo "-------------"

echo -e "\n-------------"
echo "${cyan}Field 9 of 9$nc"
read -rp "Enter your Timezone DB API Key: " timedbapi
echo "Timezone DB API Key: $timedbapi"
echo -e "-------------\n"

if [[ -f NadekoBot/src/NadekoBot/credentials.json ]]; then
    echo "Backing up current 'credentials.json'..."
    mv NadekoBot/src/NadekoBot/credentials.json NadekoBot/src/NadekoBot/credentials.json.bak
    echo "Creating new 'credentials.json'..."
else
    echo "Creating 'credentials.json'..."
    touch NadekoBot/src/NadekoBot/credentials.json
    sudo chmod +x NadekoBot/src/NadekoBot/credentials.json
fi

echo -e "{ \
    \n    \"Token\": \"$token\", \
    \n    \"OwnerIds\": [ \
    \n        $ownerid \
    \n    ], \
    \n    \"GoogleApiKey\": \"$googleapi\", \
    \n    \"MashapeKey\": \"$mashapekey\", \
    \n    \"OsuApiKey\": \"$osu\", \
    \n    \"CleverbotApiKey\": \"$cleverbot\", \
    \n    \"TwitchClientId\": \"$twitchcid\", \
    \n    \"LocationIqApiKey\": \"$locationiqapi\", \
    \n    \"TimezoneDbApiKey\": \"$timedbapi\", \
    \n    \"Db\": null, \
    \n    \"TotalShards\": 1 \
    \n}" > NadekoBot/src/NadekoBot/credentials.json

echo -e "\n${green}Finished creating 'credentials.json'$nc"
read -rp "Press [Enter] to return the the installer menu"
