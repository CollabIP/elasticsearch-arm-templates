<# Install-AgentToWindows.ps1

The runline below was created in USM Anywhere.
It's a global command that can be run on any Azure VM

#>
# Demo only.  For testing scripts
#Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force

# Capture osqueryd service for if statement to check if it's alraedy installed
$service = get-service -name osquery -ErrorAction SilentlyContinue

# Install AlienVault
# If $service is empty, the install script will run.
if ($service ) {
    Write-Host 'AlienVault Agent osqueryd is already installed'    
} else {
    Write-Host 'Installing AlienVault Agent'
    #Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force
    #Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12; (new-object Net.WebClient).DownloadString("https://prod-api.agent.alienvault.cloud/osquery-api/us-west-2/bootstrap?flavor=powershell") | Invoke-Expression; install_agent -controlnodeid 91d63b61-4721-423e-91fe-cbda52cea0a0
}
