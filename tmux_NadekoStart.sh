
#!/bin/sh
echo ""
echo "NadekoBot tmux start script"
echo "Made by Main Fighter"
echo ""

choice=4
        echo "1. Auto Restart and no update."
        echo "2. Auto Restart update."
        echo "3. Exit."
        echo ""
        echo -n "What do you want to do? "
while [ $choice -eq 4 ] ; do
read choice
if [ $choice -eq 1 ] ; then
        echo ""
        echo "Starting Nadeko with Auto Restart..."
		sleep 1
		curl https://raw.githubusercontent.com/MainFighter/NadekoBot-BashScript/1.4/tmux_NadekoAutoRestart.sh -o tmux_NadekoAutoRestart.sh
		bash tmux_NadekoAutoRestart.sh
else
        if [ $choice -eq 2 ] ; then
                echo ""
                echo "Starting Nadeko with Auto Restart and Update..."
				sleep 1
                curl https://raw.githubusercontent.com/MainFighter/NadekoBot-BashScript/1.4/tmux_NadekoAutoRestartAndUpdate.sh -o tmux_NadekoAutoRestartAndUpdate.sh
				bash tmux_NadekoAutoRestartAndUpdate.sh
                echo ""
        else
                if [ $choice -eq 3 ] ; then
                        echo ""
                        echo "Exiting..."
                        echo ""
						sleep 1
                        exit 0
                fi
        fi
fi
done

exit 0
