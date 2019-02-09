import-module .\mediant\mediant.psm1 -force

$mediantdevices = foreach ($mediant in (get-content -Path .\scripts\mediant.json | convertfrom-json) ) { 
    Get-MediantDevice -Mediant $mediant.fqdn -http https -username $mediant.username -password (ConvertTo-SecureString -String $mediant.password)
}

foreach ($mediant in $mediantdevices) {
    $script = "show system ntp-status"
    $output = (Invoke-MediantCurlRequest -Mediant $mediant.fqdn -Credential $mediant.credential -script $script) 
    $script = "show high-availability status"
    $output += (Invoke-MediantCurlRequest -Mediant $mediant.fqdn -Credential $mediant.credential -script $script) 
    $script = "show network physical-port"
    $output += (Invoke-MediantCurlRequest -Mediant $mediant.fqdn -Credential $mediant.credential -script $script) 
    $script = "show network route"
    $output += (Invoke-MediantCurlRequest -Mediant $mediant.fqdn -Credential $mediant.credential -script $script) 
    $script = "show running-config troubleshoot"
    $output += (Invoke-MediantCurlRequest -Mediant $mediant.fqdn -Credential $mediant.credential -script $script) 
    $script = "show system uptime"
    $output += (Invoke-MediantCurlRequest -Mediant $mediant.fqdn -Credential $mediant.credential -script $script) 
    $script = "show system version"
    $output += (Invoke-MediantCurlRequest -Mediant $mediant.fqdn -Credential $mediant.credential -script $script) 
    $script = "show voip proxy set status"
    $output += (Invoke-MediantCurlRequest -Mediant $mediant.fqdn -Credential $mediant.credential -script $script) 
    $script = "show voip register-account"
    $output += (Invoke-MediantCurlRequest -Mediant $mediant.fqdn -Credential $mediant.credential -script $script) 
    $filename = "daily_$($mediant.fqdn).txt"
    out-file -filepath (daily.txt -Encoding ascii -
}