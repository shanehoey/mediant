#
# Module manifest for module 'mediant'
#
# Generated by: Shane Hoey
#
# Generated on: 24/07/2019
#

@{

# Script module or binary module file associated with this manifest.
RootModule = 'Mediant.psm1'

# Version number of this module.
ModuleVersion = '2.0.3'

# Supported PSEditions
# CompatiblePSEditions = @()

# ID used to uniquely identify this module
GUID = 'b10e4e09-efef-499b-97ed-2bae3635a838'

# Author of this module
Author = 'Shane Hoey'

# Company or vendor of this module
CompanyName = 'Unknown'

# Copyright statement for this module
Copyright = '(c) 2016-2019 Shane Hoey. All rights reserved.'

# Description of the functionality provided by this module
Description = 'Remotely access a AudioCodes Mediant Gateway or SBC via Powershell'

# Minimum version of the Windows PowerShell engine required by this module
# PowerShellVersion = ''

# Name of the Windows PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the Windows PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# CLRVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
# FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
# NestedModules = @()

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = 'Get-MediantDevice', 'Get-MediantDeviceAlarm', 
               'Get-MediantDeviceFileCliScript', 'Get-MediantDeviceFileIni', 
               'Get-MediantDeviceLicense', 
               'Get-MediantDevicePerformanceMonitoring', 'Get-MediantDeviceStatus', 
               'Restart-MediantDevice', 'Save-MediantDevice', 
               'Set-MediantTrustAllCertPolicy', 'start-MediantWebGui', 
               'Test-MediantDevice', 'Test-mediantTrustCertPolicy', 
               'Invoke-MediantWebRequest', 'Invoke-MediantCurlRequest'

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Variables to export from this module
# VariablesToExport = @()

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = @()

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
FileList = 'License.txt', 'Mediant.psm1', 'Mediant.psd1'

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = 'AudioCodes','Mediant','Gateway','SBC','Skype','SkypeforBusiness','Skype4B'

        # A URL to the license for this module.
        LicenseUri = 'http://mediant.shanehoey.com/license/'

        # A URL to the main website for this project.
        ProjectUri = 'http://mediant.shanehoey.com/'

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        ReleaseNotes = 'https://mediant.shanehoey.com/mediant/history/'

        # Prerelease string of this module
        # Prerelease = ''

        # Flag to indicate whether the module requires explicit user acceptance for install/update/save
        # RequireLicenseAcceptance = $false

        # External dependent modules of this module
        # ExternalModuleDependencies = @()

    } # End of PSData hashtable

 } # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}


