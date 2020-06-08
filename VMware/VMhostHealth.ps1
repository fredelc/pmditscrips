function Get-VMHostSensorsInfo {
    [CmdletBinding()]
    param(
        [parameter(mandatory=$true)]
        [string[]]$VMHostName
#        [switch]$ExportToCSV
    )
     
        $OutArr = @()
        foreach($VMHost in $VMHostName) {
            Write-Verbose "Fetching data from $VMHost"
            try {
                $VMHostObj = Get-VMHost -Name $VMHost -EA Stop | Get-View
                $sensors = $VMHostObj.Runtime.HealthSystemRuntime.SystemHealthInfo.NumericSensorInfo
                foreach($sensor in $sensors){
                    $object = New-Object -TypeName PSObject -Property @{
                        VMHost = $VMHost
                        SensorName = $sensor.Name
                        Status = $sensor.HealthState.Key
                        CurrentReading = $sensor.CurrentReading 
                    } | Select-Object VMHost, SensorName, CurrentReading, Status
                    $OutArr += $object
                }
             } catch {
                $object = New-Object -TypeName PSObject -Property @{
                    VMHost = $VMHost
                    SensorName = "NA"
                    Status = "FailedToQuery"
                    CurrentReading = "FailedToQuery"
                } | Select-Object VMHost, SensorName, CurrentReading, Status
                $OutArr += $object
             }
     
        }
     
#        if($ExportToCSV) {
#           Write-Verbose "Exporting to c:\temp\sensorsinfo.csv"
#          $OutArr | export-csv c:\temp\sensorsinfo.csv -NoTypeInformation
#        } else {
#            return $OutArr
#        }
    }