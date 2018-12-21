<# Install-AgentToWindows.ps1

This script installs the AlienVault agent on a Windows VM.
It contains a global script that was generated in the USM Anywhere portal
https://collabip.alienvault.cloud. See Data Sources>Agents>Deployment Scripts


Description
The script checks to see if the Agent is already installed as Windows service 'osqueryd'.
If service is not found, the Agent will install.

2 ways to run this script--

1. (Preferred) Run the script Install-AlienVault.ps1 with $InstallScript = 'Install-AgentToWindows.ps1'
2. Manually run script from the local PS console on any Windows VM

#>

# Capture osqueryd service for if statement to check if it's already installed
$service = get-service -name osqueryd -ErrorAction SilentlyContinue

# Install AlienVault
# If $service contains a value, the install will not run, else the install will run
if ($service) {
    Write-Host 'AlienVault Agent osqueryd is already installed'    
} else {
    Write-Host 'Installing AlienVault Agent'
    # Runline below generated at USM Anywhere portal.
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12; (new-object Net.WebClient).DownloadString("https://prod-api.agent.alienvault.cloud/osquery-api/us-west-2/bootstrap?flavor=powershell") | Invoke-Expression; install_agent -controlnodeid 91d63b61-4721-423e-91fe-cbda52cea0a0
}