# SIG # Begin signature block
# MIINHwYJKoZIhvcNAQcCoIINEDCCDQwCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUv9Ju4G53TcPYQN5GOblmeef7
# +/CgggphMIIFKTCCBBGgAwIBAgIQD8tApulPpYV/uEuZ3XX3/jANBgkqhkiG9w0B
# AQsFADByMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYD
# VQQLExB3d3cuZGlnaWNlcnQuY29tMTEwLwYDVQQDEyhEaWdpQ2VydCBTSEEyIEFz
# c3VyZWQgSUQgQ29kZSBTaWduaW5nIENBMB4XDTE5MDIwOTAwMDAwMFoXDTE5MTAx
# NTEyMDAwMFowZjELMAkGA1UEBhMCQVUxEzARBgNVBAgTClF1ZWVuc2xhbmQxGDAW
# BgNVBAcTD1JvY2hlZGFsZSBTb3V0aDETMBEGA1UEChMKU2hhbmUgSG9leTETMBEG
# A1UEAxMKU2hhbmUgSG9leTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEB
# ALwO4uf2IRVuz+vei74RR98B7LYaN0CFslmxAOISgihLCAHy6TpWNShnOFQBHz4B
# vKAX86W5532uyh8pr4pN4UistsyzggFaYrYl7x6KWLGzt/ku0nx4CYnoZaGNdeDc
# oJ7ukJvaEmD6CDBmIwMYOa7gDih07EAlq1ZCHXLZKTcvQ1YBHkn0sxIDyg3ilrQK
# mO8G5JHh17GGb+n6OzUWNwYRwCmktEXDMJYVtgmjSVwLbFU+SPgGld5lnzqELjgh
# NvuVXsdSotJXIXjBAjuZComoSYdEVukYVhNh228TgH/M45M2yLLBgLPnvd/L7gUy
# /cAEBd45hrjNuwXhXVrgzl0CAwEAAaOCAcUwggHBMB8GA1UdIwQYMBaAFFrEuXsq
# CqOl6nEDwGD5LfZldQ5YMB0GA1UdDgQWBBRMl/fVAn1vK9RW7FdPr5dMUDNCMTAO
# BgNVHQ8BAf8EBAMCB4AwEwYDVR0lBAwwCgYIKwYBBQUHAwMwdwYDVR0fBHAwbjA1
# oDOgMYYvaHR0cDovL2NybDMuZGlnaWNlcnQuY29tL3NoYTItYXNzdXJlZC1jcy1n
# MS5jcmwwNaAzoDGGL2h0dHA6Ly9jcmw0LmRpZ2ljZXJ0LmNvbS9zaGEyLWFzc3Vy
# ZWQtY3MtZzEuY3JsMEwGA1UdIARFMEMwNwYJYIZIAYb9bAMBMCowKAYIKwYBBQUH
# AgEWHGh0dHBzOi8vd3d3LmRpZ2ljZXJ0LmNvbS9DUFMwCAYGZ4EMAQQBMIGEBggr
# BgEFBQcBAQR4MHYwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNv
# bTBOBggrBgEFBQcwAoZCaHR0cDovL2NhY2VydHMuZGlnaWNlcnQuY29tL0RpZ2lD
# ZXJ0U0hBMkFzc3VyZWRJRENvZGVTaWduaW5nQ0EuY3J0MAwGA1UdEwEB/wQCMAAw
# DQYJKoZIhvcNAQELBQADggEBADq0MMofNx0tgG3mARjfSWbIE6fUWPDqJwFVfjWy
# vu+u7qQk6d0RP8EF25najMaEyg6X1Q/Cb6Lo6O9ILn56QKjqtELyFNvq+Ei0hBs7
# jk/+DAZqhuKFFtVle9hSbM0R41b5viZK+yBrh2SD6kGYSg81XVvzuaWYmNQESoW9
# bLOnO0QTcuz2Pe/0hYwqUnlCzm3yl9M485TBJdnB754YBgKcrYSLL57Kit4c2U7D
# rdP0YxAQdjMY9xQacd8Rc16sSyCmi2Q3b8xSkBXSCyqCnkEYMK9n3hlMGw0aM000
# 4rJaeT94x77x1nhpyKMMHgaK+XmDPMnuYPsKZxX4QE9GCtYwggUwMIIEGKADAgEC
# AhAECRgbX9W7ZnVTQ7VvlVAIMA0GCSqGSIb3DQEBCwUAMGUxCzAJBgNVBAYTAlVT
# MRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5j
# b20xJDAiBgNVBAMTG0RpZ2lDZXJ0IEFzc3VyZWQgSUQgUm9vdCBDQTAeFw0xMzEw
# MjIxMjAwMDBaFw0yODEwMjIxMjAwMDBaMHIxCzAJBgNVBAYTAlVTMRUwEwYDVQQK
# EwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xMTAvBgNV
# BAMTKERpZ2lDZXJ0IFNIQTIgQXNzdXJlZCBJRCBDb2RlIFNpZ25pbmcgQ0EwggEi
# MA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQD407Mcfw4Rr2d3B9MLMUkZz9D7
# RZmxOttE9X/lqJ3bMtdx6nadBS63j/qSQ8Cl+YnUNxnXtqrwnIal2CWsDnkoOn7p
# 0WfTxvspJ8fTeyOU5JEjlpB3gvmhhCNmElQzUHSxKCa7JGnCwlLyFGeKiUXULaGj
# 6YgsIJWuHEqHCN8M9eJNYBi+qsSyrnAxZjNxPqxwoqvOf+l8y5Kh5TsxHM/q8grk
# V7tKtel05iv+bMt+dDk2DZDv5LVOpKnqagqrhPOsZ061xPeM0SAlI+sIZD5SlsHy
# DxL0xY4PwaLoLFH3c7y9hbFig3NBggfkOItqcyDQD2RzPJ6fpjOp/RnfJZPRAgMB
# AAGjggHNMIIByTASBgNVHRMBAf8ECDAGAQH/AgEAMA4GA1UdDwEB/wQEAwIBhjAT
# BgNVHSUEDDAKBggrBgEFBQcDAzB5BggrBgEFBQcBAQRtMGswJAYIKwYBBQUHMAGG
# GGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNvbTBDBggrBgEFBQcwAoY3aHR0cDovL2Nh
# Y2VydHMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNzdXJlZElEUm9vdENBLmNydDCB
# gQYDVR0fBHoweDA6oDigNoY0aHR0cDovL2NybDQuZGlnaWNlcnQuY29tL0RpZ2lD
# ZXJ0QXNzdXJlZElEUm9vdENBLmNybDA6oDigNoY0aHR0cDovL2NybDMuZGlnaWNl
# cnQuY29tL0RpZ2lDZXJ0QXNzdXJlZElEUm9vdENBLmNybDBPBgNVHSAESDBGMDgG
# CmCGSAGG/WwAAgQwKjAoBggrBgEFBQcCARYcaHR0cHM6Ly93d3cuZGlnaWNlcnQu
# Y29tL0NQUzAKBghghkgBhv1sAzAdBgNVHQ4EFgQUWsS5eyoKo6XqcQPAYPkt9mV1
# DlgwHwYDVR0jBBgwFoAUReuir/SSy4IxLVGLp6chnfNtyA8wDQYJKoZIhvcNAQEL
# BQADggEBAD7sDVoks/Mi0RXILHwlKXaoHV0cLToaxO8wYdd+C2D9wz0PxK+L/e8q
# 3yBVN7Dh9tGSdQ9RtG6ljlriXiSBThCk7j9xjmMOE0ut119EefM2FAaK95xGTlz/
# kLEbBw6RFfu6r7VRwo0kriTGxycqoSkoGjpxKAI8LpGjwCUR4pwUR6F6aGivm6dc
# IFzZcbEMj7uo+MUSaJ/PQMtARKUT8OZkDCUIQjKyNookAv4vcn4c10lFluhZHen6
# dGRrsutmQ9qzsIzV6Q3d9gEgzpkxYz0IGhizgZtPxpMQBvwHgfqL2vmCSfdibqFT
# +hKUGIUukpHqaGxEMrJmoecYpJpkUe8xggIoMIICJAIBATCBhjByMQswCQYDVQQG
# EwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNl
# cnQuY29tMTEwLwYDVQQDEyhEaWdpQ2VydCBTSEEyIEFzc3VyZWQgSUQgQ29kZSBT
# aWduaW5nIENBAhAPy0Cm6U+lhX+4S5nddff+MAkGBSsOAwIaBQCgeDAYBgorBgEE
# AYI3AgEMMQowCKACgAChAoAAMBkGCSqGSIb3DQEJAzEMBgorBgEEAYI3AgEEMBwG
# CisGAQQBgjcCAQsxDjAMBgorBgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBSh0hNd
# E9ziec/5DW7BQkeJr55iSDANBgkqhkiG9w0BAQEFAASCAQBqdHpj4yb3IOgO+Ufm
# Iaq2007MIrGUY4IW93F8jGgEFAzxFQ+glYwv6qQDbNuxWoXnchEkP9wxAPwcyNUb
# MBauVFA6i+nB5QQxxuwdI0vOkQ3uoXauYU3zcnKQfb/1kn05IBsP6hevx7OZN/9w
# tsxEJ11WlGQ7tDQjoVV5+1mBgQ3XJhYuDyyZNLYw27653AGR+Jw6GWsQy+t2fZFt
# HrCwnCmosGHgUyEvxGoDZyh+obsKVUO1nksVqp1xczbZh4xPPT+fX9vWOlhMM2Mf
# 4WcqjnKMmBohyqHwKkQ+zlYb5yWxaHVhFEYF+Y9gNDbyA2Fu6HSSCAOzAdz/6/6O
# Nt/e
# SIG # End signature block
