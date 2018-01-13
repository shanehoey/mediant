---
title: "Get Alarms"
excerpt: "Get Mediant Gateway/SBC Alarms"
category: "general"
permalink: scripts/get-alarms/
---

## -----------------Example-----------------
Gets Mediant Gateway/SBC Alarms in a single powershell command

```powershell

Get-MediantDeviceAlarm -Mediant "192.16.0.2" -http https -credential (get-credential) -alarmlimit 100

```

## -----------------Example-----------------
Gets Mediant Gateway/SBC Alarms in a reusable script

```powershell
#requires -version 4.0
#requires -module Mediant

$mediantcredential = Get-Credential -UserName "Admin" -Message "Mediant Credential"
$mediantdevice = Get-MediantDevice -Mediant 172.30.69.146 -Credential $mediantcredential -Http http
Get-MediantDeviceAlarm -MediantDevice $mediantdevice -alarmlimit 100

```

**ProTip:** Be sure to check out the other [example scripts]({{site.base}}{{site.baseurl}}/scripts/) 
{: .notice--info}
