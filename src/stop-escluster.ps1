# stop-escluster.ps1
# Specify the RG name
Param
(
    $rg = 'estemplate-poc-rg'
)
# stop-escluster
write-host "Stopping all VMs in $rg..."
get-azurermvm -Status | Where-Object -Property ResourceGroupName -eq $rg | stop-AzureRmVM -Force
# confirm final status
get-azurermvm -Status | Where-Object -Property ResourceGroupName -eq $rg