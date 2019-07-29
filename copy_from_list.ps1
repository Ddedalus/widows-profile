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

Write-Host "Reading json file: $List"
$file = Get-Content -Path "$List" -Raw
$cfg =  ConvertFrom-Json -InputObject $file
$cfg = psobj_to_hashmap($cfg)

foreach ($item in $cfg) {
    $localPath = $item["local"]
    $storePath = $item["store"]
    if (-Not(Test-Path "$localPath")){
        Write-Host "Can't find local: $localPath"
        continue
    }
    if (-Not(Test-Path "$storePath")){
        Write-Host "Can't find store: $storePath"
        continue
    }

    # initialize exclude lists with empty lists which will evaluate to false if
    # asked for in an if statement anyway...
    if (-Not($item["exclude_file"])){
        $item["exclude_file"] =  @()
    }
    if (-Not($item["exclude_dir"])){
        $item["exclude_dir"] = @()
    }

    foreach ($glob in $item["dirs"]) {
        $e_file = $item["exclude_file"]
        $e_dir  = $item["exclude_dir"]
        if ($Load) {
            $fromPath = Join-Path $storePath $glob["path"]
            $toPath = Join-Path $localPath $glob["path"]
        } else {
            $toPath = Join-Path $storePath $glob["path"]
            $fromPath = Join-Path $localPath $glob["path"]
            if ($glob["exclude_file"]) {
                $e_file += @($glob["exclude_file"])
            }
            if ($glob["exclude_dir"]) {
                $e_dir += @($glob["exclude_dir"])
            }
        }
        Write-Host "Copying from $fromPath to $toPath"
        Write-Host "without [$e_file] and [$e_dir]"
        
        if (-Not(Test-Path "$fromPath")) {
            Write-Host "$fromPath not found!"
            continue
        }
        if ($glob["overwrite"]) {
            Remove-Item "$toPath" -Recurse -ErrorAction Ignore
        }
        if(-Not(Test-Path "$toPath")){
            New-Item "$toPath" -ItemType Directory
        }
        if ($Load) {
            robocopy "$fromPath" "$toPath" /mir /MT:4 /w:10 /r:3 /l /ns /nc /ndl
        } else {
            $ed = $e_dir | ForEach-Object {"$_"}
            $ef = $e_file | ForEach-Object {"$_"}
            robocopy "$fromPath" "$toPath" /xd $ed /xf $ef /MT:4 /w:10 /r:3 /l /ns /nc /ndl
        }
        Write-Host "$fromPath copied to $toPath"

    }
}

# foreach ($dir in $adSubdirs) {
#     $toPath = Join-Path $localPath "$dir"
#     $fromPath = Join-Path $storePath "$dir"
#     if (Test-Path "$fromPath") {
#         Remove-Item "$toPath" -Recurse -ErrorAction Ignore
#         if(-Not(Test-Path "$toPath")){
#             New-Item "$toPath" -ItemType Directory
#         }
#         robocopy "$fromPath" "$toPath" /mir
#         Write-Host "$fromPath copied to $toPath"
#     }else {
#         Write-Host "$fromPath not found!"
#     }
# }

#     Write-Host "Local: $($item["local"])"