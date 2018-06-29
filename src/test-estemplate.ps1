<# test-estemplate.ps
Runs the test cmdlet only.  See output in start-estemplate.log

For details on how to configure for test and debug
 see https://blog.mexia.com.au/testing-arm-templates-with-pester

 TO DO:  Add support for Pester for better debugging. See URL above. Also see PS Invoke-Pester
#>

# Enable all debug output
$DebugPreference = "Continue"

$clusterParameters = @{
    "artifactsBaseUrl"="https://raw.githubusercontent.com/darrell-tethr/azure-marketplace/feature-deploy-single-node-type/src"
    "esVersion" = "6.2.1"
    "esClusterName" = "elasticsearch"
    "vNetNewOrExisting" = "existing"
    "vNetExistingResourceGroup" = "estemplate-poc-rg2"
    "loadBalancerType" = "internal"
    "nodeType" = "master"
    "vmId" = "2"
    "zoneId" = @("2")
    "vmDataDiskCount" = 1
    "vmHostNamePrefix" = "ctesd"
    "adminUsername" = "russ"
    "adminPassword" = "Password1234"
    "securityAdminPassword" = "Password123"
    "securityReadPassword" = "Password123"
    "securityKibanaPassword" = "Password123"
    "securityLogstashPassword" = "Password123"
    "kibana" = "No"
}


# Capture all debug info in $output
# Note that 5>&1 is a PS redirector operator. Required for capturing the debug output.
$output = Test-AzureRmResourceGroupDeployment `
    -ResourceGroupName "estemplate-poc-rg2" `
    -TemplateUri "https://raw.githubusercontent.com/darrell-tethr/azure-marketplace/feature-deploy-single-node-type/src/mainTemplate.json" `
    -TemplateParameterObject $clusterParameters `
    -Verbose `
    5>&1

# Run the output for capture debug info
$output | out-file .\test-estemplate.log
