<#new-estemplate.ps

Deploys single ES node.

For now, manually edit these parameters for the $clusterParameters array as needed.

    Initial settings for first master creation VM: ctesdmaster-0

    "vNetNewOrExisting" = "new"
    "vNetExistingResourceGroup" = "estemplate-poc-rg"
    "loadBalancerType" = "internal"
    "nodeType" = "master"
    "vmId" = "0"
    "zoneId" = @("1")
    "kibana" = "Yes"

    Update values for second master creation VM: ctesdmaster-1

    "vNetNewOrExisting" = "existing"
    "vNetExistingResourceGroup" = "estemplate-poc-rg"
    "loadBalancerType" = "internal"
    "nodeType" = "master"
    "vmId" = "1"
    "zoneId" = @("2")
    "kibana" = "No"

#>
Param(
    # Configure for vNet. If you want a new vNet created, enter 'new'; otherwise, enter 'existing'
    [string]$vNetNewOrExist = 'existing',
    # Enter the Resource Group name
    [string]$rg = "estemplate-poc-rg",
    # Enter node type. Options: master, data, or client. NOTE- clients deploys as a Scale Set.
    [string]$nodetype,
    # Enter a unique VM id number, e.g., 1,2,3,
    [string]$vmid,
    # Enter the Availability Zone number, e.g., 1, 2, or 3. For Scale Sets, enter ss.
    [string]$zone,
    # Enter the Load Balancers type, i.e., internal or external.
    # Note: Only Scale Sets will be configured for Backend LB pool.
    [string]$LBtype ='external',
    # Install Kibana if needed.
    [string]$kibanainstall = "No"
)

# Enable all debug output
# $DebugPreference = "Continue"

$clusterParameters = @{
    "artifactsBaseUrl"="https://raw.githubusercontent.com/darrell-tethr/azure-marketplace/v6.3.1_feature-deploy-single-node-type/src"
    "esVersion" = "6.3.1"
    "esClusterName" = "elasticsearch"
    "vNetNewOrExisting" = "$vNetNewOrExist"
    "vNetExistingResourceGroup" = "$rg"
    "xpackPlugins" = "Yes"
    "loadBalancerType" = "$LBtype"
    "nodeType" = "$nodetype"
    "vmId" = "$vmid"
    "zoneId" = @("$zone")
    "kibana" = "$kibanainstall"
    "vmDataDiskCount" = 1
    "scaleSetInstanceCount" = "3"
    "vmHostNamePrefix" = "ctesd"
    "vmSizeMasterNodes" ="Standard_B2ms"
    "vmSizeDataNodes" = "Standard_B2ms"
    "vmSizeClientNodes" = "Standard_B2ms"
    "vmSizeIngestNodes" = "Standard_B2ms"
    "adminUsername" = "russ"
    "adminPassword" = "Password1234"
    "securityBootstrapPassword" = "Password123"
    "securityAdminPassword" = "Password123"
    "securityReadPassword" = "Password123"
    "securityKibanaPassword" = "Password123"
    "securityLogstashPassword" = "Password123"
}


# Capture all debug info in $output
# Note that 5>&1 is a PS redirector operator. Required for capturing the debug output.
$output = New-AzureRmResourceGroupDeployment `
    -ResourceGroupName "$rg" `
    -TemplateUri "https://raw.githubusercontent.com/darrell-tethr/azure-marketplace/v6.3.1_feature-deploy-single-node-type/src/mainTemplate.json" `
    -TemplateParameterObject $clusterParameters `
    -DeploymentDebugLogLevel All

# Run the output for capture debug info
$output | out-file .\logs\new-estemplate.log
