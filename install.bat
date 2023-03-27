@echo off

echo.
echo Welcome to the pyPhotoDNA installer.
echo The script will now setup a pyPhotoDNA environment for you. Please be patient.

echo.
echo Downloading AXIOM (4GB, might take a while)...
bitsadmin /transfer "Downloading AXIOM" /priority HIGH https://magnetforensics.com/dl/axiom %cd%\axiom.zip > nul

echo.
echo Extracting AXIOM Installer...
powershell Expand-Archive axiom.zip -DestinationPath .\axiom

del axiom.zip
cd axiom

echo.
echo Downloading InnoExtract...
bitsadmin /transfer "Downloading InnoExtract" /priority HIGH  https://constexpr.org/innoextract/files/innoextract-1.9-windows.zip %cd%\innoextract.zip > nul

echo.
echo Extracting InnoExtract...
powershell Expand-Archive innoextract.zip -DestinationPath .

echo.
echo Extracting PhotoDNAx64.dll (might take a while)...
for %%A in (*.exe) do (
    set "axiom=%%~nA.exe"
    GOTO endloop
)

:endloop
innoextract.exe -I "app\AXIOM Process\x64\PhotoDNAx64.dll" -s -e %axiom%

move "%cd%\app\AXIOM Process\x64\PhotoDNAx64.dll" %cd%\..
cd ..
rmdir /s /q "%cd%\axiom"

echo.
echo.
echo Installation complete!
echo _____________________________
echo.
echo To generate a PhotoDNA hash, run generateHashes.py.
pause
