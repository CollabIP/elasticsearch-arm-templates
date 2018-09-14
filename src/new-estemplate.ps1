<#new-estemplate.ps

Deploys and upgrades the Elasticsearch node.

For Master and Data Nodes - Deploys single ES node to a specific Availability Zone.
For Client and Ingest Nodes - Deploys a VM Scale Set. By d

Example: Sample values for first master creation VM: ctesdmaster-0

#>
Param(
    # Enter the Github base URL
    [string]$sourceUrl = 'https://raw.githubusercontent.com/darrell-tethr/azure-marketplace/v6.3.1_feature-deploy-single-node-type/src',
    # Enter the Elasticsearch version to be deployed. 
    [string]$esVersion = '6.4.0',
    # Configure for vNet. If you want a new vNet created, enter 'new'; otherwise, enter 'existing'
    [string]$vNetNewOrExist = 'existing',
    # Enter Resource Group name.
    [string]$rg = 'estemplate-poc-rg',
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
    "vNetExistingResourceGroup" = "$rg"
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
