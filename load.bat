:: install GitKraken
START H:\Windows\GitKrakenSetup.exe

:: copy user files according to specification in copy_list.json
PowerShell  -NoProfile -ExecutionPolicy Bypass -File .\copy_from_list.ps1 copy_list.json -Load

:: install VSCode extensions locally (too big to copy reliably)
PowerShell -NoProfile -ExecutionPolicy Bypass -File H:\Windows\windows-profile\install_extensions.ps1

:: add registry keys preventing Windows from searching the web in the Start menu
reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search /f /v BingSearchEnabled /t REG_DWORD /d 0
reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search /f /v AllowSearchToUseLocation /t REG_DWORD /d 0
reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search /f /v CortanaConsent /t REG_DWORD /d 0