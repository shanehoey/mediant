#requires -version 5.0
#requires -module Mediant

import-module mediant 

get-command -Module  mediant | sort-object name | select-object name


$mediant = "172.30.69.146"
$http = "http"
$credential = New-Object System.Management.Automation.PSCredential("Admin",("Admin" | ConvertTo-SecureString -asPlainText -Force))


$mediantparameters = @{
    mediant = "172.30.69.146"
    http = "http"
    credential = New-Object System.Management.Automation.PSCredential("Admin",("Admin" | ConvertTo-SecureString -asPlainText -Force))
}


Get-MediantDevice @mediantparameters
$mediantdevice = Get-MediantDevice @mediantparameters


#Borken no mediant devuce
Get-MediantdevicePerformanceMonitoring -MediantDevice $mediantdevice -listavailable





Test-MediantDevice @mediantparameters
Test-MediantDevice @mediantparameters -quiet

Test-MediantDevice -MediantDevice $mediantdevice
Test-MediantDevice -MediantDevice $mediantdevice -quiet


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


Save-MediantDevice -MediantDevice $mediantdevice
Save-MediantDevice @mediantparameters


Get-MediantDeviceLicense @mediantparameters
Get-MediantDeviceLicense -MediantDevice $mediantdevice 


Get-MediantDeviceStatus @mediantparameters
Get-MediantDeviceStatus -MediantDevice $mediantdevice
##
Get-MediantdeviceAlarm @mediantparameters  #active default
Get-MediantdeviceAlarm @mediantparameters -alarm active 
Get-MediantdeviceAlarm @mediantparameters -alarm active -alarmlimit 0
Get-MediantdeviceAlarm @mediantparameters -alarm active -alarmlimit 2 -alarmbefore 3 
Get-MediantdeviceAlarm @mediantparameters -alarm active -alarmlimit 2 -alarmafter 5 

Get-MediantdeviceAlarm @mediantparameters -alarm history 
Get-MediantdeviceAlarm @mediantparameters -alarm history -alarmlimit 2
Get-MediantdeviceAlarm @mediantparameters -alarm history -alarmlimit 2 -alarmbefore 3 
Get-MediantdeviceAlarm @mediantparameters -alarm history -alarmlimit 2 -alarmafter 5 

Get-MediantdeviceAlarm -MediantDevice $mediantdevice 
Get-MediantdeviceAlarm -MediantDevice $mediantdevice -alarm active 
Get-MediantdeviceAlarm -MediantDevice $mediantdevice -alarm active -alarmlimit 2
Get-MediantdeviceAlarm -MediantDevice $mediantdevice -alarm active -alarmlimit 2 -alarmbefore 3 
Get-MediantdeviceAlarm -MediantDevice $mediantdevice -alarm active -alarmlimit 2 -alarmafter 5 

Get-MediantdeviceAlarm -MediantDevice $mediantdevice -alarm history 
Get-MediantdeviceAlarm -MediantDevice $mediantdevice -alarm history -alarmlimit 2
Get-MediantdeviceAlarm -MediantDevice $mediantdevice -alarm history -alarmlimit 2 -alarmbefore 5
Get-MediantdeviceAlarm -MediantDevice $mediantdevice -alarm history -alarmlimit 2 -alarmafter 5 


Get-MediantdevicePerformanceMonitoring @mediantparameters -listavailable | Format-Wide
Get-MediantdevicePerformanceMonitoring @mediantparameters -interval realtime -PerformanceMonitor "mtcMtceDspUtilization"
Get-MediantdevicePerformanceMonitoring @mediantparameters -interval realtime -PerformanceMonitor "icmpInTimestamps"
Get-MediantdevicePerformanceMonitoring @mediantparameters -interval average -PerformanceMonitor "icmpInTimestamps"
Get-MediantdevicePerformanceMonitoring @mediantparameters -interval averageprev -PerformanceMonitor "icmpInTimestamps"

foreach ($monitor in (Get-MediantdevicePerformanceMonitoring @mediantparameters -listavailable).performancemonitor){
 Get-MediantdevicePerformanceMonitoring @mediantparameters -interval average -PerformanceMonitor $monitor | FT
}


## 
Get-MediantDeviceFileCliScript @mediantparameters 
Get-MediantDeviceFileCliScript @mediantparameters -file temp.cfg 
notepad .\temp.cfg
Get-MediantDeviceFileCliScript -MediantDevice $mediantdevice 
Get-MediantDeviceFileCliScript -MediantDevice $mediantdevice -filepath temp.cfg 
notepad .\temp.cfg

## 
Get-MediantDeviceFileIni @mediantparameters
Get-MediantDeviceFileIni @mediantparameters -file .\temp.cfg
notepad .\temp.cfg
Get-MediantDeviceFileIni -MediantDevice $mediantdevice 
Get-MediantDeviceFileIni -MediantDevice $mediantdevice -filepath .\temp.cfg
notepad .\temp.cfg
