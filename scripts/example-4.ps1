#requires -version 5.0
#requires -module Mediant

import-module mediant 

$mediantcredential = Get-Credential 

$mediantdevice = Get-MediantDevice -Mediant 172.30.69.146 -Credential $mediantcredential -Http http

Get-MediantDeviceStatus -MediantDevice $mediantdevice 
