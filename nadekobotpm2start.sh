#!/bin/sh

read -p "We will now start Nadeko with pm2. Press [Enter] to continue."

echo "1. Run in pm2 with Auto Restart normally without Auto Update."
echo "2. Run in pm2 with Auto Restart and Auto Update."
echo "3. Run NadekoBot in pm2 normally without Auto Restart or Auto Update."
echo "4. Exit"
echo -n "Choose [1] to Run NadekoBot in pm2 with auto restart on "die" command without updating itself, [2] to Run in pm2 with Auto Updating on restart after using "die" command, and [3] to run without any auto-restarts or auto-updates."

read choice
case "$choice" in
	1)
		echo ""
		wget -N https://github.com/Kwoth/NadekoBot-BashScript/raw/1.9/NadekoARN.sh 
		echo "Starting Nadeko in pm2 with auto-restart and no auto-update..."
		pm2 start NadekoARN.sh --interpreter=bash --name=Nadeko --user="$USER"
		sudo chown -R "$USER":"$USER" "$HOME"/.pm2
		pm2 startup
		pm2 save
		echo ""
		echo "If you did everything correctly, pm2 should have started up Nadeko! Please use pm2 info Nadeko to check. You can view pm2 logs with pm2 logs Nadeko"
		;;
	2)
		echo ""
		wget -N https://github.com/Kwoth/NadekoBot-BashScript/raw/1.9/NadekoARU_Latest.sh 
		echo "Starting Nadeko in pm2 with auto-restart and auto-update..."
		pm2 start NadekoARU_Latest.sh --interpreter=bash --name=Nadeko --user="$USER"
		sudo chown -R "$USER":"$USER" "$HOME"/.pm2
		pm2 startup
		pm2 save
		echo ""
		echo "If you did everything correctly, pm2 should have started up Nadeko! Please use pm2 info Nadeko to check. You can view pm2 logs with pm2 logs Nadeko"
		;;
	3)
		echo ""
		wget -N https://github.com/Kwoth/NadekoBot-BashScript/raw/1.9/nadeko_run.sh
		echo "Starting Nadeko in pm2 normally without any auto update or restart.."
		pm2 start nadeko_run.sh --interpreter=bash --name=Nadeko --user="$USER"
		sudo chown -R "$USER":"$USER" "$HOME"/.pm2
		pm2 startup
		pm2 save
		echo ""
		echo "If you did everything correctly, pm2 should have started up Nadeko! Please use pm2 info Nadeko to check. You can view pm2 logs with pm2 logs Nadeko"
		;;
	4)
		echo ""
		echo "Exiting..."
		exit 0
		;;
	*)
		clear
		echo "1. Run in pm2 with Auto Restart normally without updating NadekoBot."
		echo "2. Run in pm2 with Auto Restart and update NadekoBot."
		echo "3. Run NadekoBot in pm2 normally without Auto Restart."
		echo "4. Exit"
		echo -n "Choose [1] to Run NadekoBot in pm2 with auto restart on die command without updating itself, [2] to Run in pm2 with Auto Updating on restart after using die command, and [3] to run without any auto restarts or auto-updates."
		;;
esac

