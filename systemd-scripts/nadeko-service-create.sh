#!/bin/bash
botRoot="$(dirname "$(realpath "$0")")"
cd "$botRoot"
srvFile=nadeko.service
updFile=nadeko-update.service
timFile=nadeko-update.timer

echo This script will generate and install systemd user service units for the
echo bot itself the update script to run automatically.

echo Generating $srvFile
echo "[Unit]" > $srvFile
echo "Description=NadekoBot Update Service" >> $srvFile
echo  >> $srvFile
echo "[Service]" >> $srvFile
echo "Type=simple" >> $srvFile
echo "ExecStart=$botRoot/nadeko.sh" >> $srvFile
echo "WorkingDirectory=$botRoot" >> $srvFile
echo "StandardOutput=file:$botRoot/nadeko.log" >> $srvFile
echo "StandardError=file:$botRoot/nadeko.log" >> $srvFile
echo  >> $srvFile
echo "[Install]" >> $srvFile
echo "WantedBy=multi-user.target" >> $srvFile

echo Generating $updFile
echo "[Unit]" > $updFile
echo "Description=NadekoBot Update Service" >> $updFile
echo  >> $updFile
echo "[Service]" >> $updFile
echo "Type=simple" >> $updFile
echo "ExecStart=$botRoot/nadeko-update.sh" >> $updFile
echo "WorkingDirectory=$botRoot" >> $updFile
echo "StandardOutput=file:$botRoot/nadeko-update.log" >> $updFile
echo "StandardError=file:$botRoot/nadeko-update.log" >> $updFile
echo  >> $updFile
echo "[Install]" >> $srvFile
echo "WantedBy=multi-user.target" >> $srvFile

echo Generating $timFile
echo "[Unit]" > $timFile
echo "Description=NadekoBot Update Service" >> $timFile
echo >> $timFile
echo "[Timer]" >> $timFile
echo "OnCalendar=*-*-* 03:30:00" >> $timFile
echo "Persistent=True" >> $timFile
echo >> $timFile
echo "[Install]" >> $timFile
echo "WantedBy=timers.target" >> $timFile

echo Installing service units.
cp $srvFile $HOME/.config/systemd/user/$srvFile
cp $updFile $HOME/.config/systemd/user/$updFile
cp $timFile $HOME/.config/systemd/user/$timFile

exit 0
echo Enabling services.
/bin/systemctl --user enable nadeko.service
/bin/systemctl --user enable nadeko-update.timer
/bin/systemctl --user start nadeko.service

echo Service units should not be installed and the bot should be running.
echo To stop the bot type: systemctl --user stop nadeko
echo To start/restart the bot replace stop with the appropriate command.
echo
echo The update timer will execute daily at 3:30am. 