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
	echo -e "Your system architecture is $ARCH which is unsupported to run Microsoft .NET Core SDK. \nYour OS: $OS \nOS Version: $VER"
	echo
	printf "\e[1;31mPlease check the NadekoBot self-hosting guide for alternatives.\e[0m\n"
	rm nadekoautoinstaller.sh
	exit 1
fi

if [ "$OS" = "Ubuntu" ]; then
	if [ "$VER" = "12.04" ]; then
		supported=0
	elif [ "$VER" = "14.04" ]; then
		supported=1
	elif [ "$VER" = "16.04" ]; then
		supported=1
	elif [ "$VER" = "16.10" ]; then
		supported=1
	elif [ "$VER" = "17.04" ]; then
		supported=1
	else
		supported=0
	fi
fi

if [ "$OS" = "LinuxMint" ]; then
	SVER=$( echo $VER | grep -oP "[0-9]+" | head -1 )
	if [ "$SVER" = "18" ]; then
		supported=1
	elif [ "$SVER" = "17" ]; then
		supported=1
	elif [ "$SVER" = "2" ]; then
		supported=1
	else
		supported=0
	fi
fi

if [ "$supported" = 0 ]; then
	echo -e "Your OS $OS $VER $ARCH looks unsupported to run Microsoft .NET Core. \nExiting..."
	printf "\e[1;31mContact NadekoBot's support on Discord with screenshot.\e[0m\n"
	rm nadekoautoinstaller.sh
	exit 1
fi

if [ "$OS" = "Linux" ]; then
	echo -e "Your OS $OS $VER $ARCH probably can run Microsoft .NET Core. \nContact NadekoBot's support on Discord with screenshot."
	rm nadekoautoinstaller.sh
	exit 1
fi

echo -e "Welcome to NadekoBot Auto Prerequisites Installer. \nWould you like to continue? \nYour OS: $OS \nOS Version: $VER \nArchitecture: $ARCH"

while true; do
    read -p "[y/n]: " yn
    case $yn in
        [Yy]* ) clear; echo Running NadekoBot Auto-Installer; sleep 2; break;;
        [Nn]* ) echo Quitting...; rm nadekoautoinstaller.sh && exit;;
        * ) echo "Couldn't get that please type [y] for Yes or [n] for No.";;
    esac
done

if [ "$OS" = "Ubuntu" ]; then
echo "This installer will download all of the required packages for NadekoBot. It will use about 350MB of space. This might take awhile to download if you do not have a good internet connection."
echo ""
read -n 1 -s -p "Press any key to continue..."
	if [ "$VER" = "14.04" ]; then
	echo ""
	echo "Gwen was here <3"
	echo "Preparing..."
	sudo apt-get install software-properties-common apt-transport-https -y
	sudo sh -c 'echo "deb [arch=amd64] https://apt-mo.trafficmanager.net/repos/dotnet-release/ trusty main" > /etc/apt/sources.list.d/dotnetdev.list'
	sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 417A0893
	sudo add-apt-repository ppa:jonathonf/ffmpeg-3 -y
	sudo add-apt-repository ppa:chris-lea/libsodium -y
	sudo apt update
	sudo apt upgrade -y
	sudo apt dist-upgrade -y
	echo "Installing Git..."
	sudo apt install git -y
	echo "Installing .NET Core..."
	sudo apt-get install dotnet-dev-1.0.4 -y
	echo "Installing prerequisites..."
	sudo apt install libopus0 opus-tools libopus-dev libsodium-dev ffmpeg tmux python python3.5-dev -y
	sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
	sudo chmod a+rx /usr/local/bin/youtube-dl
	elif [ "$VER" = "16.04" ]; then
	echo ""
	echo "Preparing..."
	sudo apt-get install software-properties-common apt-transport-https -y
	sudo sh -c 'echo "deb [arch=amd64] https://apt-mo.trafficmanager.net/repos/dotnet-release/ xenial main" > /etc/apt/sources.list.d/dotnetdev.list'
	sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 417A0893
	sudo add-apt-repository ppa:jonathonf/ffmpeg-3 -y
	sudo apt update
	sudo apt upgrade -y
	sudo apt dist-upgrade -y
	echo "Installing Git..."
	sudo apt install git -y
	echo "Installing .NET Core..."
	sudo apt-get install dotnet-dev-1.0.4 -y
	echo "Installing prerequisites..."
	sudo apt install libopus0 opus-tools libopus-dev libsodium-dev ffmpeg tmux python python3-pip -y
	sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
	sudo chmod a+rx /usr/local/bin/youtube-dl
	elif [ "$VER" = "16.10" ]; then
	echo ""
	echo "Preparing..."
	sudo apt-get install software-properties-common apt-transport-https -y
	sudo sh -c 'echo "deb [arch=amd64] https://apt-mo.trafficmanager.net/repos/dotnet-release/ yakkety main" > /etc/apt/sources.list.d/dotnetdev.list'
	sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 417A0893
	sudo apt update
	sudo apt upgrade -y
	sudo apt dist-upgrade -y
	echo "Installing Git..."
	sudo apt install git -y
	echo "Installing .NET Core..."
	sudo apt-get install dotnet-dev-1.0.4 -y
	echo "Installing prerequisites..."
	sudo apt install libopus0 opus-tools libopus-dev libsodium-dev ffmpeg tmux python python3-pip -y
	sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
	sudo chmod a+rx /usr/local/bin/youtube-dl
	elif [ "$VER" = "17.04" ]; then
	echo ""
	echo "Preparing..."
	sudo apt-get install software-properties-common apt-transport-https -y
	sudo sh -c 'echo "deb [arch=amd64] https://apt-mo.trafficmanager.net/repos/dotnet-release/ yakkety main" > /etc/apt/sources.list.d/dotnetdev.list'
	sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 417A0893
	sudo apt update
	sudo apt upgrade -y
	sudo apt dist-upgrade -y
	echo "Installing Git..."
	sudo apt install git -y
	echo "Installing .NET Core..."
	sudo apt-get install dotnet-dev-1.0.4 -y
	echo "Installing prerequisites..."
	sudo apt install libopus0 opus-tools libopus-dev libsodium-dev ffmpeg tmux python python3-pip -y
	sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
	sudo chmod a+rx /usr/local/bin/youtube-dl
	fi
