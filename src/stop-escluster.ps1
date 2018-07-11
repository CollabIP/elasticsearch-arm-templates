# stop-escluster
get-azurermvm -Status | Where-Object -Property ResourceGroupName -eq estemplate-poc-rg | Stop-AzureRmVM -Force
# confirm final status
get-azurermvm -Status | Where-Object -Property ResourceGroupName -eq estemplate-poc-rg