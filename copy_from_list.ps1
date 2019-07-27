param (
    [string]$List = ".\copy_list.json",
    [switch]$Load = $false,
    [switch]$Store = $false
    # [string]$password = $( Read-Host "Input password, please" )
 )

if ( -Not($Load -Or $Store) -Or ($Load -And $Store) ) {
    throw "Please provide EITHER -Load or -Store"
}

Write-Output "Reading json file: $List"
$file = Get-Content -Path "$List" -Raw
$cfg =  ConvertFrom-Json -InputObject $file

# foreach ($item in $cfg) {
#     $localPath = $item.local
#     $storePath = $item.store
#     if (-Not(Test-Path "$localPath")){
#         Write-Output "Can't find local: $localPath"
#         continue
#     }
#     if (-Not(Test-Path "$storePath")){
#         Write-Output "Can't find store: $storePath"
#         continue
#     }

#     foreach ($glob in $item.dirs) {
#         $fromPath = Join-Path $storePath "$($glob.path)"
#         $toPath = Join-Path $localPath "$($glob.path)"
#         Write-Output "Copying from $fromPath to $toPath"
#     }
# }

# foreach ($dir in $adSubdirs) {
#     $toDir = Join-Path $localPath "$dir"
#     $fromDir = Join-Path $storePath "$dir"
#     if (Test-Path "$fromDir") {
#         Remove-Item "$toDir" -Recurse -ErrorAction Ignore
#         if(-Not(Test-Path "$toDir")){
#             New-Item "$toDir" -ItemType Directory
#         }
#         robocopy "$fromDir" "$toDir" /mir
#         Write-Output "$fromDir copied to $toDir"
#     }else {
#         Write-Output "$fromDir not found!"
#     }
# }

#     Write-Output "Local: $($item.local)"