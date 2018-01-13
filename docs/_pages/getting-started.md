---
title: "Getting Started"
excerpt: "Getting Started with managing a AudioCodes Mediant Device with Windows PowerShell"
layout: splash
header:
  cta_label: "<i class="fab fa-github"></i> View on Github"
  cta_url: "https://github.com/shanehoey/mediant/"
---


## Latest Release

The latest release of this project is hosted on {{ site.btn_poshgal }}

This development version of this project is hosted on {{ site.btn_github }} {{ site.btn_github_watch }} {{ site.btn_github_fork }} {{ site.btn_github_star }}

## Install latest release from PowerShell Gallery (Powershell v5)

Install latest released version directly from PowerShell Gallary

```powershell
install-module -modulename mediant -scope currentuser
```

## Install manually  (Powershell v3 & v4)

Copy the Mediant Folder on Git humodule manually

```powershell

Copy the mediant.psm1/mediant.psd1/license.txt files to a "Mediant" folder into one of the following folders
 * %userprofile%\Documents\WindowsPowerShell\Modules\WordDoc
 * %windir%\System32\WindowsPowerShell\v1.0\Modules\WordDoc
 
```

## Example Script

Once you have installed the module you can now Manage Audiocodes Mediant devices from powershell

```powershell

Import-Module mediant
$credential = get-credential
get-mediantdevicelicense -mediant $mediant -http https -credential $credential

```

**ProTip:** Be sure to check out the [example scripts](scripts/) 
{: .notice--success}
