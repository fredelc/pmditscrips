Connect-AzAccount 

Select-AzSubscription -Subscription 7d89d978-559a-4f4a-8180-a8594cdd80db

Start-AzVirtualnetworkGatewayPacketCapture -ResourceGroupName "PMDZAN-RG" -Name "PMDZAN-VGW"
 
$storageAccount = Get-AzStorageAccount -ResourceGroupName "PMDZAN-RG" -Name "azcaptest"
 
$containerName = "azcaptestcontainer"
 
$key = Get-AzStorageAccountKey -ResourceGroupName "PMDZAN-RG" -Name "azcaptest"
 
$context = New-AzStorageContext -StorageAccountName "azcaptest" -StorageAccountKey $key[0].Value
 
$sasurl = New-AzStorageContainerSASToken -Name $containerName -Context $context -Permission "rwd" -StartTime (Get-Date).AddHours(-1) -ExpiryTime (Get-Date).AddDays(1) -Fulluri
 
Stop-AzVirtualNetworkGatewayPacketCapture -ResourceGroupName "PMDZAN-RG" -Name "PMDZAN-VGW" -SasUrl $sasurl


https://azcaptest.blob.core.windows.net/?sv=2019-10-10&ss=bfqt&srt=c&sp=rwdlacupx&se=2020-07-08T17:17:47Z&st=2020-07-08T09:17:47Z&spr=https&sig=eLeKWHdR%2B3UZ1WdS3Bjk%2BISfC28eShCgN1fA%2FQQq9%2Fk%3D


Start-AzVirtualNetworkGatewayConnectionPacketCapture -ResourceGroupName "PMDZAN-RG" -Name "PMDZAN-AZGW"

Stop-AzVirtualNetworkGatewayConnectionPacketCapture -ResourceGroupName "PMDZAN-RG" -Name "PMDZAN-AZGW" -SasUrl $sasurl