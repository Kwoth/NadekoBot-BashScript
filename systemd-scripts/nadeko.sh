#!/bin/bash
cd "$(dirname "$(realpath "$0")")"/NadekoBot

echo Updating YouTube download library.
/usr/local/bin/youtube-dl -U

echo Rebuilding NadekoBot...
/usr/bin/dotnet restore
/usr/bin/dotnet build -c Release

cd src/NadekoBot
echo Running NadekoBot...
/usr/bin/dotnet run -c Release