elif [ "$OS" = "Debian" ]; then
	if [ "$SVER" = "8" ]; then
		echo ""
		echo "Adding .NET to PATH..."
		apt-get update
		apt-get upgrade -y
		apt-get install sudo -y
		sudo apt-get install software-properties-common apt-transport-https -y
		sudo apt-get install curl libunwind8 gettext -y
		curl -sSL -o dotnet.tar.gz https://go.microsoft.com/fwlink/?linkid=848826
		sudo mkdir -p /opt/dotnet && sudo tar zxf dotnet.tar.gz -C /opt/dotnet
		sudo ln -s /opt/dotnet/dotnet /usr/local/bin
		echo "Installing prerequisites..."
		echo "deb http://ftp.debian.org/debian jessie-backports main" | tee /etc/apt/sources.list.d/debian-backports.list
		sudo apt-get update && sudo apt install ffmpeg -y
		sudo apt-get install libopus0 opus-tools libopus-dev libsodium-dev -y
		sudo apt-get install git -y
		sudo apt-get install tmux python python3.5 -y
		sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
		sudo chmod a+rx /usr/local/bin/youtube-dl
		
	elif [ "$SVER" = "9.1" ]; then
		echo ""
		echo "Adding .NET to PATH..."
		sudo apt-get update
		sudo apt-get upgrade -y
		sudo apt-get install software-properties-common apt-transport-https -y
		sudo apt-get install curl libunwind8 gettext -y
		curl -sSL -o dotnet.tar.gz https://go.microsoft.com/fwlink/?linkid=848826
		sudo mkdir -p /opt/dotnet && sudo tar zxf dotnet.tar.gz -C /opt/dotnet
		sudo ln -s /opt/dotnet/dotnet /usr/local/bin
		echo "Installing prerequisites..."
		sudo apt-get update && sudo apt install ffmpeg -y
		sudo apt-get install libopus0 opus-tools libopus-dev libsodium-dev -y
		sudo apt-get install git -y
		sudo apt-get install tmux python python3.5 -y
		sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
		sudo chmod a+rx /usr/local/bin/youtube-dl
	else
		echo -e "Your OS $OS $VER $ARCH probably can run Microsoft .NET Core. \nContact NadekoBot's support on Discord with screenshot."
		rm nadekoautoinstaller.sh
		exit 1
	fi
