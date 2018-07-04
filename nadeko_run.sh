#!/bin/sh
echo ""
echo "NadekoBot 1.9+"
echo "Mirai was here."
root=$(pwd)
youtube-dl -U

if hash dotnet 2>/dev/null
then
	echo "Dotnet installed."
else
	echo "Dotnet is not installed. Please install dotnet."
	exit 1
fi
cd "$root/NadekoBot"
dotnet restore
dotnet build --configuration Release
cd "$root/NadekoBot/src/NadekoBot"
echo "Running NadekoBot. Please wait."
dotnet run
echo "Done"

cd "$root"
rm "$root/nadeko_run.sh"
exit 0
