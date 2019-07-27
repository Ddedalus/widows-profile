$file = Get-Content -Path ".\copy_list.json" -Raw
$cfg =  ConvertFrom-Json -InputObject $file
foreach ($item in $cfg) {
    Write-Output "Local: $($item.local)"
}