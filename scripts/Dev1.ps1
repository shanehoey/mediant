
$BODY = GET-CONTENT .\configs\TEMP.CFG
$URI =  "HTTP://$MEDIANT/api/v1/files/ini"

$a = Invoke-WebRequest -URI $URI `
                  -Credential $credential `
                  -Method "get" `
                  -ContentType "application/octet-stream" 

$b = Invoke-WebRequest -URI $URI `
                  -Credential $credential `
                  -Method "get" `
                  -ContentType "application/json" 

$URI =  "HTTP://$MEDIANT/api/v1/files/ini/incremental"
$BODY
$filebin = [system.io.file]::ReadAllBytes(".\mediant\configs\TEMP.cfg")
$enc = [System.Text.Encoding]::GetEncoding("iso-8859-1")

Invoke-WebRequest -URI $URI `
                  -Credential $credential `
                  -Method "PUT" `
                  -ContentType "application/octet-stream" `
                  -body ([System.Text.Encoding]::UTF8.GetBytes($file))

Invoke-WebRequest -URI $URI `
                  -Credential $credential `
                  -Method "PUT" `
                  -ContentType "application/octet-stream" `
                  -body $enc.GetString($filebin) `
                  -verbose

return $webRequest=Invoke-WebRequest -Method PUT -InFile $LocalFile -Uri $URI -ContentType "multipart/form-data" -ErrorAction SilentlyContinue

$body       = @"
<SHOW SYSTEM UPTIME>
"@

return $a = Invoke-RestMethod -URI "HTTP://172.30.69.146/api/v1/files/cliScript/incremental" `
                  -Credential $credential `
                  -Method "PUT" `
                  -ContentType "application/octet-stream" `
                  -body $body `
                  -verbose

$body       = @"
SHOW SYSTEM UPTIME
"@

Invoke-WebRequest -URI "HTTP://172.30.69.146/api/v1/files/cliScript/incremental" `
                  -Credential $credential `
                  -ContentType "application/octet-stream" `
                  -Method "Put" `
                  -body $body `
                  -verbose

Invoke-RestMethod  -URI "HTTP://172.30.69.146/api/v1/files/cliScript/incremental" `
                  -Credential $credential `
                  -ContentType "application/octet-stream" `
                  -Method "Put" `
                  -body $body `
                  -verbose

$file = "C:\users\shane\GitHub\mediant\configs\TEMP.CFG"

Invoke-restmethod -URI "HTTP://172.30.69.146/api/v1/files/cliScript/incremental" `
                  -Credential $credential `
                  -Method Put `
                  -ContentType "application/octet-stream" `
                  -infile $file `
                  -verbose

