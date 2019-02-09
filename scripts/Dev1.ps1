
$mediant = "sbc1.aclearning.com.au"
$body = GET-CONTENT .\configs\dailycheck.cli
$uri =  "HTTP://$MEDIANT/api/v1/files/ini"
$password  =  "password" | ConvertTo-SecureString -AsPlainText -Force

Invoke-WebRequest -URI $URI `
                  -Credential $credential `
                  -Method "get" `
                  -ContentType "application/octet-stream" 


$FilePath = ".\mediant\configs\dailycheck.cli"
$URL = "HTTP://$mediant/api/v1/files/ini/incremental"

$fileBytes = [System.IO.File]::ReadAllBytes($FilePath);
$fileEnc = [System.Text.Encoding]::GetEncoding('UTF-8').GetString($fileBytes)
$boundary = [System.Guid]::NewGuid().ToString()
$LF = "`r`n"

$bodyLines = ( 
    "--$boundary",
    "Content-Disposition: form-data; name=`"file`"; filename=`"temp.txt`"",
    "Content-Type: application/octet-stream$LF",
    $fileEnc,
    "--$boundary--$LF" 
) -join $LF

$bodyLines = ( 
    "--$boundary",
    "Content-Disposition: form-data; name=`"file`"; filename=`"temp.txt`"",
    "Content-Type: application/octet-stream$LF",
    $fileEnc,
    "--$boundary--$LF" 
) -join $LF

Invoke-RestMethod -Uri $URL -Method Put -ContentType "multipart/form-data; boundary=`"$boundary`"" -Body $bodyLine -Credential $credential




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

