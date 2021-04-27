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
        OS=Debian # XXX or Ubuntu??
        VER=$(cat /etc/debian_version)
        SVER=$(cat /etc/debian_version | grep -oP "[0-9]+" | head -1)
    elif [ -f /etc/centos-release ]; then
        OS=CentOS
        VER=$(cat /etc/centos-release | grep -oP "[0-9]+" | head -1)
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
        ARCH=x64 # or AMD64 or Intel64 or whatever
        ;;
    i*86)
        ARCH=x86 # or IA32 or Intel32 or whatever
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
    elif [ "$VER" = "17.10" ]; then
        supported=1
    elif [ "$VER" = "18.04" ]; then
        supported=1
    elif [ "$VER" = "18.10" ]; then
        supported=1
        VER=18.04
        echo -e "Using Ubuntu 18.04 Installation scripts.\nIf the installation fails contact NadekoBot support."
        sleep 5
    elif [ "$VER" = "19.04" ]; then
        supported=1
    elif [ "$VER" = "19.10" ]; then
        supported=1
        #VER=19.04
        #echo -e "Using Ubuntu 19.04 Installation scripts.\nIf the installation fails contact NadekoBot support."
        #sleep 5
    elif [ "$VER" = "20.04" ]; then
        supported=1
    else
        supported=0
    fi
fi

