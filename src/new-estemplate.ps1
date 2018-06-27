<#new-estemplate.ps

Deploys single ES node.

#>

# Enable all debug output
# $DebugPreference = "Continue"

$clusterParameters = @{
    "artifactsBaseUrl"="https://raw.githubusercontent.com/darrell-tethr/azure-marketplace/feature-deploy-single-node-type/src"
    "esVersion" = "6.2.1"
    "esClusterName" = "elasticsearch"
    "vNetNewOrExisting" = "existing"
    "loadBalancerType" = "internal"
    "nodeType" = "master"
    "vmId" = "2"
    # zones must be defined as an array for the virtual machines resource
    "zoneId" = @("2")
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
    -ResourceGroupName "estemplate-poc-rg" `
    -TemplateUri "https://raw.githubusercontent.com/darrell-tethr/azure-marketplace/feature-deploy-single-node-type/src/mainTemplate.json" `
    -TemplateParameterObject $clusterParameters `
    -DeploymentDebugLogLevel All

# Run the output for capture debug info
$output | out-file .\new-estemplate.log
