#!/bin/bash

if [ "$(uname)" == "Darwin" ]; then
  echo
  echo "Welcome to the pyPhotoDNA installer."
  echo "The script will now setup a pyPhotoDNA environment for you. Please be patient."
  
  echo
  echo "Downloading BlackLight (1.8GB, might take a while)..."
  curl -LO https://s3-us-west-2.amazonaws.com/bbt-software-releases/0100_BlackLight/BlackLight_Mac_Setup_2020r1.pkg
  
  echo
  echo "Extracting PhotoDNAx64.so."
  pkgutil --expand-full BlackLight_Mac_Setup_2020r1.pkg BL
  rm BlackLight_Mac_Setup_2020r1.pkg
  mv BL/BlackLight.pkg/Payload/Applications/BlackLight/BlackLight\ 2020\ Release\ 1/BlackLight.app/Contents/Resources/Mac/artifact_parser/PhotoDNAx64-osx.so.1.72 PhotoDNAx64.so
  rm -rf BL
  
  echo
  echo
  echo "Installation complete!"
  echo "_____________________________"
  echo
  echo "To generate a PhotoDNA hash, run generateHashes.py."
else
  echo "jPhotoDNA does not support Linux. Please run install.sh on a Mac."
fi