if [ "$OS" = "LinuxMint" ]; then
    SVER=$(echo $VER | grep -oP "[0-9]+" | head -1)
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
    [Yy]*)
        clear
        echo Running NadekoBot Auto-Installer
        sleep 2
        break
        ;;
    [Nn]*)
        echo Quitting...
        rm nadekoautoinstaller.sh && exit
        ;;
    *) echo "Couldn't get that please type [y] for Yes or [n] for No." ;;
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
        sudo apt-get update
        sudo apt-get install software-properties-common apt-transport-https curl -y
        wget -q https://packages.microsoft.com/config/ubuntu/14.04/packages-microsoft-prod.deb
        sudo dpkg -i packages-microsoft-prod.deb
        # sudo add-apt-repository ppa:jonathonf/ffmpeg-4 -y
        sudo add-apt-repository ppa:chris-lea/libsodium -y
        sudo apt-get update
        sudo apt-get upgrade -y
        # sudo apt-get dist-upgrade -y
        echo "Installing Git..."
        sudo apt-get install git -y
        echo "Installing .NET Core..."
        sudo apt-get install dotnet-sdk-3.1 -y
        echo "Installing prerequisites..."
        sudo apt-get install libopus0 opus-tools libopus-dev libsodium-dev tmux python python3.5-dev redis-server snapd -y
        sudo snap install ffmpeg
        sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
        sudo chmod a+rx /usr/local/bin/youtube-dl
        # remove dotnet temp
        sudo rm -f packages-microsoft-prod.deb
    elif [ "$VER" = "16.04" ]; then
        echo ""
        echo "Preparing..."
        sudo apt-get update
        sudo apt-get install software-properties-common apt-transport-https curl -y
        wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb
        sudo dpkg -i packages-microsoft-prod.deb
        sudo add-apt-repository ppa:jonathonf/ffmpeg-4 -y
        sudo apt-get update
        sudo apt-get upgrade -y
        # sudo apt-get dist-upgrade -y
        echo "Installing Git..."
        sudo apt-get install git -y
        echo "Installing .NET Core..."
        sudo apt-get install dotnet-sdk-3.1 -y
        echo "Installing prerequisites..."
        sudo apt-get install libopus0 opus-tools libopus-dev libsodium-dev tmux python python3-pip redis-server ffmpeg -y
        # sudo snap install ffmpeg
        sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
        sudo chmod a+rx /usr/local/bin/youtube-dl
        # remove dotnet temp
        sudo rm -f packages-microsoft-prod.deb
    elif [ "$VER" = "16.10" ]; then
        echo ""
        echo "Preparing..."
        sudo apt-get update
        sudo apt-get install software-properties-common apt-transport-https curl -y
        wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb
        sudo dpkg -i packages-microsoft-prod.deb
        sudo apt-get update
        sudo apt-get upgrade -y
        # sudo apt-get dist-upgrade -y
        echo "Installing Git..."
        sudo apt-get install git -y
        echo "Installing .NET Core..."
        sudo apt-get install dotnet-sdk-3.1 -y
        echo "Installing prerequisites..."
        sudo apt-get install libopus0 opus-tools libopus-dev libsodium-dev ffmpeg tmux python python3-pip redis-server -y
        sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
        sudo chmod a+rx /usr/local/bin/youtube-dl
        # remove dotnet temp
        sudo rm -f packages-microsoft-prod.deb
    elif [ "$VER" = "17.04" ]; then
        echo ""
        echo "Preparing..."
        sudo apt-get update
        sudo apt-get install software-properties-common apt-transport-https curl -y
        wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb
        sudo dpkg -i packages-microsoft-prod.deb
        sudo apt-get update
        sudo apt-get upgrade -y
        # sudo apt-get dist-upgrade -y
        echo "Installing Git..."
        sudo apt-get install git -y
        echo "Installing .NET Core..."
        sudo apt-get install dotnet-sdk-3.1 -y
        echo "Installing prerequisites..."
        sudo apt-get install libopus0 opus-tools libopus-dev libsodium-dev ffmpeg tmux python python3-pip redis-server -y
        sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
        sudo chmod a+rx /usr/local/bin/youtube-dl
        # remove dotnet temp
        sudo rm -f packages-microsoft-prod.deb
    elif [ "$VER" = "17.10" ]; then
        echo ""
        echo "Preparing..."
        sudo apt-get update
        sudo apt-get install software-properties-common apt-transport-https curl -y
        wget -q https://packages.microsoft.com/config/ubuntu/17.10/packages-microsoft-prod.deb
        sudo dpkg -i packages-microsoft-prod.deb
        sudo apt-get update
        sudo apt-get upgrade -y
        # sudo apt-get dist-upgrade -y
        echo "Installing Git..."
        sudo apt-get install git -y
        echo "Installing .NET Core..."
        sudo apt-get install dotnet-sdk-3.1 -y
        echo "Installing prerequisites..."
        sudo apt-get install libopus0 opus-tools libopus-dev libsodium-dev ffmpeg tmux python python3-pip redis-server -y
        sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
        sudo chmod a+rx /usr/local/bin/youtube-dl
        # remove dotnet temp
        sudo rm -f packages-microsoft-prod.deb
    elif [ "$VER" = "18.04" ]; then
        echo ""
        echo "Preparing..."
        sudo apt-get update
        #wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
        #sudo dpkg -i packages-microsoft-prod.deb
        sudo add-apt-repository universe
        sudo apt-get install software-properties-common apt-transport-https curl gpg -y
        #Backup for manual installation.
        wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >microsoft.asc.gpg
        sudo mv -f microsoft.asc.gpg /etc/apt/trusted.gpg.d/
        wget -q https://packages.microsoft.com/config/ubuntu/18.04/prod.list
        sudo mv -f prod.list /etc/apt/sources.list.d/microsoft-prod.list
        sudo chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg
        sudo chown root:root /etc/apt/sources.list.d/microsoft-prod.list
        sudo apt-get update
        sudo apt-get upgrade -y
        # sudo apt-get dist-upgrade -y
        echo "Installing Git..."
        sudo apt-get install git -y
        echo "Installing .NET Core..."
        sudo apt-get install dotnet-sdk-3.1 -y
        echo "Installing prerequisites..."
        sudo apt-get install libopus0 opus-tools libopus-dev libsodium-dev ffmpeg tmux python python3-pip redis-server -y
        sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
        sudo chmod a+rx /usr/local/bin/youtube-dl
    # remove dotnet temp
    #sudo rm -f packages-microsoft-prod.deb
    elif [ "$VER" = "19.04" ]; then
        echo ""
        echo "Preparing..."
        sudo apt-get update
        #wget -q https://packages.microsoft.com/config/ubuntu/19.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
        #sudo dpkg -i packages-microsoft-prod.deb
        sudo apt-get install software-properties-common apt-transport-https curl gpg -y
        #Backup for manual installation.
        wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >microsoft.asc.gpg
        sudo mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/
        wget -q https://packages.microsoft.com/config/ubuntu/19.04/prod.list
        sudo mv prod.list /etc/apt/sources.list.d/microsoft-prod.list
        sudo chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg
        sudo chown root:root /etc/apt/sources.list.d/microsoft-prod.list
        sudo apt-get update
        sudo apt-get upgrade -y
        # sudo apt-get dist-upgrade -y
        echo "Installing Git..."
        sudo apt-get install git -y
        echo "Installing .NET Core..."
        sudo apt-get install dotnet-sdk-3.1 -y
        echo "Installing prerequisites..."
        sudo apt-get install libopus0 opus-tools libopus-dev libsodium-dev ffmpeg tmux python python3-pip redis-server -y
        sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
        sudo chmod a+rx /usr/local/bin/youtube-dl
    # remove dotnet temp
    #sudo rm -f packages-microsoft-prod.deb
    elif [ "$VER" = "19.10" ]; then
        echo ""
        echo "Preparing..."
        sudo apt-get update
        #wget https://packages.microsoft.com/config/ubuntu/19.10/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
        #sudo dpkg -i packages-microsoft-prod.deb
        sudo apt-get install software-properties-common apt-transport-https curl gpg -y
        #Backup for manual installation.
        wget -O - https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o microsoft.asc.gpg
        sudo mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/
        wget https://packages.microsoft.com/config/ubuntu/19.10/prod.list
        sudo mv prod.list /etc/apt/sources.list.d/microsoft-prod.list
        sudo chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg
        sudo chown root:root /etc/apt/sources.list.d/microsoft-prod.list
        sudo apt-get update
        sudo apt-get upgrade -y
        # sudo apt-get dist-upgrade -y
        echo "Installing Git..."
        sudo apt-get install git -y
        echo "Installing .NET Core..."
        sudo apt-get install dotnet-sdk-3.1 -y
        echo "Installing prerequisites..."
        sudo apt-get install libopus0 opus-tools libopus-dev libsodium-dev ffmpeg tmux python python3-pip redis-server -y
        sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
        sudo chmod a+rx /usr/local/bin/youtube-dl
    # remove dotnet temp
    #sudo rm -f packages-microsoft-prod.deb
    elif [ "$VER" = "20.04" ]; then
        echo ""
        echo "Preparing..."
        sudo apt-get update
        #wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
        #sudo dpkg -i packages-microsoft-prod.deb
        sudo apt-get install software-properties-common apt-transport-https curl gpg -y
        #Backup for manual installation.
        wget -O - https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o microsoft.asc.gpg
        sudo mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/
        wget https://packages.microsoft.com/config/ubuntu/20.04/prod.list
        sudo mv prod.list /etc/apt/sources.list.d/microsoft-prod.list
        sudo chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg
        sudo chown root:root /etc/apt/sources.list.d/microsoft-prod.list
        sudo apt-get update
        sudo apt-get upgrade -y
        # sudo apt-get dist-upgrade -y
        echo "Installing Git..."
        sudo apt-get install git -y
        echo "Installing .NET Core..."
        sudo apt-get install dotnet-sdk-3.1 -y
        echo "Installing prerequisites..."
        sudo apt-get install libopus0 opus-tools libopus-dev libsodium-dev ffmpeg tmux python python3-pip redis-server -y
        sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
        sudo chmod a+rx /usr/local/bin/youtube-dl
    # remove dotnet temp
    #sudo rm -f packages-microsoft-prod.deb
    fi
