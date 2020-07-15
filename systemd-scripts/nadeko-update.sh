#!/bin/bash
rootPath="$(dirname "$(realpath "$0")")"
cd "$rootPath"
tempDir=NadekoTemp

if [ -d $tempDir ]; then
	rm -r $tempDir
fi	
mkdir $tempDir
cd $tempDir

echo Stopping NadekoBot for update.
/bin/systemctl --user stop nadeko.service

echo Beginning NadekoBot Update.
echo
echo Downloading NadekoBot...
git clone -b 1.9 --recursive --depth 1 https://gitlab.com/Kwoth/NadekoBot
echo Download complete.
echo

echo Rebuilding NadekoBot...
cd "$rootPath"/$tempDir/NadekoBot
/usr/bin/dotnet restore
/usr/bin/dotnet build --configuration Release
echo Rebuild complete.
echo

cd "$rootPath"
if [ ! -d NadekoBot ]; then
    mv $tempDir/NadekoBot NadekoBot
else
	backupDir=NadekoBot.backup
	releaseDir=src/NadekoBot/bin/Release
	echo Backing up previous build...
	if [ -d $backupDir ]; then
	    rm -rf NadekoBot.backup
	fi
    mv -fT NadekoBot NadekoBot.backup
    
    echo Installing updated build...
    mv $tempDir/NadekoBot NadekoBot
    
    echo Copying data from the previous build...
    cd "$rootPath"
    
    if [ -f ./$backupDir/src/NadekoBot/credentials.json ]; then
	    cp -f ./$backupDir/src/NadekoBot/credentials.json ./NadekoBot/src/NadekoBot/credentials.json
	    cp -f ./$backupDir/src/NadekoBot/credentials.json ./NadekoBot/src/NadekoBot/credentials.backup.json
	else
		echo Warning, no credentials found in the current install!
    fi

	if [ -f ./$backupDir/$releaseDir/netcoreapp1.0/data/NadekoBot.db ]; then
	    cp -T ./$backupDir/$releaseDir/netcoreapp1.0/data/NadekoBot.db ./NadekoBot/$releaseDir/netcoreapp2.1/data/NadekoBot.db
	    cp -T ./$backupDir/$releaseDir/netcoreapp1.0/data/NadekoBot.db ./NadekoBot/$releaseDir/netcoreapp2.1/data/NadekoBot-1.0.backup.db
	elif [ -f ./$backupDir/$releaseDir/netcoreapp1.1/data/NadekoBot.db ]; then
		cp -T ./$backupDir/$releaseDir/netcoreapp1.1/data/NadekoBot.db ./NadekoBot/$releaseDir/netcoreapp2.1/data/NadekoBot.db
		cp -T ./$backupDir/$releaseDir/netcoreapp1.1/data/NadekoBot.db ./NadekoBot/$releaseDir/netcoreapp2.1/data/NadekoBot-1.1.backup.db
    elif [ -f ./$backupDir/$releaseDir/netcoreapp2.0/data/NadekoBot.db ]; then
	    cp -T ./$backupDir/$releaseDir/netcoreapp2.0/data/NadekoBot.db ./NadekoBot/$releaseDir/netcoreapp2.1/data/NadekoBot.db
	    cp -T ./$backupDir/$releaseDir/netcoreapp2.0/data/NadekoBot.db ./NadekoBot/$releaseDir/netcoreapp2.1/data/NadekoBot-2.0.backup.db
	elif [ -d ./$backupDir/$releaseDir/netcoreapp2.1/data ]; then
	    cp ./$backupDir/$releaseDir/netcoreapp2.1/data/*.db ./NadekoBot/$releaseDir/netcoreapp2.1/data
	    cp ./$backupDir/$releaseDir/netcoreapp2.1/data/NadekoBot.db ./NadekoBot/$releaseDir/netcoreapp2.1/data/NadekoBot.backup.db
    else
    	echo Database not found from previous build!
    fi

	if [ -d ./$backupDir/src/NadekoBot/data ]; then
	    cp -r ./$backupDir/src/NadekoBot/data/ ./NadekoBot/src/NadekoBot/data/
	else
		echo Warning no data directory found from previous build!
	fi
	
	echo All data copied from previous build.
    echo
fi

rm -r $tempDir
echo Update complete.

echo Starting NadekoBot with new build.
/bin/systemctl --user start nadeko.service