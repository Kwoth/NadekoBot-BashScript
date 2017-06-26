#!/bin/sh

# Valid Parms
# autorestart - Auto Restart only
# autorestartupdate - Auto Restart and Update
parms="$2"

start() {
	if [ $parms = "autorestart" ] ; then
		curl -L https://github.com/Kwoth/NadekoBot-BashScript/raw/1.4/NadekoARN.sh | sh
	else
		if [ $parms = "autorestartupdate" ] ; then
			curl -L https://github.com/Kwoth/NadekoBot-BashScript/raw/1.4/NadekoARU_Latest.sh | sh
		else
			echo ""
			echo "Failed to start..."
			echo "You must use one of the parms below..."
			echo "autorestart - Auto Restart only"
			echo "autorestartupdate - Auto Restart and Update"
			echo ""
		fi
	fi
}

stop() {
	tmux kill-session -t nadeko
}

reload () {
	tmux kill-session -t nadeko
	
	if [ $parms = "autorestart" ] ; then
		curl -L https://github.com/Kwoth/NadekoBot-BashScript/raw/1.4/NadekoARN.sh | sh
	else
		if [ $parms = "autorestartupdate" ] ; then
			curl -L https://github.com/Kwoth/NadekoBot-BashScript/raw/1.4/NadekoARU_Latest.sh | sh
		else
			echo ""
			echo "Failed to start..."
			echo "You must use one of the parms below..."
			echo "autorestart - Auto Restart only"
			echo "autorestartupdate - Auto Restart and Update"
			echo ""
		fi
	fi
}

case $1 in
	start|stop|reload) "$1" ;;
esac
