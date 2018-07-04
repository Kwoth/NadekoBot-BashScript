#!/bin/sh
echo ""
echo "Running NadekoBot with auto restart normally! (without updating)"
root=$(pwd)
youtube-dl -U

sleep 5s
cd "$root/NadekoBot"
dotnet restore && dotnet build --configuration Release

while :; do cd "$root/NadekoBot/src/NadekoBot" && dotnet run; sleep 5s; done
echo ""
echo "That didn't work? Please report in #NadekoLog Discord Server."
sleep 3s

cd "$root"
bash "$root/linuxAIO.sh"
echo "Done"

exit 0
