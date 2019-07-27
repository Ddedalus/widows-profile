function psobj_to_hashmap{
    param($obj)

    if ($obj.GetType().fullname -eq "System.Management.Automation.PSCustomObject") {
        $hash = @{}
        $keys = $obj | Get-Member -MemberType NoteProperty | Select-Object -exp Name
        foreach ($key in $keys) {
            $hash.add($key, (psobj_to_hashmap($obj.$($key))))
        }
        return $hash

    } elseif ($obj.GetType().fullname -eq "System.Object[]") {
        return $obj | ForEach-Object {
            psobj_to_hashmap($_)
        }
    } else {
        # $type = $obj.GetType().fullname
        # Write-Output "Unknown type: $type with $obj"
        return $obj
    }
}