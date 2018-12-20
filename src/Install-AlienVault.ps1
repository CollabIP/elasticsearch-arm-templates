<#
To run script, use Invoke-AzureRmVMRunCommand. Set in parameter -ScriptPath.

Invoke-AzureRmVMRunCommand -ResourceGroupName 'tethrent-test-cu-es' -Name 'ctetcuwin16' -CommandId 'RunPowerShellScript' -ScriptPath 'Install-AgentToWindows.ps1'

Invoke-AzureRmVMRunCommand -ResourceGroupName 'tethrent-test-cu-es2' -Name 'win16poc' -CommandId 'RunPowerShellScript' -ScriptPath 'Install-AlienVault.ps1'


Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force

To list OS type, see below. The osType property lives inside $_.StorageProfile.osDisk

get-azurermvm | Format-Table Name, @{l='osType';e={$_.StorageProfile.osDisk.osType}}, ResourceGroupName

or

get-azurermvm | where-Object {$_.StorageProfile.osDisk.osType -eq 'Windows'}


Must call the script with the 'Run Agent' global install command line

[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12; (new-object Net.WebClient).DownloadString("https://prod-api.agent.alienvault.cloud/osquery-api/us-west-2/bootstrap?flavor=powershell") | Invoke-Expression; install_agent -controlnodeid 91d63b61-4721-423e-91fe-cbda52cea0a0

#>
# Parameters section****************


# Function section*****************

# Command section*****************
$WinVMs = get-azurermvm | where-Object {$_.StorageProfile.osDisk.osType -eq 'Windows'}

foreach ($vm in $WinVMs)
    {Write-Host Run command on $vm.Name
    #Invoke-AzureRmVMRunCommand -ResourceGroupName 'tethrent-test-cu-es' -Name 'ctetcuwin16' -CommandId 'RunPowerShellScript' -ScriptPath 'Install-AgentToWindows.ps1'
    Invoke-AzureRmVMRunCommand -ResourceGroupName ($vm.ResourceGroupName) -Name ($vm.Name) -CommandId 'RunPowerShellScript' -ScriptPath 'Install-AgentToWindows.ps1'
}