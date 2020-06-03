
Function Get-HostMemory {
<#
.SYNOPSIS
   Queries VMware for several memory related stats for hosts.
.PARAMETER Refresh
   Refreshes Stats every 15 seconds
.PARAMETER Hostname
	Acquires Stats for specific hosts
.EXAMPLE 
	Get-HostMemory -refresh
.EXAMPLE
	get-hostmemory -hostname myhost
.EXAMPLE
	Get-HostMemory
.Notes
====================================================================
	Author:
	Conrad Ramos <conrad@vnoob.com> http://www.vnoob.com/

	Date:			2012-11-15
	Revision: 		1.0
====================================================================
#>


param([switch]$refresh,$hostname="*")



$vmhosts=Get-vmhost $hostname

Function get-memory{
	$output=@()
	ForEach($vmhost in $vmhosts)
		{
	$stat=get-stat -entity $vmhost -stat mem* -realtime
		$Objects = New-Object PSObject -Property ([ordered]@{            
		Name=$vmhost.name
		TotalGB="{0:N2}" -f ($vmhost.memorytotalGB)
		GrantedGB=$granted="{0:N2}" -f (($stat |Where-Object{$_.metricid -like  "mem.granted.average"}|select -expand value -first 1)/1MB)
		ConsumedGB="{0:N2}" -f (($stat |Where-Object{$_.metricid -like "mem.consumed.average"}|select -expand value -first 1)/1MB)
		ActiveGB=$active="{0:N4}" -f (($stat |Where-Object{$_.metricid -like "mem.active.average"}|select -expand value -first 1)/1MB)
		Usage ="{0:P0}" -f (($stat |Where-Object{$_.metricid -like "mem.usage.average"} |select -expan value -first 1)/100)
		})   
		$objects|add-member –MemberType NoteProperty -Name UsageActive -value ("{0:P0}" -f ($active/$granted))
		$output+= $objects	
		}
		$output | Format-table -auto
	}
	
	IF ($refresh)
	{
	while(0 -ne 1)
	{get-memory
	sleep 15}
	}
	Else {Get-memory}
	
}