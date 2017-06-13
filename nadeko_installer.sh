#!/bin/sh
echo ""
echo "NadekoBot Installer started."

if hash git 1>/dev/null 2>&1
then
    echo ""
    echo "Git Installed."
else
    echo ""    
    echo "Git is not installed. Please install Git."
    exit 1
fi


if hash dotnet 1>/dev/null 2>&1
then
    echo ""
    echo "Dotnet installed."
else
    echo ""
    echo "Dotnet is not installed. Please install dotnet."
    exit 1
fi

root=$(pwd)
tempdir=NadekoInstall_Temp

rm -r "$tempdir" 1>/dev/null 2>&1
mkdir "$tempdir"
cd "$tempdir"

echo ""
echo "Downloading NadekoBot, please wait."
git clone -b master --recursive --depth 1 https://github.com/Kwoth/NadekoBot.git
echo ""
echo "NadekoBot downloaded."

echo ""
echo "Downloading Nadeko dependencies"
cd $root/$tempdir/NadekoBot/Discord.Net/src/Discord.Net.Core/
dotnet restore 1>/dev/null 2>&1
cd $root/$tempdir/NadekoBot/Discord.Net/src/Discord.Net.Rest/
dotnet restore 1>/dev/null 2>&1
cd $root/$tempdir/NadekoBot/Discord.Net/src/Discord.Net.WebSocket/
dotnet restore 1>/dev/null 2>&1
cd $root/$tempdir/NadekoBot/Discord.Net/src/Discord.Net.Commands/
dotnet restore 1>/dev/null 2>&1
cd $root/$tempdir/NadekoBot/src/NadekoBot/
dotnet restore 1>/dev/null 2>&1
echo ""
echo "Download done"

echo ""
echo "Building NadekoBot"
cd $root/$tempdir/NadekoBot/src/NadekoBot/
dotnet build --configuration Release 1>/dev/null 2>&1
echo ""
echo "Building done. Moving Nadeko"

cd "$root"

if [ ! -d NadekoBot ]
then
    mv "$tempdir"/NadekoBot NadekoBot
else
    rm -rf NadekoBot_old 1>/dev/null 2>&1
    mv -fT NadekoBot NadekoBot_old 1>/dev/null 2>&1
    mv $tempdir/NadekoBot NadekoBot
    cp -f $root/NadekoBot_old/src/NadekoBot/credentials.json $root/NadekoBot/src/NadekoBot/credentials.json 1>/dev/null 2>&1
    echo ""
    echo "credentials.json copied to the new version"
    cp -RT $root/NadekoBot_old/src/NadekoBot/bin/ $root/NadekoBot/src/NadekoBot/bin/ 1>/dev/null 2>&1
    cp -RT $root/NadekoBot/src/NadekoBot/bin/Release/netcoreapp1.1/data/NadekoBot.db $root/NadekoBot/src/NadekoBot/bin/Release/netcoreapp1.0/data/NadekoBot.db 1>/dev/null 2>&1
    mv -f $root/NadekoBot/src/NadekoBot/bin/Release/netcoreapp1.1/data/NadekoBot.db $root/NadekoBot/src/NadekoBot/bin/Release/netcoreapp1.1/data/NadekoBot_old.db 1>/dev/null 2>&1
    echo ""
    echo "Database copied to the new version"
    cp -RT $root/NadekoBot_old/src/NadekoBot/data/ $root/NadekoBot/src/NadekoBot/data/ 1>/dev/null 2>&1
    echo ""
    echo "Other data copied to the new version"
fi

rm -r "$tempdir"
echo ""
echo "Installation Complete."
exit 0
