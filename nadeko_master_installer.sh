#!/bin/sh

echo "Welcome to NadekoBot."
root=$(pwd)
echo ""
choice=10
	echo "1. Download NadekoBot"
	echo "2. Run Nadeko (Normally)"
	echo "3. Run Nadeko with Auto Restart in this session"
	echo "4. Auto-Install Prerequisites (For Ubuntu, Debian and CentOS)"
	echo "5. Set up credentials.json (If you have downloaded NadekoBot already)"
	echo "6. Auto-Install pm2 (For pm2 information, see README!)"
	echo "7. Start Nadeko in pm2 (Complete option 6 first!)"
	echo "8. Start Nadeko as a service (Experimental)"
	echo "9. Exit"
	echo -n "Choose [1] to Download, [2 or 3] to Run, [6 and 7] for pm2 setup/startup (see README) or [9] to Exit."
while [ $choice -eq 10 ]; do
read choice
if [ $choice -eq 1 ] ; then

	echo ""
	echo "Downloading NadekoBot, please wait."
	wget -N https://github.com/Kwoth/NadekoBot-BashScript/raw/1.9/nadeko_installer_latest.sh && bash "$root/nadeko_installer_latest.sh"
	echo ""
	bash "$root/linuxAIO.sh"
else
		if [ $choice -eq 2 ] ; then
			echo ""
			echo "Running Nadeko Normally, if you are running this to check Nadeko, use .die command on discord to stop Nadeko."
			wget -N https://github.com/Kwoth/NadekoBot-BashScript/raw/1.9/nadeko_run.sh && bash "$root/nadeko_run.sh"
			echo ""
			echo "Welcome back to NadekoBot."
			sleep 2s
			bash "$root/linuxAIO.sh"
		else
			if [ $choice -eq 3 ] ; then
				echo ""
				echo "Running Nadeko with Auto Restart you will have to close the session to stop the auto restart."
				sleep 5s
				wget -N https://github.com/Kwoth/NadekoBot-BashScript/raw/1.9/NadekoAutoRestartAndUpdate.sh && bash "$root/NadekoAutoRestartAndUpdate.sh"
				echo ""
				echo "That did not work?"
				sleep 2s
				bash "$root/linuxAIO.sh"
			else
				if [ $choice -eq 4 ] ; then
					echo ""
					echo "Getting the Auto-Installer for Debian/Ubuntu"
					wget -N https://github.com/Kwoth/NadekoBot-BashScript/raw/1.9/nadekoautoinstaller.sh && bash "$root/nadekoautoinstaller.sh"
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

echo Please enter Cleverbot Api Key or Just Press [Enter Key] to skip. \(optional\) \(Refer to the JSON Explanations guide.\):
read cleverbot
echo Alright saved \'$cleverbot\'
echo ""
echo "----------"
echo ""

echo "{
  \"ClientId\": $clientid,
  \"Token\": \"$token\",
  \"OwnerIds\": [
    $ownerid
  ],
  \"LoLApiKey\": \"$lolapikey\",
  \"GoogleApiKey\": \"$googleapi\",
  \"MashapeKey\": \"$mashapekey\",
  \"OsuApiKey\": \"$osu\",
  \"CleverbotApiKey\": \"$cleverbot\",
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
						echo "Starting the setup for pm2 with NadekoBot. This only has to be done once."
						wget -N https://github.com/Kwoth/NadekoBot-BashScript/raw/1.9/nadekopm2setup.sh && bash "$root/nadekopm2setup.sh"
						echo ""
						echo "Welcome back..."
						sleep 2s
						bash "$root/linuxAIO.sh"	
						else
							if [ $choice -eq 7 ] ; then
							echo ""
							echo "Getting the pm2 startup options for NadekoBot..."
							wget -N https://github.com/Kwoth/NadekoBot-BashScript/raw/1.9/nadekobotpm2start.sh && bash "$root/nadekobotpm2start.sh"
							echo ""
							sleep 2s
							bash "$root/linuxAIO.sh"
							else
								if [ $choice -eq 8 ] ; then
									echo ""
									echo "Setting up NadekoBot as a service..."
									wget -N https://github.com/MaybeGoogle/NadekoFiles/raw/master/Install%20Scripts/NadekoService.sh && bash "$root/NadekoService.sh"
									echo ""
									sleep 2s
									bash "$root/linuxAIO.sh"
								else
									if [ $choice -eq 9 ] ; then
										echo ""
										echo "Exiting..."
										cd "$root"
										exit 0
									else
										clear
										echo "1. Download NadekoBot"
										echo "2. Run Nadeko (Normally)"
										echo "3. Run Nadeko with Auto Restart in this session"
										echo "4. Auto-Install Prerequisites (For Ubuntu, Debian and CentOS)"
										echo "6. Auto-Install pm2 (For pm2 information, see README!)"
										echo "7. Start Nadeko in pm2 (Complete option 6 first!)"
										echo "8. Start Nadeko as a service (Experimental)"
										echo "9. Exit"
										echo -n "Choose [1] to Download, [2 or 3] to Run, [6 and 7] for pm2 setup/startup (see README) or [9] to Exit."
										choice=10
									fi
								fi
							fi	
						fi 
					fi
				fi
			fi
		fi
	fi
done

cd "$root"
exit 0
