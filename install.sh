#!/bin/bash

if [ "$(uname)" == "Darwin" ]; then
  echo
  echo "Welcome to the pyPhotoDNA installer."
  echo "The script will now setup a pyPhotoDNA environment for you. Please be patient."
  
  echo
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
  echo "To generate a PhotoDNA hash, run generateHashes.py."
else
  echo "pyPhotoDNA does not support Linux. Please run install.sh on a Mac."
fi