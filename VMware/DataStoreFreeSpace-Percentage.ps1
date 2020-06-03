#*************************************************************************************************************
#      Script Name	:   DataStoreFreeSpace-Percentage.ps1
#      Purpose		:   Get the report of datastores which has less than 20% free space.
#				
#      Date		:   24-11-2016	# - Initial version
#                   	:  
#      Author		:   www.VMwareArena.com
#
#*************************************************************************************************************
#
If(!(Get-PSSnapin | Where {$_.Name -Eq "VMware.VimAutomation.Core"}))
{
	Add-PSSnapin VMware.VimAutomation.Core
}

$VCServer = 172.16.0.29
$vcUSERNAME = "administrator@vsphere.local"
$vcPassword = "Man4P@@s16"
$vccredential = New-Object System.Management.Automation.PSCredential ($vcusername, $vcPassword)


$LogFile = "DataStoreInfo_" + (Get-Date -UFormat "%d-%b-%Y-%H-%M") + ".csv" 

Write-Host "Connecting to $VCServer..." -Foregroundcolor "Yellow" -NoNewLine
$connection = Connect-VIServer -Server $VCServer -Cred $vccredential -ErrorAction SilentlyContinue -WarningAction 0 | Out-Null
If($? -Eq $True)

{
	Write-Host "Connected" -Foregroundcolor "Green" 
	$Results = @()
	$Result = Get-Datastore | Select @{N="DataStoreName";E={$_.Name}},@{N="Percentage Free Space(%)";E={[math]::Round(($_.FreeSpaceGB)/($_.CapacityGB)*100,2)}} | Where {$_."Percentage(<20%)" -le 20}
	$Result | Export-Csv -NoTypeInformation $LogFile
}
Else
{
	Write-Host "Error in Connecting to $VIServer; Try Again with correct user name & password!" -Foregroundcolor "Red" 
}
Disconnect-VIServer * -Confirm:$false
#
#-------------------------------------------------------------------------------------------------------------