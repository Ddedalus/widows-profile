Param
(
    [String]$AppName,
    [String]$Computername = $env:COMPUTERNAME,
    [String][ValidateSet("Install","Uninstall")]$Method = 'Install'
)

# filter for application reference by its name
$Application = (Get-CimInstance -Namespace "ROOT\ccm\ClientSDK" -ClassName CCM_Application | Where-Object {$_.Name -like $AppName})

# prepare arguments for Software Center
$Args = @{EnforcePreference = [UINT32] 0
Id = "$($Application.Id)"
IsMachineTarget = $Application.IsMachineTarget
IsRebootIfNeeded = $False
Priority = 'High'
Revision = "$($Application.Revision)" } 

# Create a Software Center job to install the app
Invoke-CimMethod -Namespace "ROOT\ccm\ClientSDK" -ClassName CCM_Application -MethodName $Method -Arguments $Args
