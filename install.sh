#!/bin/bash

echo
echo "Welcome to the pyPhotoDNA installer."
echo "The script will now setup a pyPhotoDNA environment for you. Please be patient."
echo

if [ "$(uname)" == "Darwin" ]; then
	echo "Downloading Inspector (4.4 GB, might take a while)..."
	curl -LO https://archive.org/download/cellebrite-inspector-10.3-mac/Cellebrite_Inspector_10.3_Mac.pkg
	
	echo
	echo "Extracting PhotoDNAx64.so."
	pkgutil --expand-full Cellebrite_Inspector_10.3_Mac.pkg Inspector
	rm Cellebrite_Inspector_10.3_Mac.pkg
	mv "Inspector/Inspector.pkg/Payload/Applications/Inspector/Inspector 10.3/Inspector.app/Contents/Helpers/Mac/PhotoDNAx64-osx.so.1.72" PhotoDNAx64.so
	rm -rf Inspector
	
	echo
	echo
	echo "Installation complete!"
	echo "_____________________________"
	echo
	echo "To generate a PhotoDNA hash, run: python3 generateHashes.py"
else
	if ! [ -x "$(command -v curl)" ]; then
		echo "Dependency missing. Please install 'curl' and re-run the installer."
		exit 1
	fi
	if ! [ -x "$(command -v wine64)" ]; then
		echo "Dependency missing. Please install 'wine64' and re-run the installer."
		exit 1
	fi
	if ! [ -x "$(command -v unzip)" ]; then
		echo "Dependency missing. Please install 'unzip' and re-run the installer."
		exit 1
	fi
	
	echo "Downloading AXIOM (4GB, might take a while)..."
	curl -Lo axiom.zip https://magnetforensics.com/dl/axiom
	
	echo
	echo "Extracting AXIOM Installer..."
	unzip axiom.zip
	rm axiom.zip
	
	echo
	echo "Downloading InnoExtract..."
	curl -Lo innoextract.tar.xz https://constexpr.org/innoextract/files/innoextract-1.9-linux.tar.xz
	
	echo
	echo "Extracting InnoExtract..."
	tar -xf innoextract.tar.xz
	rm innoextract.tar.xz
	
	echo
	echo "Extracting PhotoDNAx64.dll."
	find . -maxdepth 1 -name "AXIOM*setup.exe" | xargs innoextract-1.9-linux/bin/amd64/innoextract -I "app/AXIOM Process/x64/PhotoDNAx64.dll" -s -e
	mv "app/AXIOM Process/x64/PhotoDNAx64.dll" PhotoDNAx64.dll
	rm -rf app
	rm -rf innoextract-1.9-linux
	rm AXIOM*setup.exe
	rm AXIOM*setup*.bin
	
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
