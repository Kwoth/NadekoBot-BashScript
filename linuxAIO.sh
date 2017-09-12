#!/bin/sh

echo "Welcome to NadekoBot."
root=$(pwd)
echo ""
choice=7
	echo "1. Download NadekoBot"
	echo "2. Run Nadeko (Normally)"
	echo "3. Run Nadeko with Auto Restart"
	echo "4. Auto-Install Prerequisites (For Ubuntu, Debian and CentOS)"
	echo "5. Set up credentials.json (If you have downloaded NadekoBot already)"
	echo "6. Exit"
	echo -n "Choose [1] to Download, [2 or 3] to Run, or [6] to Exit"
while [ $choice -eq 7 ]; do
read choice
if [ $choice -eq 1 ] ; then

	echo ""
	echo "Downloading NadekoBot, please wait."
	wget -N https://github.com/Iratu/NadekoBot-BashScript/raw/1.4/nadeko_installer_latest.sh && bash "$root/nadeko_installer_latest.sh"
	echo ""
	bash "$root/linuxAIO.sh"
else
		if [ $choice -eq 2 ] ; then
			echo ""
			echo "Running Nadeko Normally, if you are running this to check Nadeko, use .die command on discord to stop Nadeko."
			wget -N https://github.com/Iratu/NadekoBot-BashScript/raw/1.4/nadeko_run.sh && bash "$root/nadeko_run.sh"
			echo ""
			echo "Welcome back to NadekoBot."
			sleep 2s
			bash "$root/linuxAIO.sh"
		else
			if [ $choice -eq 3 ] ; then
				echo ""
				echo "Running Nadeko with Auto Restart you will have to close the session to stop the auto restart."
				sleep 5s
				wget -N https://github.com/Iratu/NadekoBot-BashScript/raw/1.4/NadekoAutoRestartAndUpdate.sh && bash "$root/NadekoAutoRestartAndUpdate.sh"
				echo ""
				echo "That did not work?"
				sleep 2s
				bash "$root/linuxAIO.sh"
			else
				if [ $choice -eq 4 ] ; then
					echo ""
					echo "Getting the Auto-Installer for Debian/Ubuntu"
					wget -N https://github.com/Iratu/NadekoBot-BashScript/raw/1.4/nadekoautoinstaller.sh && bash "$root/nadekoautoinstaller.sh"
					echo ""
					echo "Welcome back..."
					sleep 2s
					bash "$root/linuxAIO.sh"
				else
					if [ $choice -eq 5 ] ; then
						echo ""
						echo
echo -e "Let's begin creating a new credentials.json file if you are about to run the NadekoBot for the first time. \n \nPlease read JSON Explanations in the guide... \n \nPress [Y] when you are ready to continue or [N] to exit."
while true; do
    read -p "[y/n]: " yn
    case $yn in
        [Yy]* ) clear; break;;
        [Nn]* ) echo Exiting...; exit;;
        * ) echo "Couldn't get that please type [y] for Yes or [n] for No.";;
    esac
done
clear
cd "$root/NadekoBot/src/NadekoBot"
mv credentials.json credentials.json.old

echo Please enter your bot client ID:
read clientid
echo Alright saved \'$clientid\' as your client ID.
echo ""
echo "----------"
echo ""

echo Please enter your bot ID \(should be same as your client ID\):
read botid
echo Alright saved \'$botid\' as your Bot ID.
echo ""
echo "----------"
echo ""

echo Please enter your bot token \(It is not bot secret, it should be ~59 characters long.\):
read token
echo Alright saved \'$token\' as your bot\'s token.
echo ""
echo "----------"
echo ""

echo Please enter your own ID \(Refer to the guide, it will be bot\'s owner ID.\):
read ownerid
echo Alright saved \'$ownerid\' as owner\'s ID.
echo ""
echo "----------"
echo ""

echo Please enter Google API key \(Refer to the guide.\):
read googleapi
echo Alright saved \'$googleapi\' as your bot\'s Google API Key.
echo ""
echo "----------"
echo ""

echo Please enter LoL API Key or Just Press [Enter Key] to skip. \(optional\) \(Refer to the JSON Explanations guide.\):
read lolapikey
echo Alright saved \'$lolapikey\'
echo ""
echo "----------"
echo ""

echo Please enter Mashape Key or Just Press [Enter Key] to skip. \(optional\) \(Refer to the JSON Explanations guide.\):
read mashapekey
echo Alright saved \'$mashapekey\'
echo ""
echo "----------"
echo ""

echo Please enter Osu API Key or Just Press [Enter Key] to skip. \(optional\) \(Refer to the JSON Explanations guide.\):
read osu
echo Alright saved \'$osu\'
echo ""
echo "----------"
echo ""

echo Please enter Patreon Access Token or Just Press [Enter Key] to skip. \(optional\) \(Refer to the JSON Explanations guide.\):
read scid
echo Alright saved \'$patreon\'
echo ""
echo "----------"
echo ""

echo "{
  \"ClientId\": $clientid,
  \"BotId\": $botid,
  \"Token\": \"$token\",
  \"OwnerIds\": [
    $ownerid
  ],
  \"LoLApiKey\": \"$lolapikey\",
  \"GoogleApiKey\": \"$googleapi\",
  \"MashapeKey\": \"$mashapekey\",
  \"OsuApiKey\": \"$osu\",
  \"PatreonAccessToken\": \"$patreon\",
  \"Db\": null,
  \"TotalShards\": 1
}" | cat - >> credentials.json
echo Credentials setup completed.
sleep 5
clear
cd "$root"
bash "$root/linuxAIO.sh"
					else
						if [ $choice -eq 6 ] ; then
							echo ""
							echo "Exiting..."
							cd "$root"
							exit 0
						else
							clear
							echo "1. Download NadekoBot"
							echo "2. Run Nadeko (Normally)"
							echo "3. Run Nadeko with Auto Restart"
							echo "4. Auto-Install Prerequisites (For Ubuntu, Debian and CentOS)"
							echo "5. Set up credentials.json (If you have downloaded NadekoBot already)"
							echo "6. Exit"
							echo -n "Choose [1] to Download, [2 or 3] to Run, or [6] to Exit."
							choice=7
						fi
					fi
				fi
			fi
		fi
	fi
done

cd "$root"
exit 0
