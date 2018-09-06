<# Load-TestData.ps1

# Load test data into ES cluster

To run...

Download shakespeare_6.0.json file from https://www.elastic.co/guide/en/kibana/6.x/tutorial-load-dataset.html

Save file in C:\Users\tethradmin\Downloads\shakespeare_6.0.json"

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
write-host 'Download shakesspeare_6.0.json data from ES website'
invoke-webrequest https://download.elastic.co/demos/kibana/gettingstarted/shakespeare_6.0.json

write-host 'Load shakesspeare_6.0.json data into ES cluster'
cd C:\Users\tethradmin\Downloads
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $username,$password)))
$logoutput = Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} "http://10.0.0.4:9200/shakespeare/doc/_bulk?pretty" -Method Post -ContentType 'application/x-ndjson' -InFile "C:\Users\tethradmin\Downloads\shakespeare_6.0.json"
$logoutput
cd C:\Users\tethradmin\Documents