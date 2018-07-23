# stop-escluster.ps1
# Specify the RG name
Param
(
    $rg
)
# stop-escluster
write-host "stoping all VMs in $rg"
get-azurermvm -Status | Where-Object -Property ResourceGroupName -eq $rg | stop-AzureRmVM
# confirm final status
get-azurermvm -Status | Where-Object -Property ResourceGroupName -eq $rg