<#
Install-AlienVault.ps1

To run script, use Invoke-AzureRmVMRunCommand. Set in parameter -ScriptPath.

Invoke-AzureRmVMRunCommand -ResourceGroupName 'tethrent-test-cu-es' -Name 'ctetcuwin16' -CommandId 'RunPowerShellScript' -ScriptPath 'Install-AgentToWindows.ps1'

Must call the script with the 'Run Agent' global install command line

[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12; (new-object Net.WebClient).DownloadString("https://prod-api.agent.alienvault.cloud/osquery-api/us-west-2/bootstrap?flavor=powershell") | Invoke-Expression; install_agent -controlnodeid 91d63b61-4721-423e-91fe-cbda52cea0a0

#>
# Parameters section****************

Param(
[Parameter(Mandatory=$true, HelpMessage='Enter the Azure subscription name')]
[string]
$Subscription,
# Enter the PS script to call in -ScriptPath. File must live in same folder script.
[string]
$InstallScript = 'Install-AgentToWindows.ps1'
)

# Command section***************** 

# Set the Subscription context
Set-AzureRmContext $Subscription

# Get all Win VMs in the subscription
$WinVMs = Get-AzureRmVM | Where-Object {$_.StorageProfile.osDisk.osType -eq 'Windows'}

foreach ($vm in $WinVMs){
    Write-Host Running the Agent install script on $vm.Name -ForegroundColor Green
    Invoke-AzureRmVMRunCommand -ResourceGroupName ($vm.ResourceGroupName) -Name ($vm.Name) -CommandId 'RunPowerShellScript' -ScriptPath $InstallScript
    Write-Host Script run on $vm.Name complete -ForegroundColor Green
}