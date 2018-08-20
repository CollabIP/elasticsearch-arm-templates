# start-escluster
Param
(
    $rg = 'estemplate-poc-rg'
)
# start-escluster
write-host "Starting all VMs in $rg..."
get-azurermvm -Status | Where-Object -Property ResourceGroupName -eq $rg | Start-AzureRmVM
write-host "Starting all VM Scale Sets in $rg..."
get-azurermvmss | Where-Object -Property ResourceGroupName -eq $rg | Start-AzureRmVmss
# confirm final status
get-azurermvm -status | Where-Object -Property ResourceGroupName -eq $rg | Format-Table
get-azurermvmss | Where-Object -Property ResourceGroupName -eq $rg | Format-Table