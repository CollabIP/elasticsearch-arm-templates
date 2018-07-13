<# test-estemplate.ps
Runs the test cmdlet only.  See output in start-estemplate.log

For details on how to configure for test and debug
 see https://blog.mexia.com.au/testing-arm-templates-with-pester

 TO DO:  Add support for Pester for better debugging. See URL above. Also see PS Invoke-Pester
#>
Param(
    # Enter node type. Options: master, data, or client
    [string]$nodetype,
    # Enter a unique VM id number, e.g., 1,2,3...
    [string]$vmid,
    # Enter the Availability Zone number, e.g., 1, 2, or 3
    [string]$zone,
    # Enter the Load Balancers type, i.e., internal or external
    [string]$LBtype,
    # Install Kibana if needed.
    [string]$kibanainstall = "No"
)

# Enable all debug output
$DebugPreference = "Continue"

$clusterParameters = @{
    "artifactsBaseUrl"="https://raw.githubusercontent.com/darrell-tethr/azure-marketplace/feature-deploy-single-node-type/src"
    "esVersion" = "6.2.1"
    "esClusterName" = "elasticsearch"
    "vNetNewOrExisting" = "existing"
    "vNetExistingResourceGroup" = "estemplate-poc-rg"
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
$output = Test-AzureRmResourceGroupDeployment `
    -ResourceGroupName "estemplate-poc-rg" `
    -TemplateUri "https://raw.githubusercontent.com/darrell-tethr/azure-marketplace/feature-deploy-single-node-type/src/mainTemplate.json" `
    -TemplateParameterObject $clusterParameters `
    -Verbose `
    5>&1

# Run the output for capture debug info
$output | out-file .\test-estemplate.log
