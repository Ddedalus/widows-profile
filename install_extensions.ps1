Write-Host "Installing VS Code extensions"
$extensions = Get-Content -Path "H:\Windows\windows-profile\code_extensions.txt"
$codeExe = "H:\Windows\VSCode\bin\code"
$extTarget = "$env:userprofile\.vscode\extensions"
foreach ($ext in $extensions) {
    $target = Join-Path $extTarget "$ext"
    if (Test-Path -Path "$target*") {
        Write-Host "Found extension: $ext"
    }else {
        Write-Host "Target $target not found!"
        Write-Host "Installing extension $ext"
        & "$codeExe" --install-extension $ext
    }
    
}
