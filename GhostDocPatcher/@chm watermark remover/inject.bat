@echo off
echo Renaming original hhc.exe...
ren "%ProgramFiles(x86)%\HTML Help Workshop\hhc.exe" hhc.bak.exe
echo Copying modified hhc.exe
copy .\hhc.exe "%ProgramFiles(x86)%\HTML Help Workshop\"
pause