---
title: "About"
excerpt: "Mediant Powershell Module"
layout: splash
---

## About Mediant PowerShell Module
The Mediant PowerShell Module enables you to perform basic management functions on a AudioCodes Mediant Device directly from PowerShell. This unofficial module manages the device via the Rest API.

AudioCodes and Mediant are copyright and trademark of AudioCodes Ltd.  This Module has not been developed by AudioCodes, so don't ask them for support if you use this module.

## Notable Features
 - Get Statistics form the Device
 - Backup a Devies config to either the command line or a file. 
 - Backup a Devies CLI Script to either the command line or a file. 
 - Save a running config on Mediant device
 - Restart a Mediant device, (timed, gracefull or immediate)

## Usage

```powershell
$credential = Get-credential
$mediantdevice = get-mediantdevice -mediant 192.168.10.1 -http https -credential $credential
get-mediantdeviceinifile -mediantdevice $mediantdevice
restart-mediantdevice -mediantdevice $mediantdevice
```

### Pre-requisites
 - PowerShell 3.0

### License 
This PowerShell Script/Module is distributed under the [MIT License](/license)

>## Using this Module Commercially ? 
>Lots of hours have gone into the module and example scripts development, So your [**small donation**](https://www.paypal.me/shanehoey) of a few dollars is much appreciated, and will help me continue improving. 
{{ site.btn_paypal }}
{: .notice--info}
