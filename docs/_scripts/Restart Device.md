---
title: "Restart a Mediant Gateway/SBC config"
excerpt: "Restart a Mediant Gateway/SBC config"
category: "general"
---

## -----------------Example-----------------
Restart a Mediant Gateway/SBC in a single powershell command

```powershell

#requires -version 4.0
#requires -module Mediant

restart-MediantDevice -Mediant "192.16.0.2" -http https -credential (get-credential) -SaveConfiguration $True -TimeoutGraceful 

```

## -----------------Example-----------------
Restart a Mediant Gateway/SBC in a reusable script

```powershell
#requires -version 4.0
#requires -module Mediant

$mediantcredential = Get-Credential -UserName "Admin" -Message "Mediant Credential"
$mediantdevice = Get-MediantDevice -Mediant 172.30.69.146 -Credential $mediantcredential -Http http
restart-MediantDevice -MediantDevice $mediantdevice -SaveConfiguration $True -TimeoutGraceful 

```

**ProTip:** Be sure to check out the other [example scripts]({{site.base}}{{site.baseurl}}/scripts/) 
{: .notice--info}
