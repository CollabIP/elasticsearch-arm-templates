# start-escluster
get-azurermvm -Status | Where-Object -Property ResourceGroupName -eq estemplate-poc-rg | Start-AzureRmVM
# confirm final status
get-azurermvm -Status | Where-Object -Property ResourceGroupName -eq estemplate-poc-rg 