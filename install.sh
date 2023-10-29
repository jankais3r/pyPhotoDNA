#!/bin/bash

echo
echo "Welcome to the pyPhotoDNA installer."
echo "The script will now setup a pyPhotoDNA environment for you. Please be patient."
echo

if [ "$(uname)" == "Darwin" ]; then
	echo "Download link for native macOS version currently unavailable."
else
	if ! [ -x "$(command -v curl)" ]; then
		echo "Dependency missing. Please install 'curl' and re-run the installer."
		exit 1
	fi
	if ! [ -x "$(command -v wine64)" ]; then
		echo "Dependency missing. Please install 'wine64' and re-run the installer."
		exit 1
	fi
	if ! [ -x "$(command -v cabextract)" ]; then
		echo "Dependency missing. Please install 'cabextract' and re-run the installer."
		exit 1
	fi
	if ! [ -x "$(command -v isoinfo)" ]; then
		echo "Dependency missing. Please install 'genisoimage' and re-run the installer."
		exit 1
	fi
	
	echo "Downloading FTK (3.3GB, might take a while)..."
	curl -LO https://d1kpmuwb7gvu1i.cloudfront.net/AD_FTK_7.0.0.iso
	
	echo
	echo "Extracting PhotoDNAx64.dll."
	isoinfo -i AD_FTK_7.0.0.iso -x /FTK/FTK/X64/_8A89F09/DATA1.CAB > Data1.cab
	rm AD_FTK_7.0.0.iso
	cabextract -d tmp -q Data1.cab
	rm Data1.cab
	mv tmp/photodnax64.1.72.dll PhotoDNAx64.dll
	rm -rf tmp
	
	echo
	echo "Downloading minimal Python for Wine..."
	curl -LO https://github.com/jankais3r/pyPhotoDNA/releases/download/wine_python_39/wine_python_39.tar.gz
	tar -xf wine_python_39.tar.gz
	rm wine_python_39.tar.gz
	
	echo
	echo
	echo "Installation complete!"
	echo "_____________________________"
	echo
	echo "To generate a PhotoDNA hash, run: WINEDEBUG=-all wine64 python-3.9.12-embed-amd64/python.exe generateHashes.py"
fi