elif [ "$OS" = "Debian" ]; then
    if [ "$SVER" = "8" ]; then
        echo ""
        echo "Preparing..."
        apt-get update
        apt-get upgrade -y
        apt-get install sudo -y
        sudo apt-get install software-properties-common apt-transport-https -y
        sudo apt-get install curl libunwind8 gettext -y
        wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >microsoft.asc.gpg
        sudo mv -f microsoft.asc.gpg /etc/apt/trusted.gpg.d/
        wget -q https://packages.microsoft.com/config/debian/8/prod.list
        sudo mv -f prod.list /etc/apt/sources.list.d/microsoft-prod.list
        sudo chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg
        sudo chown root:root /etc/apt/sources.list.d/microsoft-prod.list
        sudo apt-get update
        sudo apt-get install dotnet-sdk-3.1 -y
        echo "Installing prerequisites..."
        echo "deb http://ftp.debian.org/debian jessie-backports main" | tee /etc/apt/sources.list.d/debian-backports.list
        sudo apt-get update && sudo apt install ffmpeg -y
        sudo apt-get install libopus0 opus-tools libopus-dev libsodium-dev redis-server -y
        sudo apt-get install git -y
        sudo apt-get install tmux python python3.5 -y
        sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
        sudo chmod a+rx /usr/local/bin/youtube-dl
    elif [ "$SVER" = "9" ]; then
        echo ""
        echo "Preparing..."
        apt-get update
        apt-get upgrade -y
        apt-get install sudo -y
        sudo apt-get install software-properties-common apt-transport-https -y
        sudo apt-get install curl libunwind8 gettext -y
        wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >microsoft.asc.gpg
        sudo mv -f microsoft.asc.gpg /etc/apt/trusted.gpg.d/
        wget -q https://packages.microsoft.com/config/debian/9/prod.list
        sudo mv -f prod.list /etc/apt/sources.list.d/microsoft-prod.list
        sudo chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg
        sudo chown root:root /etc/apt/sources.list.d/microsoft-prod.list
        sudo apt-get update
        sudo apt-get install dotnet-sdk-3.1 -y
        echo "Installing prerequisites..."
        echo "deb http://ftp.debian.org/debian jessie-backports main" | tee /etc/apt/sources.list.d/debian-backports.list
        sudo apt-get update && sudo apt install ffmpeg -y
        sudo apt-get install libopus0 opus-tools libopus-dev libsodium-dev redis-server -y
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
        # Based on Ubuntu 16.04
        echo ""
        echo "Preparing..."
        sudo apt-get update
        sudo apt-get install software-properties-common apt-transport-https curl -y
        wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb
        sudo dpkg -i packages-microsoft-prod.deb
        sudo add-apt-repository ppa:jonathonf/ffmpeg-4 -y
        sudo apt-get update
        sudo apt-get upgrade -y
        # sudo apt-get dist-upgrade -y
        echo "Installing Git..."
        sudo apt-get install git -y
        echo "Installing .NET Core..."
        sudo apt-get install dotnet-sdk-3.1 -y
        echo "Installing prerequisites..."
        sudo apt-get install libopus0 opus-tools libopus-dev libsodium-dev tmux python python3-pip redis-server ffmpeg -y
        # sudo snap install ffmpeg
        sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
        sudo chmod a+rx /usr/local/bin/youtube-dl
        # remove dotnet temp
        sudo rm -f packages-microsoft-prod.deb
    elif [ "$SVER" = "17" ]; then
        # Based on Ubuntu 14.04
        echo ""
        echo "Preparing..."
        sudo apt-get update
        sudo apt-get install software-properties-common apt-transport-https curl -y
        wget -q https://packages.microsoft.com/config/ubuntu/14.04/packages-microsoft-prod.deb
        sudo dpkg -i packages-microsoft-prod.deb
        # sudo add-apt-repository ppa:jonathonf/ffmpeg-4 -y
        sudo add-apt-repository ppa:chris-lea/libsodium -y
        sudo apt-get update
        sudo apt-get upgrade -y
        # sudo apt-get dist-upgrade -y
        echo "Installing Git..."
        sudo apt-get install git -y
        echo "Installing .NET Core..."
        sudo apt-get install dotnet-sdk-3.1 -y
        echo "Installing prerequisites..."
        sudo apt-get install libopus0 opus-tools libopus-dev libsodium-dev tmux python python3.5-dev redis-server snapd -y
        sudo snap install ffmpeg
        sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
        sudo chmod a+rx /usr/local/bin/youtube-dl
        # remove dotnet temp
        sudo rm -f packages-microsoft-prod.deb
    elif [ "$SVER" = "2" ]; then
        # Based on Debian 8
        echo ""
        echo "Preparing..."
        apt-get update
        apt-get upgrade -y
        apt-get install sudo -y
        sudo apt-get install software-properties-common apt-transport-https -y
        sudo apt-get install curl libunwind8 gettext -y
        wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >microsoft.asc.gpg
        sudo mv -f microsoft.asc.gpg /etc/apt/trusted.gpg.d/
        wget -q https://packages.microsoft.com/config/debian/8/prod.list
        sudo mv -f prod.list /etc/apt/sources.list.d/microsoft-prod.list
        sudo chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg
        sudo chown root:root /etc/apt/sources.list.d/microsoft-prod.list
        sudo apt-get update
        sudo apt-get install dotnet-sdk-3.1 -y
        echo "Installing prerequisites..."
        echo "deb http://ftp.debian.org/debian jessie-backports main" | tee /etc/apt/sources.list.d/debian-backports.list
        sudo apt-get update && sudo apt install ffmpeg -y
        sudo apt-get install libopus0 opus-tools libopus-dev libsodium-dev redis-server -y
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
        sudo rpm -Uvh https://packages.microsoft.com/config/centos/7/packages-microsoft-prod.rpm
        sudo yum -y install http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm epel-release
        sudo yum -y install https://centos7.iuscommunity.org/ius-release.rpm
        sudo yum localinstall --nogpgcheck https://download1.rpmfusion.org/free/el/rpmfusion-free-release-7.noarch.rpm https://download1.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-7.noarch.rpm
        sudo yum install git2u opus opus-devel ffmpeg ffmpeg-devel tmux yum-utils -y
        sudo yum -y groupinstall development
        sudo yum --obsoletes --exclude=kernel* update -y
        sudo yum install python python36u python36u-pip python36u-devel dotnet-sdk-3.1 -y
        sudo yum install redis -y
        sudo systemctl start redis
        sudo systemctl enable redis
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
