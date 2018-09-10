<# Load-TestData.ps1

# Load test data into ES cluster

To run...

1. Copy this PS script into your local Documents folder in Windows.
2. Run script from PS.

    .\Load-TestData.ps1

#>
param(
    [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
    $username,
    
    [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=1)]
    $password
)
write-host 'Download shakesspeare_6.0.json data from ES website into user Download folder'
invoke-webrequest https://download.elastic.co/demos/kibana/gettingstarted/shakespeare_6.0.json -outfile "~\downloads\shakesspeare_6.0.json"

write-host 'Load shakesspeare_6.0.json data into ES cluster'
cd C:\Users\tethradmin\Downloads
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $username,$password)))
$logoutput = Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} "http://10.0.0.4:9200/shakespeare/doc/_bulk?pretty" -Method Post -ContentType 'application/x-ndjson' -InFile "C:\Users\tethradmin\Downloads\shakespeare_6.0.json"
$logoutput
cd C:\Users\tethradmin\Documents