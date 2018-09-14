<#new-estemplate.ps
Deploys or upgrades the Elasticsearch cluster nodes.
See Github repo Wiki for full deploy instructions.

For Master and Data Nodes - Deploys a single ES node to a specific Availability Zone.
For Client and Ingest Nodes - Deploys a VM Scale Set. 3 nodes total. 1 node to each Availability Zone 1, 2, and 3.

IMPORTANT! Before initial deployment

    The targeted Azure Resource Group must pre-exist.
    Determine if new or existing vNet
    Verify all parameter default values below are correct


Sample deploy command lines

Master nodes
For upgrades, define the new -esversion

.\new-estemplate.ps1 -vNetNewOrExist new -nodetype master -vmid 0 -zone 1 -esversion 6.3.1 -rg estemplate-poc-rg; `
.\new-estemplate.ps1 -nodetype master -vmid 1 -zone 2 -esversion 6.3.1 -rg estemplate-poc-rg; `
.\new-estemplate.ps1 -nodetype master -vmid 2 -zone 3 -esversion 6.3.1 -rg estemplate-poc-rg


Data nodes
Kibana should be installed during at least 1 data node deploy.
For upgrades, define the new -esversion. Note: Upgrades to Kibana must be done manually.

.\new-estemplate.ps1 -nodetype data -vmid 0 -zone 1  -esversion 6.3.1 -rg estemplate-poc-rg; `
.\new-estemplate.ps1 -nodetype data -vmid 1  -zone 2 -esversion 6.3.1 -rg estemplate-poc-rg; `
.\new-estemplate.ps1 -nodetype data -vmid 2 -zone 3 -esversion 6.3.1 -rg estemplate-poc-rg -kibanainstall Yes


Client nodes
Deploys as VM Scale Set. 3 nodes total. 1 node to each Zone (1, 2, and 3).
Autoscaling is not enabled. Must enable manually in Azure Portal after deploy completes
For upgrades, define the new -esversion

.\new-estemplate.ps1 -nodetype client -vmid ss -zone 1 -esversion 6.3.1 -rg estemplate-poc-rg


Ingest nodes
Deploys as VM Scale Set. 3 nodes total. 1 node to each Zones (1, 2, and 3).
Autoscaling is not enabled. Must enable manually in Azure Portal after deploy completes
For upgrades, define the new -esversion

.\new-estemplate.ps1 -nodetype ingest -vmid ss -zone 1 -esversion 6.3.1 -rg estemplate-poc-rg

#>
Param(
    # Enter the Github base URL
    [string]$sourceUrl = 'https://raw.githubusercontent.com/darrell-tethr/azure-marketplace/v6.3.1_feature-deploy-single-node-type/src',
    # Enter the Elasticsearch version to be deployed. 
    [string]$esVersion = '6.4.0',
    # Configure for new or existing vNet. An existing Virtual Network in another Resource Group in the same Location can be used.
    [string]$vNetNewOrExist = 'existing',
    # Enter the vNetName. The Virtual Network must already exist when using an 'existing' Virtual Network
    [string]$vNetName = 'es-net',
    # Enter the name of the Resource Group in which the Virtual Network resides when using an 'existing' Virtual Network. Required when using an 'existing' Virtual Network
    [string]$rg = 'estemplate-poc-rg',
    # Enter the internal static IP address to use when configuring the internal load balancer
    [string]$vNetLoadBalancerIp = '10.0.0.4',
    # The name of the subnet to which Elasticsearch nodes will be attached. The subnet must already exist when using an existing Virtual Network.
    [string]$vNetClusterSubnetName = 'es-subnet',
    # Enter Ubuntu admin user
    [string]$ubuntuAdmin = 'russ',
    # Enter Ubuntu admin password
    [string]$ubuntuPw = 'Password1234',
    # Enter the password for Elasticsearch superuser 'elastic'
    [string]$esPw = 'Password123',
    # Enter node type. Options: master, data, or client
    [string]$nodetype,
    # Enter a unique VM id number, e.g., 1,2,3. For Scale Sets, enter ss for ID purposes.
    [string]$vmid,
    # Enter the Availability Zone number, e.g., 1, 2, or 3. Note: Scale Sets automatically deploy to all 3 zones.
    [string]$zone,
    # Enter the Load Balancers type, i.e., internal or external.
    # Note: Only scale sets will be configured for Backend LB pool.
    [string]$LBtype ='external',
    # Install Kibana if needed. IMPORTANT! Do not install with Master Node deploys. Options: Yes, No
    [string]$kibanainstall = "No"
)

# Enable all debug output
# $DebugPreference = "Continue"

$clusterParameters = @{
    "artifactsBaseUrl"="$sourceUrl"
    "esVersion" = "$esVersion"
    "esClusterName" = "elasticsearch"
    "vNetNewOrExisting" = "$vNetNewOrExist"
    "vNetName" = "$vNetName"
    "vNetExistingResourceGroup" = "$rg"
    "vNetLoadBalancerIp" = "$vNetLoadBalancerIp"
    "vNetClusterSubnetName" = "$vNetClusterSubnetName"
    "xpackPlugins" = "Yes"
    "loadBalancerType" = "$LBtype"
    "nodeType" = "$nodetype"
    "vmId" = "$vmid"
    "zoneId" = @("$zone")
    "kibana" = "$kibanainstall"
    "vmDataDiskCount" = 5
    "scaleSetInstanceCount" = "3"
    "vmHostNamePrefix" = "ctesd"
    "vmSizeMasterNodes" ="Standard_DS1_v2"
    "vmSizeDataNodes" = "Standard_DS1_v2"
    "vmSizeClientNodes" = "Standard_DS1_v2"
    "vmSizeIngestNodes" = "Standard_DS1_v2"
    "adminUsername" = "$ubuntuAdmin"
    "adminPassword" = "$ubuntuPw"
    "securityBootstrapPassword" = "$esPw"
    "securityAdminPassword" = "$esPw"
    "securityReadPassword" = "$esPw"
    "securityKibanaPassword" = "$esPw"
    "securityLogstashPassword" = "$esPw"
    }
# Capture all debug info in $output
# Note that 5>&1 is a PS redirector operator. Required for capturing the debug output.
$output = New-AzureRmResourceGroupDeployment `
    -ResourceGroupName "$rg" `
    -TemplateUri "$sourceUrl/mainTemplate.json" `
    -TemplateParameterObject $clusterParameters `
    -DeploymentDebugLogLevel All `
    -Verbose

# Run the output for capture debug info
$output | out-file .\logs\new-estemplate.log
