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
    # Enter node type. Options: master, data, or client
    [string]$nodetype,
    # Enter a unique VM id number, e.g., 1,2,3...
    [string]$vmid,
    # Enter the Availability Zone number, e.g., 1, 2, or 3
    [string]$zone,
    # Enter the Load Balancers type, i.e., internal or external.
    # Note: Only Client Node deploys will install/configure the LB.
    [string]$LBtype ='external',
    # Install Kibana if needed.
    [string]$kibanainstall = "No"
)

# Enable all debug output
# $DebugPreference = "Continue"

$clusterParameters = @{
    "artifactsBaseUrl"="https://raw.githubusercontent.com/darrell-tethr/azure-marketplace/feature-deploy-single-node-type/src"
    "esVersion" = "6.2.4"
    "esClusterName" = "elasticsearch"
    "vNetNewOrExisting" = "new"
    "vNetExistingResourceGroup" = "estemplate-poc-rg2"
    "loadBalancerType" = "$LBtype"
    "nodeType" = "$nodetype"
    "vmId" = "$vmid"
    "zoneId" = @("$zone")
    "kibana" = "$kibanainstall"
    "vmDataDiskCount" = 1
    "vmHostNamePrefix" = "ctesd"
    "adminUsername" = "russ"
    "adminPassword" = "Password1234"
    "securityAdminPassword" = "Password123"
    "securityReadPassword" = "Password123"
    "securityKibanaPassword" = "Password123"
    "securityLogstashPassword" = "Password123"
}


# Capture all debug info in $output
# Note that 5>&1 is a PS redirector operator. Required for capturing the debug output.
$output = New-AzureRmResourceGroupDeployment `
    -ResourceGroupName "estemplate-poc-rg2" `
    -TemplateUri "https://raw.githubusercontent.com/darrell-tethr/azure-marketplace/feature-deploy-single-node-type/src/mainTemplate.json" `
    -TemplateParameterObject $clusterParameters `
    -DeploymentDebugLogLevel All

# Run the output for capture debug info
$output | out-file .\logs\new-estemplate.log
