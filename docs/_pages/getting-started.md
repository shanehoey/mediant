---
title: "Getting Started"
excerpt: "Mediant Powershell Module"
layout: splash
---

This PowerShell module enables you to **perform basic management of a AudioCodes Mediant device directly from Powershell**. The only prequisites are that you have PowerShell v4.

## Latest Release

The latest release of this project is hosted on [PowerShell Gallery](https://www.powershellgallery.com/packages/mediant/)

{{ site.btn_poshgal }}

This development version of this project is hosted on [GitHub](https://www.github.com/shanehoey/WordDoc/)

{{ site.btn_github }}
{{ site.btn_github_watch }}
{{ site.btn_github_fork }}
{{ site.btn_github_star }}

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
