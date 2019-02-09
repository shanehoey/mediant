#requires -version 5.0
#requires -module Mediant

$cert = Get-ChildItem Cert:\CurrentUser\My -CodeSigningCert
Set-AuthenticodeSignature -filepath ".\mediant\mediant.psd1" -Certificate $cert
Set-AuthenticodeSignature -filepath ".\mediant\mediant.psm1" -Certificate $cert
import-module .\mediant\Mediant.psm1 -force 
import-module .\mediant\Mediant.psm1 -force -ArgumentList $false
get-command -Module mediant | sort-object name | select-object name

$mediantdevices = foreach ($mediant in (get-content -Path .\scripts\mediant.json | convertfrom-json) ) { 
    Get-MediantDevice -Mediant $mediant.fqdn -http https -username $mediant.username -password (ConvertTo-SecureString -String $mediant.password)
}

$mediantparameters = @{
    mediant = $mediantdevices[0].mediant
    http = $mediantdevices[0].http
    credential = $mediantdevices[0].Credential
}

$mediantdevice = Get-MediantDevice @mediantparameters

Test-MediantDevice @mediantparameters
Test-MediantDevice @mediantparameters -quiet
Test-MediantDevice -MediantDevice $mediantdevice
Test-MediantDevice -MediantDevice $mediantdevice -quiet
$mediantdevices.foreach({test-mediantdevice -MediantDevice $_})

Restart-MediantDevice @mediantparameters -SaveConfiguration $true -TimeoutGraceful 
Restart-MediantDevice @mediantparameters -SaveConfiguration $false -TimeoutGraceful 
Restart-MediantDevice @mediantparameters -SaveConfiguration $true -TimeoutSeconds 10 
Restart-MediantDevice @mediantparameters -SaveConfiguration $false -TimeoutSeconds 10  -verbose 
Restart-MediantDevice @mediantparameters -SaveConfiguration $true -TimeoutImmediate
Restart-MediantDevice @mediantparameters -SaveConfiguration $false -TimeoutImmediate 

Restart-MediantDevice -MediantDevice $mediantdevice -SaveConfiguration $true -TimeoutGraceful 
Restart-MediantDevice -MediantDevice $mediantdevice -SaveConfiguration $false -TimeoutGraceful 
Restart-MediantDevice -MediantDevice $mediantdevice -SaveConfiguration $true -TimeoutSeconds 10 
Restart-MediantDevice -MediantDevice $mediantdevice -SaveConfiguration $false -TimeoutSeconds 10 
Restart-MediantDevice -MediantDevice $mediantdevice -SaveConfiguration $true -TimeoutImmediate
Restart-MediantDevice -MediantDevice $mediantdevice -SaveConfiguration $false -TimeoutImmediate  


$mediantdevices.foreach({Restart-MediantDevice -MediantDevice $_ -SaveConfiguration $true -TimeoutGraceful})
$mediantdevices.foreach({Restart-MediantDevice -MediantDevice $_ SaveConfiguration $false -TimeoutGraceful})
$mediantdevices.foreach({Restart-MediantDevice -MediantDevice $_ -SaveConfiguration $true -TimeoutSeconds 10 })
$mediantdevices.foreach({Restart-MediantDevice -MediantDevice $_ -SaveConfiguration $false -TimeoutSeconds 10 })
$mediantdevices.foreach({Restart-MediantDevice -MediantDevice $_ -SaveConfiguration $true -TimeoutImmediate })
$mediantdevices.foreach({Restart-MediantDevice -MediantDevice $_ -SaveConfiguration $true -TimeoutImmediate  })

Save-MediantDevice -MediantDevice $mediantdevice
Save-MediantDevice @mediantparameters
$mediantdevices.foreach({Save-MediantDevice -MediantDevice $_ })

####
start-MediantWebGui -MediantDevice $mediantdevice

$mediantdevices.foreach({ start-MediantWebGui -MediantDevice $_ })



