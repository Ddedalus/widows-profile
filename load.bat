START H:\Windows\GitKrakenSetup.exe
PowerShell  -NoProfile -ExecutionPolicy Bypass -File .\copy_from_list.ps1 copy_list.json -Load
PowerShell -NoProfile -ExecutionPolicy Bypass -File H:\Windows\windows-profile\install_extensions.ps1
