Write-Output "Installing VS Code extensions"
$extensions = Get-Content -Path "H:\Windows\scripts\code_extensions.txt"
$codeExe = "H:\Windows\VSCode\bin\code"
$extTarget = "$env:userprofile\.vscode\extensions"
foreach ($ext in $extensions) {
    $target = Join-Path $extTarget "$ext"
    if (Test-Path -Path "$target*") {
        Write-Output "Found extension: $ext"
    }else {
        Write-Output "Target $target not found!"
        Write-Output "Installing extension $ext"
        & "$codeExe" --install-extension $ext
    }
    
}
