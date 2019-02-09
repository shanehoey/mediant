import module .\mediant\mediant.psm1  force

$mediant   =  "sbc1.aclearning.com.au"
$credential = get credential

$script = "show system ntp-status"
Invoke-MediantScript -Mediant $mediant -Credential $credential -script $script
$script = "show high-availability status"
Invoke-MediantScript -Mediant $mediant -Credential $credential -script $script
$script = "show network physical port"
Invoke-MediantScript -Mediant $mediant -Credential $credential -script $script
$script = "show network route"
Invoke-MediantScript -Mediant $mediant -Credential $credential -script $script
$script = "show running config troubleshoot"
Invoke-MediantScript -Mediant $mediant -Credential $credential -script $script
$script = "show system uptime"
Invoke-MediantScript -Mediant $mediant -Credential $credential -script $script
$script = "show system version"
Invoke-MediantScript -Mediant $mediant -Credential $credential -script $script
$script = "show voip proxy set status"
Invoke-MediantScript -Mediant $mediant -Credential $credential -script $script
$script = "show voip register account"
Invoke-MediantScript -Mediant $mediant -Credential $credential -script $script
