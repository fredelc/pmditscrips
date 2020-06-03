$allvms = @()

$allhosts = @()

$hosts = Get-VMHost

$vms = Get-Vm

foreach($vmHost in $hosts){

$hoststat = "" | Select HostName, MemMax, MemAvg, MemMin, CPUMax, CPUAvg, CPUMin

$hoststat.HostName = $vmHost.name

$statcpu = Get-Stat -Entity ($vmHost)-start (get-date).AddDays(-30) -Finish (Get-Date)-MaxSamples 10000 -stat cpu.usage.average

$statmem = Get-Stat -Entity ($vmHost)-start (get-date).AddDays(-30) -Finish (Get-Date)-MaxSamples 10000 -stat mem.usage.average



$cpu = $statcpu | Measure-Object -Property value -Average -Maximum -Minimum

$mem = $statmem | Measure-Object -Property value -Average -Maximum -Minimum



$hoststat.CPUMax = $cpu.Maximum

$hoststat.CPUAvg = $cpu.Average

$hoststat.CPUMin = $cpu.Minimum

$hoststat.MemMax = $mem.Maximu

$hoststat.MemAvg = $mem.Average

$hoststat.MemMin = $mem.Minimum

$allhosts += $hoststat

}

$allhosts | Select HostName, MemMax, MemAvg, MemMin, CPUMax, CPUAvg, CPUMin | Export-Csv "c:\Hosts.csv" –noTypeInformation