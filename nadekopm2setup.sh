#!/bin/bash -e
root=$(pwd)
echo ""

function detect_OS_ARCH_VER_BITS {
	ARCH=$(uname -m | sed 's/x86_//;s/i[3-6]86/32/')
	if [ -f /etc/lsb-release ]; then
	    . /etc/lsb-release
	    OS=$DISTRIB_ID
	    VER=$DISTRIB_RELEASE
	elif [ -f /etc/debian_version ]; then
	    OS=Debian  # XXX or Ubuntu??
	    VER=$(cat /etc/debian_version)
	    SVER=$( cat /etc/debian_version | grep -oP "[0-9]+" | head -1 )
	elif [ -f /etc/centos-release ]; then
		OS=CentOS
		VER=$( cat /etc/centos-release | grep -oP "[0-9]+" | head -1 )
	else
	    OS=$(uname -s)
	    VER=$(uname -r)
	fi
	case $(uname -m) in
	x86_64)
	    BITS=64
	    ;;
	i*86)
	    BITS=32
	    ;;
	armv*)
	    BITS=32
	    ;;
	*)
	    BITS=?
	    ;;
	esac
	case $(uname -m) in
	x86_64)
	    ARCH=x64  # or AMD64 or Intel64 or whatever
	    ;;
	i*86)
	    ARCH=x86  # or IA32 or Intel32 or whatever
	    ;;
	*)
	    # leave ARCH as-is
	    ;;
	esac
}

declare OS ARCH VER BITS

detect_OS_ARCH_VER_BITS

export OS ARCH VER BITS

if [ "$BITS" = 32 ]; then
	echo -e "Your system architecture is $ARCH which is unsupported to run Nadeko. \nYour OS: $OS \nOS Version: $VER"
	echo
	printf "\e[1;31mPlease check the NadekoBot self-hosting guide for alternatives.\e[0m\n"
	rm nadekopm2setup.sh
	exit 1
fi


echo -e "Welcome to NadekoBot's pm2 setup! \nWould you like to continue? \nYour OS: $OS \nOS Version: $VER \nArchitecture: $ARCH"

while true; do
    read -p "[y/n]: " yn
    case $yn in
        [Yy]* ) clear; echo Running NadekoBot pm2 Setup; sleep 2; break;;
        [Nn]* ) echo Quitting...; rm nadekopm2setup.sh && exit;;
        * ) echo "Couldn't get that please type [y] for Yes or [n] for No.";;
    esac
done

if [ "$OS" = "Ubuntu" ]; then
echo "This installer will download/update NodeJS/npm and install pm2."
echo ""
read -n 1 -s -p "Press any key to continue..."
	echo ""
	echo "Starting.."
	echo "Installing node/npm. Please wait.."
	curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
	sudo apt-get install -y nodejs
	sudo apt-get install -y build-essential
	sudo npm i -g npm
	echo "Installing pm2..."
	sudo npm install pm2@3.1.3 -g
fi
	
if [ "$OS" = "Debian" ]; then
echo "This installer will download/update NodeJS/npm and install pm2."
echo ""
read -n 1 -s -p "Press any key to continue..."
	echo ""
	echo "Starting.."
	echo "Installing node/npm. Please wait.."
	curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
	sudo apt-get install -y nodejs
	sudo apt-get install -y build-essential
	sudo npm i -g npm
	echo "Installing pm2..."
	sudo npm install pm2@3.1.3 -g
fi
	
if [ "$OS" = "LinuxMint" ]; then
echo "This installer will download/update NodeJS/npm and install pm2."
echo ""
read -n 1 -s -p "Press any key to continue..."
	echo ""
	echo "Starting.."
	echo "Installing node/npm. Please wait.."
	curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
	sudo apt-get install -y nodejs
	sudo apt-get install -y build-essential
	sudo npm i -g npm
	echo "Installing pm2..."
	sudo npm install pm2@3.1.3 -g
fi

if [ "$OS" = "CentOS" ]; then
echo "This installer will download/update NodeJS/npm and install pm2."
echo ""
read -n 1 -s -p "Press any key to continue..."
	echo ""
	echo "Starting.."
	echo "Installing node/npm. Please wait.."
	curl --silent --location https://rpm.nodesource.com/setup_8.x | sudo bash -
	sudo yum -y install nodejs
	sudo yum install gcc-c++ make
	sudo npm i -g npm
	echo "Installing pm2..."
	sudo npm install pm2@3.1.3 -g
fi


echo
echo "NadekoBot pm2 Installation completed..."
read -n 1 -s -p "Press any key to continue to the main menu..."
sleep 2

cd "$root"
rm "$root/nadekopm2setup.sh"
exit 0