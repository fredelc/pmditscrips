foreach($esx in Get-VMHost -Name 172.16.0.19){

    $hs = Get-View -Id $esx.ExtensionData.ConfigManager.HealthStatusSystem

    $hs.Runtime.SystemHealthInfo.NumericSensorInfo |

    Select @{N='Host';E={$esx.Name}},Name,@{N='Health';E={$_.HealthState.Label}},Rollup

}