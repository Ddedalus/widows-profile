param (
    [string]$List = ".\copy_list.json",
    [switch]$Load = $false,
    [switch]$Store = $false
    # [string]$password = $( Read-Host "Input password, please" )
    )
    
. .\json_converter.ps1

if ( -Not($Load -Or $Store) -Or ($Load -And $Store) ) {
    throw "Please provide EITHER -Load or -Store"
}

Write-Output "Reading json file: $List"
$file = Get-Content -Path "$List" -Raw
$cfg =  ConvertFrom-Json -InputObject $file
$cfg = psobj_to_hashmap($cfg)

foreach ($item in $cfg) {
    $localPath = $item["local"]
    $storePath = $item["store"]
    if (-Not(Test-Path "$localPath")){
        Write-Output "Can't find local: $localPath"
        continue
    }
    if (-Not(Test-Path "$storePath")){
        Write-Output "Can't find store: $storePath"
        continue
    }

    # initialize exclude lists with empty lists which will evaluate to false if
    # asked for in an if statement anyway...
    if (-Not($item["exclude_file"])) {
        $item["exclude_file"] =  @()
    }
    if (-Not($item["exclude_dir"])) {
        $item["exclude_dir"] = @()
    }

    foreach ($glob in $item["dirs"]) {
        $e_file = $item["exclude_file"]
        $e_dir  = $item["exclude_item"]
        if ($Load) {
            $fromPath = Join-Path $storePath $glob["path"]
            $toPath = Join-Path $localPath $glob["path"]
        } else {
            $toPath = Join-Path $storePath $glob["path"]
            $fromPath = Join-Path $localPath $glob["path"]
            if ($glob["exclude_file"]) {
                $e_file += $glob["exclude_file"]
            }
            if ($glob["exclude_dir"]) {
                $e_dir += $glob["exclude_dir"]
            }
        }
        Write-Output "Copying from $fromPath to $toPath"
        Write-Output "without [$($e_file -join ', ')] and [$e_dir]"
        
        # if (Test-Path "$fromDir") {
        #         Remove-Item "$toDir" -Recurse -ErrorAction Ignore
        #     if(-Not(Test-Path "$toDir")){
        #         New-Item "$toDir" -ItemType Directory
        #     }
        #     robocopy "$fromDir" "$toDir" /mir
        #     Write-Output "$fromDir copied to $toDir"
        # }else {
        #     Write-Output "$fromDir not found!"
        # }

    }
}

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

#     Write-Output "Local: $($item["local"])"