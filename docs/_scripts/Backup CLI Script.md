---
title: "Backup CLI script"
excerpt: "Backup a Mediant Gateway/SBC CLI script"
category: "general"
permalink: scripts/backup-cli/
---

## -----------------Example-----------------
Backup a Mediant Gateway/SBC CLI script in a single powershell command

```powershell

get-MediantDeviceFileIni -Mediant "192.16.0.2" -http https -credential (get-credential) -file .\config.ini

```

## -----------------Example-----------------
Backup a Mediant Gateway/SBC CLI script in a reusable script

```powershell

#requires -version 4.0
#requires -module Mediant

$mediantcredential = Get-Credential -UserName "Admin" -Message "Mediant Credential"
$mediantdevice = Get-MediantDevice -Mediant 172.30.69.146 -Credential $mediantcredential -Http http
get-MediantDeviceFileIni -MediantDevice $mediantdevice -file .\config.ini

```

**ProTip:** Be sure to check out the other [example scripts]({{site.base}}{{site.baseurl}}/scripts/) 
{: .notice--info}
