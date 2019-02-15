

import-module .\mediant\mediant.psm1 -force

$mediantdevices = foreach ($mediant in (get-content -Path .\dailychecks.json | convertfrom-json) ) { 
    Get-MediantDevice -Mediant $mediant.mediant -http https -username $mediant.username -password (ConvertTo-SecureString -String $mediant.password)
}

foreach ($mediant in $mediantdevices) {
    $filename = "$((get-date).tostring("dd_MM_yyyy"))_$($mediant.mediant).txt"
    $script = "show system ntp-status"
    Invoke-MediantCurlRequest -Mediant $mediant.mediant -Credential $mediant.credential -script $script | ConvertFrom-Json  | Select-Object -expand output | out-file -filepath $filename -Append
    $script = "show high-availability status"
    (Invoke-MediantCurlRequest -Mediant $mediant.mediant -Credential $mediant.credential -script $script)  | ConvertFrom-Json  | Select-Object -expand output | out-file -filepath $filename -Append
    $script = "show network physical-port"
    (Invoke-MediantCurlRequest -Mediant $mediant.mediant -Credential $mediant.credential -script $script)  | ConvertFrom-Json  | Select-Object -expand output | out-file -filepath $filename -Append
    $script = "show network route"
    (Invoke-MediantCurlRequest -Mediant $mediant.mediant -Credential $mediant.credential -script $script)  | ConvertFrom-Json  | Select-Object -expand output | out-file -filepath $filename -Append
    $script = "show running-config troubleshoot"
    (Invoke-MediantCurlRequest -Mediant $mediant.mediant -Credential $mediant.credential -script $script)  | ConvertFrom-Json  | Select-Object -expand output | out-file -filepath $filename -Append
    $script = "show system uptime"
    (Invoke-MediantCurlRequest -Mediant $mediant.mediant -Credential $mediant.credential -script $script)  | ConvertFrom-Json  | Select-Object -expand output | out-file -filepath $filename -Append
    $script = "show system version"
    (Invoke-MediantCurlRequest -Mediant $mediant.mediant -Credential $mediant.credential -script $script)  | ConvertFrom-Json  | Select-Object -expand output | out-file -filepath $filename -Append
    $script = "show voip proxy set status"
    (Invoke-MediantCurlRequest -Mediant $mediant.mediant -Credential $mediant.credential -script $script)  | ConvertFrom-Json  | Select-Object -expand output | out-file -filepath $filename -Append
    $script = "show voip register-account"
    (Invoke-MediantCurlRequest -Mediant $mediant.mediant -Credential $mediant.credential -script $script)  | ConvertFrom-Json  | Select-Object -expand output | out-file -filepath $filename -Append
}