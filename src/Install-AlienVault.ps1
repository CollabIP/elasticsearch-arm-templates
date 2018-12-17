<#
To run script on remove Win VM, use the sample runline below.

Invoke-AzureRmVMRunCommand -ResourceGroupName 'tethrent-test-cu-es' -Name 'ctetcuwin16' -CommandId 'RunPowerShellScript' -ScriptPath 'Install-AlienVault.ps1'

#>

Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force