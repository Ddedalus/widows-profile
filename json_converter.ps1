function psobj_to_hashmap{
    param($obj)

    if ($obj.GetType().fullname -eq "System.Management.Automation.PSCustomObject") {
        $hash = @{}
        $keys = $obj | Get-Member -MemberType NoteProperty | Select-Object -exp Name
        foreach ($key in $keys) {
            $res = psobj_to_hashmap($obj.$($key))
            $hash.add($key, $res)
        }
        return $hash

    } elseif ($obj -is [array]) {
        $ret = @()
        foreach ($item in $obj) {
            $ret += (psobj_to_hashmap($item))
        }
        return Write-Output $ret -NoEnumerate
        # this forces array return and hence prevents PS weird unwrapping
    } else {
        # $type = $obj.GetType().fullname
        # Write-Host "Unknown type: $type with $obj"
        return $obj
    }
}

# $file = Get-Content -Path "copy_list.json" -Raw
# $cfg_obj =  ConvertFrom-Json -InputObject $file
# $cfg = psobj_to_hashmap($cfg_obj)
# Write-Host $cfg[0]