Get-MediantDeviceLicense @mediantparameters
Get-MediantDeviceLicense -MediantDevice $mediantdevice 
$mediantdevices.foreach({Save-MediantDevice -MediantDevice $_ })



Get-MediantDeviceStatus @mediantparameters
Get-MediantDeviceStatus -MediantDevice $mediantdevice
$mediantdevices.foreach({ Get-MediantDeviceStatus -MediantDevice $_ })


Get-MediantdeviceAlarm @mediantparameters  #active default
Get-MediantdeviceAlarm @mediantparameters -alarm active 
Get-MediantdeviceAlarm @mediantparameters -alarm active -alarmlimit 0
Get-MediantdeviceAlarm @mediantparameters -alarm active -alarmlimit 2 -alarmbefore 3 
Get-MediantdeviceAlarm @mediantparameters -alarm active -alarmlimit 2 -alarmafter 5 

Get-MediantdeviceAlarm -MediantDevice $mediantdevice 
Get-MediantdeviceAlarm -MediantDevice $mediantdevice -alarm active 
Get-MediantdeviceAlarm -MediantDevice $mediantdevice -alarm active -alarmlimit 2
Get-MediantdeviceAlarm -MediantDevice $mediantdevice -alarm active -alarmlimit 2 -alarmbefore 3 
Get-MediantdeviceAlarm -MediantDevice $mediantdevice -alarm active -alarmlimit 2 -alarmafter 5 


$mediantdevices.foreach({ Get-MediantdeviceAlarm -MediantDevice $_ })
$mediantdevices.foreach({ Get-MediantdeviceAlarm -MediantDevice $_ -alarm active })
$mediantdevices.foreach({ Get-MediantdeviceAlarm -MediantDevice $_ -alarm active -alarmlimit 2 })
$mediantdevices.foreach({ Get-MediantdeviceAlarm -MediantDevice $_ -alarm active -alarmlimit 2 -alarmbefore 3 })
$mediantdevices.foreach({ Get-MediantdeviceAlarm -MediantDevice $_ -alarm active -alarmlimit 2 -alarmafter 5 })



#this is broke on v1.0
Get-MediantdevicePerformanceMonitoring -MediantDevice $mediantdevice -listavailable

Get-MediantdevicePerformanceMonitoring @mediantparameters -listavailable | Format-Wide
Get-MediantdevicePerformanceMonitoring @mediantparameters -interval realtime -PerformanceMonitor "mtcMtceDspUtilization"
Get-MediantdevicePerformanceMonitoring @mediantparameters -interval realtime -PerformanceMonitor "icmpInTimestamps"
Get-MediantdevicePerformanceMonitoring @mediantparameters -interval average -PerformanceMonitor "icmpInTimestamps"
Get-MediantdevicePerformanceMonitoring @mediantparameters -interval averageprev -PerformanceMonitor "icmpInTimestamps"

foreach ($monitor in (Get-MediantdevicePerformanceMonitoring @mediantparameters -listavailable).performancemonitor){
 Get-MediantdevicePerformanceMonitoring @mediantparameters -interval average -PerformanceMonitor $monitor | FT
}

Get-MediantDeviceFileCliScript @mediantparameters -filetype full
Get-MediantDeviceFileCliScript @mediantparameters -filetype incremental

Get-MediantDeviceFileCliScript @mediantparameters -file temp.cfg 
Get-MediantDeviceFileCliScript -MediantDevice $mediantdevice 
Get-MediantDeviceFileCliScript -MediantDevice $mediantdevice -filepath temp.cfg 

Get-MediantDeviceFileIni @mediantparameters
Get-MediantDeviceFileIni @mediantparameters -file .\temp.cfg
Get-MediantDeviceFileIni -MediantDevice $mediantdevice 
Get-MediantDeviceFileIni -MediantDevice $mediantdevice -filepath .\temp.cfg
