# start-escluster
Param
(
    $rg = 'estemplate-poc-rg'
)
# start-escluster
write-host "Starting all VMs in $rg..."
get-azurermvm -Status | Where-Object -Property ResourceGroupName -eq $rg | Start-AzureRmVM
# confirm final status
get-azurermvm -Status | Where-Object -Property ResourceGroupName -eq $rg