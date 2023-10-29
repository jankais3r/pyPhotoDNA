@echo off

echo.
echo Welcome to the pyPhotoDNA installer.
echo The script will now setup a pyPhotoDNA environment for you. Please be patient.

echo.
echo Downloading FTK (3.3GB, might take a while)...
bitsadmin /transfer "Downloading FTK" /priority HIGH https://d1kpmuwb7gvu1i.cloudfront.net/AD_FTK_7.0.0.iso %cd%\AD_FTK_7.0.0.iso > nul

echo.
echo Extracting PhotoDNAx64.dll.
powershell.exe -Command "&{$mountResult = Mount-DiskImage %cd%\\AD_FTK_7.0.0.iso; $driveLetter = ($mountResult | Get-Volume).DriveLetter; $setupPath = \"$($driveLetter):\FTK\FTK\x64\{C32BC7B7-3086-44FD-8A90-9EC47966B4B7}\Data1.cab\"; echo "'Setup file is' $setupPath"; $finalString = expand $setupPath /f:photodnax64.1.72.dll %cd%; Get-Volume $driveLetter | Get-DiskImage | Dismount-DiskImage }" > nul
del AD_FTK_7.0.0.iso
rename photodnax64.1.72.dll PhotoDNAx64.dll

echo.
echo.
echo Installation complete!
echo _____________________________
echo.
echo To generate a PhotoDNA hash, run generateHashes.py.
pause