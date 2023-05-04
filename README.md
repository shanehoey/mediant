# Mediant PowerShell Module


``` 
<b>Important Note</b> :  This project is out of date, I have plans to update it to the latest Mediant Firmware version, and PowerShell Core, however there is no release date yet

```


**Manage an AudioCodes Mediant device directly from PowerShell**

The Mediant PowerShell Module enables you to perform basic management functions on a AudioCodes Mediant Device directly from PowerShell. This unofficial module manages the device via the Rest API.<!---->

## Notable Features
* Get Statistics form the Device
* Backup a Devies config to either the command line or a file.
* Backup a Devies CLI Script to either the command line or a file.
* Save a running config on Mediant device
* Restart a Mediant device, (timed, gracefull or immediate)

This project's documentation is hosted on Git Pages
https://mediant.shanehoey.com/

The latest release is hosted on PowerShell Gallery 
https://www.powershellgallery.com/packages/mediant/

## Usage
``` POWERSHELL
$credential = Get-credential
$mediantdevice = get-mediantdevice -mediant 192.168.10.1 -http https -credential $credential
get-mediantdeviceinifile -mediantdevice $mediantdevice
restart-mediantdevice -mediantdevice $mediantdevice
```

## Distributed under MIT License
This project is distrubuted undet the MIT License. The license can be viewed [here](https://github.com/shanehoey/mediant/blob/master/LICENSE)

>## Using this Module Commercially ? 
>Lots of hours have gone into the module and example scripts development, So your [**small donation**](https://www.paypal.me/shanehoey) of a few dollars is much appreciated, and will help me continue improving. 

## Project Notes
This Project contains Powershell sample scripts that can be reused / adapted. Please do not just execute scripts without understanding what each and every line will do.

AudioCodes and Mediant are copyright and trademark of AudioCodes Ltd. This Module has not been developed by AudioCodes, so don’t ask them for support if you use this module
