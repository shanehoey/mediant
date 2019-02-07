exit

set-location $env:USERPROFILE\github\mediant

$NuGetApiKey = $NuGetApiKey
$NuGetApiKey

$cert = Get-ChildItem Cert:\CurrentUser\My -CodeSigningCert
$cert | format-table subject,issuer
$cert

$version = "2.0.0"

Update-ModuleManifest -Path ".\mediant\mediant.psd1" -ModuleVersion $version #-FunctionsToExport "Get-MediantDevice","Get-MediantDeviceAlarm","Get-MediantDeviceFileCliScript","Get-MediantDeviceFileIni","Get-MediantDeviceLicense","Get-MediantDevicePerformanceMonitoring","Get-MediantDeviceStatus","Restart-MediantDevice","Save-MediantDevice","Test-MediantDevice" 

Set-AuthenticodeSignature -filepath ".\mediant\mediant.psd1" -Certificate $cert
(Get-AuthenticodeSignature -FilePath ".\mediant\mediant.psd1").Status

Set-AuthenticodeSignature -filepath ".\mediant\mediant.psm1" -Certificate $cert
(Get-AuthenticodeSignature -FilePath ".\mediant\mediant.psm1").Status

Test-ModuleManifest -path ".\mediant\mediant.psd1"

Remove-Module mediant -ErrorAction SilentlyContinue
Import-Module .\mediant\mediant.psd1 

get-command -Module mediant | select name,version

#Manually run these 
code .\Scripts\example.ps1

### MANUAL GitHUB Commit to master

### IMPORTANT ONLY RUN AFTER ALL ABOVE IS COMPLETED
pause
Publish-Module -path .\mediant -NuGetApiKey $NuGetApiKey