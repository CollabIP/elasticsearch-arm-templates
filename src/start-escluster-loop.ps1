# start-escluster
Param
(
    $rg = 'estemplate-poc-rg'
)
# start-escluster
write-host "Starting all VMs in $rg..."
$vms = get-azurermvm -Status | Where-Object -Property ResourceGroupName -eq $rg
    foreach ($vm in $vms)
    { Start-Job -ScriptBlock {Start-AzureRmVM}
    }



# confirm final status
get-azurermvm -Status | Where-Object -Property ResourceGroupName -eq $rg