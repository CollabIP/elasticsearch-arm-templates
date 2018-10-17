<# test-estemplate.ps
Tests the Tethr custom ARM Templates for Elasticsearch nodes.
  Runs Azure Test-AzureRmResourceGroupDeployment to validate the templates.
  See output in start-estemplate.log

For more details on how to configure for test and debug
 See https://blog.mexia.com.au/testing-arm-templates-with-pester
 Add support for Pester for better debugging. See URL above. Also see PS Invoke-Pester

IMPORTANT! Before running, note there are two parameter sections - Powershell and Cluster

  Powershell script parameters

    - Allows custom param values to be entered when running this script.

        Example: .\new-estemplate.ps1 -nodetype master -vmid 0 -zone 1 -esversion 6.4.0 -rg estemplate-poc-rg
    
    - Includes common default values. These can be overridden at runtime if desired.

  
  Cluster parameters

    These values are either hardcoded or replaced by the Powershell parameter values.
    Ensure that hardcoded values are properly set
    
    IMPORTANT!  Note case-sensitivity.

    Sample of actual values for first master creation VM: ctesdmaster-0

    "vNetNewOrExisting" = "new"
    "vNetExistingResourceGroup" = "estemplate-poc-rg"
    "loadBalancerType" = "internal"
    "nodeType" = "master"
    "vmId" = "0"
    "zoneId" = @("1")
    "kibana" = "No"

    Sample of actual values for second master creation VM: ctesdmaster-1

    "vNetNewOrExisting" = "existing"
    "vNetExistingResourceGroup" = "estemplate-poc-rg"
    "loadBalancerType" = "internal"
    "nodeType" = "master"
    "vmId" = "1"
    "zoneId" = @("2")
    "kibana" = "No"
#>

# Powershell parameters section
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
$DebugPreference = "Continue"

# Cluster parameters section
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
    "vmHostNamePrefix" = "ctedeu2d01"
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
$output = Test-AzureRmResourceGroupDeployment `
    -ResourceGroupName "$rg" `
    -TemplateUri "$sourceUrl/mainTemplate.json" `
    -TemplateParameterObject $clusterParameters `
    -Verbose `
    5>&1

# Run the output for capture debug info
$output | out-file .\logs\test-estemplate.log
