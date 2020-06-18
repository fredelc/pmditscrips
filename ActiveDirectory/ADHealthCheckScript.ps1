$DiagInfo = dcdiag
$DCDiagResult = $Diaginfo | select-string -pattern '\. (.*) \b(passed|failed)\b test (.*)' | foreach {
    $obj = @{
        TestName   = $_.Matches.Groups[3].Value
        TestResult = $_.Matches.Groups[2].Value
        Entity     = $_.Matches.Groups[1].Value
    }
    [pscustomobject]$obj
}
 
$DCDiagStatus = foreach ($FailedResult in $DCDiagResult | Where-Object { $_.Testresult -ne "passed" }) {
    "DC diag test not succesfull on entity $($FailedResult.entity) - $($FailedResult.testname)"
}
if(!$DCDiagStatus){ $DCDiagStatus = "Healthy. No DCDiag Tests failed" }
 
$ReplicationSchedule = Get-ADReplicationSiteLink -filter *
$ReplicationSchedStatus = foreach ($Replication in $ReplicationSchedule) {
    if ($replication.ReplicationFrequencyInMinutes -gt 30) { "Potentional replication schedulde issue. $($Replication.name) has a replication schedulde of $($replication.ReplicationFrequencyInMinutes)" }
}
if (!$ReplicationSchedStatus) { $ReplicationSchedStatus = "Healthy - Replication Schedulde for all sites is lower than 30 minutes" }
 
$PasswordPolcy = Get-ADDefaultDomainPasswordPolicy
if ($PasswordPolcy.complexityEnabled -ne $true) { $PasswordComplexityHealthy = "Unhealthy - Password Complexity is disabled" }else {
    $PasswordComplexityHealthy = "Healthy - Password Complxity is enabled"
}
 
$ADRecycler = Get-ADOptionalFeature -Filter 'name -like "Recycle Bin Feature"'
if (!$ADRecycler.enabledscopes) { $ADRecyclerHealth = "Unhealthy. AD Recycle Bin Feature is disabled" } else { $ADRecyclerHealth = "Healthy - Recycle bin is enabled." }
 
$DCDiagStatus
$ReplicationSchedStatus
$PasswordComplexityHealthy
$ADRecyclerHealth