elif [ "$OS" = "LinuxMint" ]; then
	if [ "$SVER" = "18" ]; then
		echo ""
		echo "Preparing..."
		sudo apt-get install software-properties-common apt-transport-https -y
		sudo sh -c 'echo "deb [arch=amd64] https://apt-mo.trafficmanager.net/repos/dotnet-release/ xenial main" > /etc/apt/sources.list.d/dotnetdev.list'
		sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 417A0893
		sudo add-apt-repository ppa:jonathonf/ffmpeg-3 -y
		sudo apt update
		sudo apt upgrade -y
		sudo apt dist-upgrade -y
		echo "Installing Git..."
		sudo apt install git -y
		echo "Installing .NET Core..."
		sudo apt-get install dotnet-dev-1.0.4 -y
		echo "Installing prerequisites..."
		sudo apt install libopus0 opus-tools libopus-dev libsodium-dev ffmpeg tmux python python3-pip -y
		sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
		sudo chmod a+rx /usr/local/bin/youtube-dl
	elif [ "$SVER" = "17" ]; then
		echo ""
		echo "Preparing..."
		sudo apt-get install software-properties-common apt-transport-https -y
		sudo sh -c 'echo "deb [arch=amd64] https://apt-mo.trafficmanager.net/repos/dotnet-release/ trusty main" > /etc/apt/sources.list.d/dotnetdev.list'
		sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 417A0893
		sudo add-apt-repository ppa:jonathonf/ffmpeg-3 -y
		sudo add-apt-repository ppa:chris-lea/libsodium -y
		sudo apt update
		sudo apt upgrade -y
		sudo apt dist-upgrade -y
		echo "Installing Git..."
		sudo apt install git -y
		echo "Installing .NET Core..."
		sudo apt-get install dotnet-dev-1.0.4 -y
		echo "Installing prerequisites..."
		sudo apt install libopus0 opus-tools libopus-dev libsodium-dev ffmpeg tmux python python3-pip -y
		sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
		sudo chmod a+rx /usr/local/bin/youtube-dl
	elif [ "$SVER" = "2" ]; then
		echo ""
		echo "Adding .NET to PATH..."
		apt-get update
		apt-get upgrade -y
		apt-get install sudo -y
		sudo apt-get install software-properties-common apt-transport-https -y
		sudo apt-get install curl libunwind8 gettext -y
		curl -sSL -o dotnet.tar.gz https://go.microsoft.com/fwlink/?linkid=848826
		sudo mkdir -p /opt/dotnet && sudo tar zxf dotnet.tar.gz -C /opt/dotnet
		sudo ln -s /opt/dotnet/dotnet /usr/local/bin
		echo "Installing prerequisites..."
		echo "deb http://ftp.debian.org/debian jessie-backports main" | tee /etc/apt/sources.list.d/debian-backports.list
		sudo apt-get update && sudo apt install ffmpeg -y
		sudo apt-get install libopus0 opus-tools libopus-dev libsodium-dev -y
		sudo apt-get install git -y
		sudo apt-get install tmux python python3.5 -y
		sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
		sudo chmod a+rx /usr/local/bin/youtube-dl
	fi
elif [ "$OS" = "CentOS" ]; then
	if [ "$VER" = "7" ]; then
		echo ""
		echo "Preparing..."
		yum --obsoletes --exclude=kernel* update -y
		yum install sudo -y
		sudo yum install libunwind libicu -y
		curl -sSL -o dotnet.tar.gz https://go.microsoft.com/fwlink/?linkid=848821
		sudo mkdir -p /opt/dotnet && sudo tar zxf dotnet.tar.gz -C /opt/dotnet
		sudo ln -s /opt/dotnet/dotnet /usr/local/bin
		yum -y install http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm epel-release
		sudo yum install git opus opus-devel ffmpeg tmux yum-utils -y
		sudo yum -y groupinstall development
		sudo yum -y install https://centos7.iuscommunity.org/ius-release.rpm
		sudo yum install python python36u python36u-pip python36u-devel -y
		wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
		chmod a+rx /usr/local/bin/youtube-dl
	else
		echo -e "Your OS $OS $VER $ARCH probably can run Microsoft .NET Core. \nContact NadekoBot's support on Discord with screenshot."
		rm nadekoautoinstaller.sh
		exit 1
	fi
fi

echo
echo "NadekoBot Prerequisites Installation completed..."
read -n 1 -s -p "Press any key to continue..."
sleep 2

cd "$root"
rm "$root/nadekoautoinstaller.sh"
exit 0
