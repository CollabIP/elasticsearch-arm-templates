<# New-ESClusterMasterNodes.ps1

Deploys 3 ES Master nodes to all 3 Availability Zones

#>
Write-Host 'Deploying 3 ES Master nodes...'
.\new-estemplate.ps1 -vNetNewOrExist new -rg estemplate-poc-rg2 nodetype master -vmid 0 -zone 1
.\new-estemplate.ps1 -rg estemplate-poc-rg2 -nodetype master -vmid 1 -zone 2
.\new-estemplate.ps1 -rg estemplate-poc-rg2 -nodetype master -vmid 2 -zone 3


