#requires -Version 5.0
<#
    Copyright (c) 2016-2019 Shane Hoey

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#>
param(
    [parameter(Position=0,Mandatory=$false)][boolean]$Stats=$true
)

write-verbose "'mediant PowerShell Module' hosted at https://github.com/shanehoey/mediant/ please contribute/review" -Verbose
if ($stats) {
  try 
  {
    #for usage stats only, only reporting on page views
    # to disable use import-module mediant -argumentlist $false instead 
    Invoke-WebRequest -Uri https://api.shanehoey.com/stats/mediant/  -TimeoutSec 2 
  }
  catch {}
}

class MediantWebRequest {
  [string]$Mediant
  [string]$StatusCode
  [string]$StatusDescription
  [string]$RawContent
  $Content

  MediantWebRequest ([string]$Mediant,[string]$StatusCode,[string]$StatusDescription)
  {
    $this.Mediant            = $Mediant
    $this.StatusCode         = $StatusCode
    $this.StatusDescription  = $StatusDescription
  }

  MediantWebRequest ([string]$Mediant,[string]$StatusCode,[string]$StatusDescription,[string]$RawContent,$content)
  {
    $this.Mediant            = $Mediant
    $this.StatusCode         = $StatusCode
    $this.StatusDescription  = $StatusDescription
    $this.RawContent         = $RawContent
    $this.content            = $content
  }
}

class MediantDevice {
  [string]$Mediant
  [pscredential]$Credential
  [ValidateSet('http','https')]
  [string]$http = 'https'

  MediantDevice () { }

  MediantDevice ([string]$mediant,[string]$http,[pscredential]$Credential) 
  {
    $this.mediant     = $mediant
    $this.http        = $http
    $this.credential  = $credential
  }

  MediantDevice ([string]$mediant,[pscredential]$Credential) 
  {
    $this.mediant     = $mediant
    $this.credential  = $credential
    $this.http        = 'http'
  }

}

class MediantStatus {
  [string]$Mediant
  [string]$StatusCode
  [string]$StatusDescription
  [string]$Result
  
  MediantStatus ([string]$Mediant,[string]$StatusCode,[string]$StatusDescription,[string]$Result) 
  {
    $this.Mediant            = $Mediant
    $this.StatusCode         = $StatusCode
    $this.StatusDescription  = $StatusDescription
    $this.Result             = $Result
  }
}

Function Invoke-MediantWebRequest 
{
  [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "medium",  DefaultParameterSetName = "default")]
  param(
    [Parameter(Mandatory = $true,  ParameterSetName='default')]
    [string]$Mediant,
  
    [Parameter(Mandatory = $true,  ParameterSetName='default')]
    [pscredential]$Credential,
   
    [Parameter(Mandatory = $true,  ParameterSetName='default')]
    [string]$Action,

    [Parameter(Mandatory = $false,  ParameterSetName='default')]
    [ValidateSet('Get', 'Put','Post','Delete')]
    [string]$Method = 'Get',

    [Parameter(Mandatory = $false,  ParameterSetName='default')]
    [ValidateSet('http', 'https')]
    [string]$http = 'https',
      
    [Parameter(Mandatory = $false,  ParameterSetName='default')]
    $Body,

    [Parameter(Mandatory = $false,  ParameterSetName='default')]
    [switch]$SkipCertificateCheck

  )
  
  Process { 
    $Parameters             = @{ }
    $Parameters.Uri         = "$($http)://$($Mediant)$($Action)"
    $Parameters.Credential  = $Credential
    $Parameters.Method      = $Method 
    if ($PSBoundParameters.body) 
    {
      $Parameters.Body    = $Body
    }
    try 
    { 

      if ($psboundparameters.SkipCertificateCheck) 
      { 
          Switch ($PSEdition)
          {
              "Desktop"
              {   
                  Write-Verbose "PSEdition Desktop"
                  if (!(test-ipphonetrustcertpolicy)) { write-warning "As a workaround to SSL cert run set-ipphonetrustallcertpolicy before continuing" -WarningAction Stop }  
                  $Response = Invoke-WebRequest @parameters -useragent "Mediant PowerShell/$($psversiontable.psedition)/$($psversiontable.psversion)" -ErrorAction Stop 
              }
              "Core"
              {
                  Write-Verbose "PSEdition Core"
                  $Response = Invoke-WebRequest @parameters -useragent "Mediant PowerShell/$($psversiontable.psedition)/$($psversiontable.psversion)" -skipcertificatecheck -ErrorAction Stop 
              }
          }
      }
      else 
      {
          $Response = Invoke-WebRequest @parameters -ErrorAction Stop 
      }
 
      [MediantWebRequest]::new($Mediant,$Response.StatusCode,$Response.StatusDescription,$Response.rawcontent,$Response.content )
    }
    catch 
    {
      Write-Warning -Message "[Error] - $_.Exception"
      $null
    }
  }
}

Function Invoke-MediantCurlRequest
{
  [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "medium",  DefaultParameterSetName = "file")]
  param(
    [Parameter(Mandatory = $true,  ParameterSetName='file')]
    [Parameter(Mandatory = $true,  ParameterSetName='script')]
    [string]$Mediant,
  
    [Parameter(Mandatory = $true,  ParameterSetName='file')]
    [Parameter(Mandatory = $true,  ParameterSetName='script')]
    [pscredential]$Credential,
  
    [Parameter(Mandatory = $false,  ParameterSetName='file')]
    [Parameter(Mandatory = $false,  ParameterSetName='script')]
    [ValidateSet('http', 'https')]
    [string]$http = "https",
   
    [Parameter(Mandatory = $true,  ParameterSetName='file')]
    [Validatescript({test-path -path $_ })]
    [string]$filePath,

    [Parameter(Mandatory = $true,  ParameterSetName='script')]
    [string]$script,


    [Parameter(Mandatory = $false,  ParameterSetName='file')]
    [Parameter(Mandatory = $false,  ParameterSetName='script')]
    [string]$Action = "/api/v1/files/cliScript/incremental",

    [Parameter(Mandatory = $false,  ParameterSetName='file')]
    [Parameter(Mandatory = $false,  ParameterSetName='script')]
    [ValidateSet('PUT')]
    [string]$Method = "PUT",

    [Parameter(Mandatory = $false,  ParameterSetName='file')]
    [Parameter(Mandatory = $false,  ParameterSetName='script')]
    [switch]$insecure

  )
  
  Process 
  { 
    try 
    { 
      curl.exe --help | Out-Null
    }
    catch
    {
      Write-Warning "Curl not installed, install curl or upgrade to Windows 10"
      break
    }

    if($script) {
      $tmp = New-TemporaryFile
      $script | out-file -filepath $tmp.FullName  -Encoding ASCII 
      $path = $tmp.FullName
    }
    else
    {
      $path = (get-item $filepath).fullname
    }
    $uri  = "$($http)://$($Mediant)$($Action)"
    if ($insecure) 
    {
        curl.exe --request "$($Method)" --form "file=@$($path)" --header "Expect:" --user "$($credential.username):$($credential.GetNetworkCredential().password)" $uri --insecure
    }
    else
    { 
        curl.exe --request "$($Method)" --form "file=@$($path)" --header "Expect:" --user "$($credential.username):$($credential.GetNetworkCredential().password)" $uri 
    }
  
    if($script) {
      remove-item -Path $tmp.fullname -force
    }
  }

}


Function Get-MediantDevice 
{
  [CmdletBinding(DefaultParameterSetName = 'credential')] 
  param(

    [Parameter(Mandatory = $true, ParameterSetName = 'username',   Position = 0)]
    [Parameter(Mandatory = $true, ParameterSetName = 'credential', Position = 0)]
    [string]$Mediant,


    [Parameter(Mandatory = $true, ParameterSetName = 'credential',Position = 1)]
    [pscredential]$Credential,
   
    [Parameter(Mandatory = $true, ParameterSetName = 'username',Position = 1)]
    [string]$username,
   
    [Parameter(Mandatory = $true, ParameterSetName = 'username',Position = 2)]
    [securestring]$password,

    [Parameter(Mandatory = $false, ParameterSetName = 'username',   Position = 3)]
    [Parameter(Mandatory = $false, ParameterSetName = 'credential', Position = 2)]
    [ValidateSet('http', 'https')]
    [string]$http = "https"

  )

  process {

    if($username) {
      [pscredential]$Credential = New-Object System.Management.Automation.PSCredential -ArgumentList $username,$password
    }

    $Parameters             = @{ }
    $Parameters.Mediant     = $Mediant
    $Parameters.Credential  = $Credential
    $Parameters.Http        = $http

    if (Test-MediantDevice @Parameters) 
    {
      Return ([mediantdevice]::new($Mediant,$http,$Credential))
    }
    else 
    {
      return $null
    }

  }
}

function Set-MediantTrustAllCertPolicy 
{
    [CmdletBinding(SupportsShouldProcess = $true,  ConfirmImpact = 'High' )]
    param()
    
    #Exist when core detected 
    if ($PSEdition -eq "Core")
    {
        Write-Warning "PowerShell Core should only use the -SkipCertificateCheck Parameter" -WarningAction Continue
    }
    else
    {   
        if (([System.Net.ServicePointManager]::SecurityProtocol).tostring() -notlike "*Tls12*" ) 
        {
            Write-Warning "Set TLS1.2 as default Security Protocol to current shell"  -WarningAction Continue
            [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]'Tls12'
            $settls = $true
        }
        
        if (([System.Net.ServicePointManager]::CertificatePolicy).GetType().name -eq "DefaultCertPolicy") 
        { 
            Write-Warning "Added TrustAllCertsPolicy to current shell"  -WarningAction Continue
            Add-Type -TypeDefinition @"
using System.Net;
using System.Security.Cryptography.X509Certificates;
public class TrustAllCertsPolicy : ICertificatePolicy {
    public bool CheckValidationResult(
        ServicePoint srvPoint, X509Certificate certificate,
        WebRequest request, int certificateProblem) {
        return true;
    }
}
"@
            [System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
            $setcert = $true
           
        }

        if ($settls -or $setcert) { Write-Warning "Exit PowerShell to revert these changes" -WarningAction Continue }
    
    }
}


function Test-mediantTrustCertPolicy 
{
    [CmdletBinding(DefaultParameterSetName = 'Mediant', SupportsShouldProcess = $true, ConfirmImpact = 'medium')]
    param(

        [Parameter(Mandatory = $true,    ParameterSetName = 'mediant' )]
        [string]$mediant,

        [Parameter(Mandatory = $true,    ParameterSetName = 'mediantdevice' )]
        [string]$mediantdevice
    )
      
    if($mediantdevice) { $mediant = $mediantdevice.Mediant }

    try 
    {
        $result = Invoke-WebRequest -uri "https://$mediant/" -UseBasicParsing 
        if ($result.statuscode -eq "200") {$true} else {$false}
          #do I need to add 203
    }
    catch 
    {
        $false
    }

}



Function Test-MediantDevice 
{
  [CmdletBinding(DefaultParameterSetName = 'MediantDevice')] 
  param(
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDevice',Position = 0)]
    [MediantDevice]$MediantDevice, 
    
    [Parameter(Mandatory = $true, ParameterSetName = 'Mediant',Position = 0)]
    [string]$Mediant,

    [Parameter(Mandatory = $true, ParameterSetName = 'Mediant',Position = 1)]
    [pscredential]$Credential,
   
    [Parameter(Mandatory = $false, ParameterSetName = 'Mediant',Position = 2)]
    [ValidateSet('http', 'https')]
    [string]$http = 'https',

    [Parameter(Mandatory = $false, ParameterSetName = 'MediantDevice')]
    [Parameter(Mandatory = $false, ParameterSetName = 'Mediant')]
    [switch]$quiet
  )
  Process { 

    $Parameters             = @{}
    if($PSBoundParameters.MediantDevice) 
    {
      $Parameters.Mediant     = $MediantDevice.Mediant
      $Parameters.Http        = $MediantDevice.http
      $Parameters.Credential  = $MediantDevice.Credential
    }  
    else 
    {
      $Parameters.Mediant     = $Mediant
      $Parameters.Http        = $http
      $Parameters.Credential  = $Credential
    }
    $Parameters.Method      = "Get"
    $Parameters.Action      = '/api/'

    try 
    {
      $Result = Invoke-MediantWebRequest @Parameters -ErrorAction Stop
      if($Result.statuscode -eq 200)
      {
        if ($PSBoundParameters.quiet) 
        {
          $true
        }
        else
        {
          [MediantStatus]::new(  $Parameters.Mediant , $Result.StatusCode, $Result.StatusDescription, $true )
        }
      }
    }
    catch [System.Net.WebException] 
    {
      Write-Warning -Message "[Error] - $_"
      $false
    }
  }
}


Function Restart-MediantDevice 
{
  [CmdletBinding(DefaultParameterSetName = 'MediantDeviceTimeoutGraceful', SupportsShouldProcess = $true, ConfirmImpact = 'medium')]
  Param (   
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceTimeoutGraceful')]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceTimeoutSeconds')]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceTimeoutImmediate')]
    [MediantDevice]$MediantDevice,
    
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantTimeoutGraceful')]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantTimeoutSeconds')]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantTimeoutImmediate')]
    [string]$Mediant,
    
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantTimeoutGraceful')]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantTimeoutSeconds')]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantTimeoutImmediate')]
    [pscredential]$Credential,

    [Parameter(Mandatory = $true, ParameterSetName = 'MediantTimeoutGraceful')]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantTimeoutSeconds')]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantTimeoutImmediate')]
    [ValidateSet('http', 'https')]
     [string]$http = 'https',    

    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceTimeoutGraceful')]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceTimeoutSeconds')]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceTimeoutImmediate')]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantTimeoutGraceful')]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantTimeoutSeconds')]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantTimeoutImmediate')]
    [bool]$SaveConfiguration,

    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceTimeoutGraceful')]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantTimeoutGraceful')]
    [switch]$TimeoutGraceful,

    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceTimeoutSeconds')]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantTimeoutSeconds')]
    [int]$TimeoutSeconds,

    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceTimeoutImmediate')]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantTimeoutImmediate')]
    [switch]$TimeoutImmediate 
  )
  
  Process { 

    if ($pscmdlet.ShouldProcess("$Mediant")) 
    {
      $Parameters             = @{}
      if($PSBoundParameters.MediantDevice) 
      {
        $Parameters.Mediant     = $MediantDevice.Mediant
        $Parameters.Http        = $MediantDevice.http
        $Parameters.Credential  = $MediantDevice.Credential
      }  
      else 
      {
        $Parameters.Mediant     = $Mediant
        $Parameters.Http        = $http
        $Parameters.Credential  = $Credential
      }
      $Parameters.Method      = 'Post'
      $Parameters.Action      = '/api/v1/actions/reset'
      $json = @{ }
      $json.saveConfiguration = $SaveConfiguration
      if($PSBoundParameters.timeoutgraceful) 
      {
        $json.gracefulTimeout = 1
      }
      if($PSBoundParameters.timeoutImmediate) 
      {
        $json.gracefulTimeout = 0
      }   
      if($PSBoundParameters.timeoutSeconds) 
      {
        $json.gracefulTimeout = $TimeoutSeconds
      }
      $Parameters.body       = ConvertTo-Json -InputObject $json 

      try 
      { 
        $Result = Invoke-MediantWebRequest @Parameters
        [MediantStatus]::new($Parameters.Mediant, $Result.StatusCode, $Result.StatusDescription, (ConvertFrom-Json -InputObject $Result.content ).description )
      }
      catch 
      {
        Write-Warning -Message "[Error] - $_.Exception"
        $null
      }
    }
  }
}


Function Save-MediantDevice 
{
  [CmdletBinding(DefaultParameterSetName = 'MediantDevice', SupportsShouldProcess = $true, ConfirmImpact = 'medium')]
  Param (
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDevice')]
    [MediantDevice]$MediantDevice,
    
    [Parameter(Mandatory = $true, ParameterSetName = 'Mediant')]
    [string]$Mediant,

    [Parameter(Mandatory = $true, ParameterSetName = 'Mediant')]
    [pscredential]$Credential,
        
    [Parameter(Mandatory = $false, ParameterSetName = 'Mediant')]
    [ValidateSet('http', 'https')]
    [string]$http 
  )

  Process {

    if ($pscmdlet.ShouldProcess("$Mediant")) 
    {
      $Parameters             = @{}
      if($PSBoundParameters.MediantDevice) 
      {
        $Parameters.Mediant     = $MediantDevice.Mediant
        $Parameters.Http        = $MediantDevice.http
        $Parameters.Credential  = $MediantDevice.Credential
      }  
      else 
      {
        $Parameters.Mediant     = $Mediant
        $Parameters.Http        = $http
        $Parameters.Credential  = $Credential
      }
      $Parameters.Method      = 'Post'
      $Parameters.Action      = '/api/v1/actions/saveConfiguration'

      try 
      { 
        $Result = Invoke-MediantWebRequest @Parameters
        switch ($Result.statuscode)
        {
          200            
          {
            [MediantStatus]::new(  $Parameters.Mediant , $Result.StatusCode, $Result.StatusDescription, 'Configuration Saved' )
          }
          409            
          {
            [MediantStatus]::new(  $Parameters.Mediant , $Result.StatusCode, $Result.StatusDescription, 'Configuration cant be saved due to current device state' )
          }
          default        
          {
            [MediantStatus]::new(  $Parameters.Mediant , $Result.StatusCode, $Result.StatusDescription,'Error')
          }
        }
      }
      catch 
      {
        Write-Warning -Message "[Error] - $_.Exception"
        $null
      }
    }
  }
}


Function Get-MediantDeviceStatus 
{
  [CmdletBinding(DefaultParameterSetName = 'MediantDevice', SupportsShouldProcess = $true, ConfirmImpact = 'medium')]
  Param
  (
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDevice')]
    [MediantDevice]$MediantDevice,
    
    [Parameter(Mandatory = $true, ParameterSetName = 'Mediant')]
    [string]$Mediant,

    [Parameter(Mandatory = $true, ParameterSetName = 'Mediant')]
    [pscredential]$Credential,
        
    [Parameter(Mandatory = $false, ParameterSetName = 'Mediant')]
    [ValidateSet('http', 'https')]
    [string]$http = "https"
  )

  Process {
    $Parameters             = @{}
    if($PSBoundParameters.MediantDevice) 
    {
      $Parameters.Mediant     = $MediantDevice.Mediant
      $Parameters.Http        = $MediantDevice.http
      $Parameters.Credential  = $MediantDevice.Credential
    }  
    else 
    {
      $Parameters.Mediant     = $Mediant
      $Parameters.Http        = $http
      $Parameters.Credential  = $Credential
    }
    $Parameters.Method      = 'GET'
    $Parameters.Action      = '/api/v1/status'

    try 
    { 
      $Result = Invoke-MediantWebRequest @Parameters
      $json = ConvertFrom-Json -InputObject $Result.content
      [pscustomobject]@{
        Mediant           = $Parameters.Mediant
        StatusCode        = $Result.StatusCode
        StatusDescription = $Result.StatusDescription
        localTimeStamp    = $json.localTimeStamp
        ipAddress         = $json.ipAddress
        subnetMask        = $json.subnetMask
        defaultGateway    = $json.defaultGateway
        productType       = $json.productType
        versionID         = $json.versionID
        protocolType      = $json.protocolType
        operationalState  = $json.operationalState
        highAvailability  = $json.highAvailability
        serialNumber      = $json.serialNumber
        macAddress        = $json.macAddress
      }
    }
    catch 
    {
      Write-Warning -Message "[Error] - $_.Exception"
      $null
    }
    
  }
}


Function start-MediantWebGui 
{
  [CmdletBinding(DefaultParameterSetName = 'MediantDevice', SupportsShouldProcess = $true, ConfirmImpact = 'medium')]
  Param
  (
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDevice')]
    [MediantDevice]$MediantDevice,
    
    [Parameter(Mandatory = $true, ParameterSetName = 'Mediant')]
    [string]$Mediant,

    [Parameter(Mandatory = $true, ParameterSetName = 'Mediant')]
    [pscredential]$Credential,
        
    [Parameter(Mandatory = $false, ParameterSetName = 'Mediant')]
    [ValidateSet('http', 'https')]
    [string]$http = "https",

    [Parameter(Mandatory = $false, ParameterSetName = 'Mediant')]
    [Parameter(Mandatory = $false, ParameterSetName = 'Mediantdevice')]
    [ValidateSet('admin', 'operator','monitor')]
    [string]$privLevel = "monitor",

    [Parameter(Mandatory = $false, ParameterSetName = 'Mediant')]
    [Parameter(Mandatory = $false, ParameterSetName = 'Mediantdevice')]
    [int]$sessionTimeout = 30
  )

  Process {
    $Parameters             = @{}
    if($PSBoundParameters.MediantDevice) 
    {
      $Parameters.Mediant     = $MediantDevice.Mediant
      $Parameters.Http        = $MediantDevice.http
      $Parameters.Credential  = $MediantDevice.Credential
    }  
    else 
    {
      $Parameters.Mediant     = $Mediant
      $Parameters.Http        = $http
      $Parameters.Credential  = $Credential
    }
    $Parameters.Method      = 'Post'
    $Parameters.Action      = '/api/v1/actions/authToken'

    $json = @{ }
    $json.username = $Parameters.Credential.UserName
    $json.privLevel = $privLevel
    $json.sessionTimeout = $sessionTimeout
    $Parameters.body       = ConvertTo-Json -InputObject $json 

    try 
    { 
      $Result = Invoke-MediantWebRequest @Parameters
      $token  = ($result.content | convertfrom-json).authtoken
      start-process -filepath "$($Parameters.http)://$($Parameters.mediant)/index.html?mode=web&authToken=$($token)"
    }
    catch 
    {
      Write-Warning -Message "[Error] - $_.Exception"
      $null
    }
    
  }
}

Function Get-MediantDeviceLicense 
{
  [CmdletBinding(DefaultParameterSetName = 'MediantDevice', SupportsShouldProcess = $true, ConfirmImpact = 'medium')]
  Param
  (
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDevice')]
    [MediantDevice]$MediantDevice,
      
    [Parameter(Mandatory = $true, ParameterSetName = 'Mediant')]
    [string]$Mediant,
  
    [Parameter(Mandatory = $true, ParameterSetName = 'Mediant')]
    [pscredential]$Credential,
          
    [Parameter(Mandatory = $false, ParameterSetName = 'Mediant')]
    [ValidateSet('http', 'https')]
    [string]$http ="https"
  )
  
  Process {
    $Parameters             = @{}
    if($PSBoundParameters.MediantDevice) 
    {
      $Parameters.Mediant     = $MediantDevice.Mediant
      $Parameters.Http        = $MediantDevice.http
      $Parameters.Credential  = $MediantDevice.Credential
    }  
    else 
    {
      $Parameters.Mediant     = $Mediant
      $Parameters.Http        = $http
      $Parameters.Credential  = $Credential
    }
    $Parameters.Method      = 'GET' 
    $Parameters.action     = '/api/v1/license'

    try 
    { 
      $Result = Invoke-MediantWebRequest @Parameters
      $json = ConvertFrom-Json -InputObject $Result.content
      [pscustomobject]@{
        Mediant           = $Parameters.Mediant
        StatusCode        = $Result.StatusCode
        StatusDescription = $Result.StatusDescription
        LicenseVersion    = $json.LicenseVersion
        serialNumber      = $json.serialNumber
        Key               = $json.Key
        Description       = $json.keyDescription
      }
    }
    catch 
    {
      Write-Warning -Message "[Error] - $_.Exception"
      $null
    }
    
  }
}
 

Function Get-MediantDeviceAlarm 
{
  [CmdletBinding(DefaultParameterSetName = 'MediantDevice', SupportsShouldProcess = $true, ConfirmImpact = 'medium')]

  Param(
        
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDevice',Position = 0)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceBefore',Position = 0)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceAfter',Position = 0)]
    [MediantDevice]$MediantDevice, 

    [Parameter(Mandatory = $true, ParameterSetName = 'Mediant',Position = 0)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantAfter',Position = 0)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantBefore',Position = 0)]
    [string]$Mediant,

    [Parameter(Mandatory = $true, ParameterSetName = 'Mediant',Position = 0)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantAfter',Position = 0)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantBefore',Position = 0)]
    [pscredential]$Credential,
        
    [Parameter(Mandatory = $false, ParameterSetName = 'Mediant',Position = 0)]
    [Parameter(Mandatory = $false, ParameterSetName = 'MediantAfter',Position = 0)]
    [Parameter(Mandatory = $false, ParameterSetName = 'MediantBefore',Position = 0)]
    [ValidateSet('http', 'https')]
    [string]$http = 'https',
    
    [Parameter(Mandatory = $false, ParameterSetName = 'MediantDevice',Position = 0)]
    [Parameter(Mandatory = $false, ParameterSetName = 'MediantDeviceBefore',Position = 0)]
    [Parameter(Mandatory = $false, ParameterSetName = 'MediantDeviceAfter',Position = 0)]
    [Parameter(Mandatory = $false, ParameterSetName = 'Mediant',Position = 0)]
    [Parameter(Mandatory = $false, ParameterSetName = 'MediantAfter',Position = 0)]
    [Parameter(Mandatory = $false, ParameterSetName = 'MediantBefore',Position = 0)]
    [ValidateSet('active', 'history')]
    [string]$alarm = 'active',
    
    [Parameter(Mandatory = $false, ParameterSetName = 'MediantDevice',Position = 0)]
    [Parameter(Mandatory = $false, ParameterSetName = 'MediantDeviceBefore',Position = 0)]
    [Parameter(Mandatory = $false, ParameterSetName = 'MediantDeviceAfter',Position = 0)]
    [Parameter(Mandatory = $false, ParameterSetName = 'Mediant',Position = 0)]
    [Parameter(Mandatory = $false, ParameterSetName = 'MediantAfter',Position = 0)]
    [Parameter(Mandatory = $false, ParameterSetName = 'MediantBefore',Position = 0)]
    [int]$alarmlimit = 20,
    
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceAfter',Position = 0)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantAfter',Position = 0)]
    [int]$alarmafter,
    
    [Parameter(Mandatory = $false, ParameterSetName = 'MediantDeviceBefore',Position = 0)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantBefore',Position = 0)]
    [int]$alarmbefore
    
  )
  
  Process {

  
    $Parameters             = @{}
    if($PSBoundParameters.MediantDevice) 
    {
      $Parameters.Mediant     = $MediantDevice.Mediant
      $Parameters.Http        = $MediantDevice.http
      $Parameters.Credential  = $MediantDevice.Credential
    }  
    else 
    {
      $Parameters.Mediant     = $Mediant
      $Parameters.Http        = $http
      $Parameters.Credential  = $Credential
    }
    $Parameters.Method        = 'GET' 
    $Parameters.action        = "/api/v1/alarms/$($alarm)/"

    if ( ( $PSBoundParameters.ContainsKey('alarmlimit') ) -or ( $PSBoundParameters.ContainsKey('alarmafter') ) -or ( $PSBoundParameters.ContainsKey('alarmbefore') ) ) 
    {
      $Parameters.action = $Parameters.action + '?'
    }
    if ( $PSBoundParameters.ContainsKey('alarmlimit')) 
    {
      $Parameters.action = $Parameters.action + "&limit=$alarmlimit"
    }
    if ( $PSBoundParameters.ContainsKey('alarmafter')) 
    {
      $Parameters.action = $Parameters.action + "&after=$alarmafter"
    }
    if ( $PSBoundParameters.ContainsKey('alarmbefore')) 
    {
      $Parameters.action = $Parameters.action + "&before=$alarmbefore"
    }
  
    try 
    { 
      $Result = Invoke-MediantWebRequest @Parameters
        
      switch ($Result.StatusCode)
      {
        200            
        { 
          foreach ($child in (( ConvertFrom-Json -InputObject $Result.content ).alarms ) ) 
          {
            $Parameters.action      = "$($child.url)"
            $childresult = ConvertFrom-Json -InputObject (Invoke-MediantWebRequest @Parameters).content 
            [pscustomobject]@{
              Mediant           = $Parameters.Mediant
              StatusCode        = $Result.StatusCode
              StatusDescription = $Result.StatusDescription
              id                = $childresult.id
              Description       = $childresult.description
              Severity          = $childresult.severity
              Source            = $childresult.source
              Date              = $childresult.date
            }
          }
        }
        204            
        {
          [pscustomobject]@{
            Mediant           = $Parameters.Mediant
            StatusCode        = $Result.StatusCode
            StatusDescription = $Result.StatusDescription
            id                = ''
            Description       = ''
            Severity          = ''
            Source            = ''
            Date              = ''
          }
        }
                  
        default      
        {
          [pscustomobject]@{
            Mediant           = $Parameters.Mediant
            StatusCode        = $Result.StatusCode
            StatusDescription = $Result.StatusDescription
            id                = ''
            Description       = 'UNKNOWN RESULT'
            Severity          = ''
            Source            = ''
            Date              = ''
          }
        }
      }
    }
    catch 
    {
      Write-Warning -Message "[Error] - $_.Exception"
      $null
    }


  }
}


Function Get-MediantDevicePerformanceMonitoring
{
  [cmdletBinding()]
  Param(
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantSpecific')]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantListAvailable')]
    [string]$Mediant,
  
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantSpecific')]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantListAvailable')]
    [pscredential]$Credential,
          
    [Parameter(Mandatory = $false, ParameterSetName = 'MediantSpecific')]
    [Parameter(Mandatory = $false, ParameterSetName = 'MediantListAvailable')]
    [ValidateSet('http', 'https')]
    [string]$http = 'https',
     
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantSpecific')]
    [ValidateSet('realtime', 'average','averageprev')]
    [string]$interval,

    [Parameter(Mandatory = $true, ParameterSetName = 'MediantListAvailable')]
    [switch]$listavailable


  )
  DynamicParam {
    # Set the dynamic parameters' name
    $ParameterName = 'PerformanceMonitor'
              
    # Create the dictionary 
    $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
  
    # Create the collection of attributes
    $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
              
    # Create and set the parameters' attributes
    $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
    $ParameterAttribute.ParameterSetName = 'MediantSpecific'
    $ParameterAttribute.Mandatory = $true
  
    # Add the attributes to the attributes collection
    $AttributeCollection.Add($ParameterAttribute)
  
    # Generate and set the ValidateSet 
    $arrSet = ((Invoke-MediantWebRequest -Mediant $Mediant -Credential $Credential -http $http -Method Get -Action '/api/v1/performanceMonitoring').content | ConvertFrom-Json).items
    $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute -ArgumentList ($arrSet)
  
    # Add the ValidateSet to the attributes collection
    $AttributeCollection.Add($ValidateSetAttribute)
  
    # Create and return the dynamic parameter
    $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter -ArgumentList ($ParameterName, [string], $AttributeCollection)
   
    $RuntimeParameterDictionary.Add($ParameterName, $RuntimeParameter)
    return $RuntimeParameterDictionary

  }
      


  Process
  {
 
    $Parameters             = @{}
    if($PSBoundParameters.MediantDevice) 
    {
      $Parameters.Mediant     = $MediantDevice.Mediant
      $Parameters.Http        = $MediantDevice.http
      $Parameters.Credential  = $MediantDevice.Credential
    }  
    else 
    {
      $Parameters.Mediant     = $Mediant
      $Parameters.Http        = $http
      $Parameters.Credential  = $Credential
    }
    $Parameters.Method        = 'GET' 
    $Parameters.action      = '/api/v1/performanceMonitoring'
      
    if ( $PSBoundParameters.ContainsKey('listavailable')) 
    {
      $Result = Invoke-MediantWebRequest @Parameters
      (ConvertFrom-Json -InputObject $Result.content).items.foreach({
          [pscustomobject]@{
            PerformanceMonitor = $_
          }
      })
    }
    
    if ( $PSBoundParameters.ContainsKey('PerformanceMonitor')) 
    {
        $Result = Invoke-MediantWebRequest -Mediant $Parameters.mediant -http $Parameters.http -Credential $Parameters.Credential -Method get -Action ("/api/v1/performanceMonitoring/$($PSBoundParameters.PerformanceMonitor)") 
        foreach ($i in (ConvertFrom-Json -InputObject $Result.content).indexes) 
        {
        switch ($interval)
          {
            'Realtime'            {  $action = "/api/v1/performanceMonitoring/$($PSBoundParameters.PerformanceMonitor)?index=$($i)&interval=0" }
            'average'            { $action = "/api/v1/performanceMonitoring/$($PSBoundParameters.PerformanceMonitor)?index=$($i)&interval=1" }
            'averageprev'   {  $action = "/api/v1/performanceMonitoring/$($PSBoundParameters.PerformanceMonitor)?index=$($i)&interval=2" }
            default {  $action = "/api/v1/performanceMonitoring/$($PSBoundParameters.PerformanceMonitor)?index=$($i)" }
          }
          $childresult = (Invoke-MediantWebRequest -Mediant $Parameters.mediant -http $Parameters.http -Credential $Parameters.Credential -Method get -Action $action ).content | convertfrom-json

            [pscustomobject]@{
              Mediant            = $Parameters.Mediant
              PerformanceMonitor = $PSBoundParameters.PerformanceMonitor
              Interval           = $interval
              index              = $childresult.index
              value              = $childresult.value
              min                = $childresult.min
              max                = $childresult.max
              average            = $childresult.average
              volume             = $childresult.volume
              total              = $childresult.total
              time_above_high    = $childresult.time_above_high
              time_between_high_low  = $childresult.time_between_high_low
              time_below_low     = $childresult.time_below_low

            }
          }



        }


    }

  }


Function Get-MediantDeviceFileCliScript 
{
  [CmdletBinding(DefaultParameterSetName = 'MediantDevice')]
    
  param(
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDevice',Position = 0)]
    [MediantDevice]$MediantDevice, 
      
    [Parameter(Mandatory = $true, ParameterSetName = 'Mediant',Position = 0)]
    [string]$Mediant,
  
    [Parameter(Mandatory = $true, ParameterSetName = 'Mediant',Position = 1)]
    [pscredential]$Credential,
     
    [Parameter(Mandatory = $false, ParameterSetName = 'Mediant',Position = 2)]
    [ValidateSet('http', 'https')]
    [string]$http = 'https',
  

    [Parameter(Mandatory = $false, ParameterSetName = 'MediantDevice',Position = 1)]
    [Parameter(Mandatory = $false, ParameterSetName = 'Mediant',Position = 3)]
    [validatescript({
          Test-Path $_
    })]
    [string]$File 
  
  )

  Process {

    if ($pscmdlet.ShouldProcess("$Mediant")) 
    {
      $Parameters             = @{}
      if($PSBoundParameters.MediantDevice) 
      {
        $Parameters.Mediant     = $MediantDevice.Mediant
        $Parameters.Http        = $MediantDevice.http
        $Parameters.Credential  = $MediantDevice.Credential
      }  
      else 
      {
        $Parameters.Mediant     = $Mediant
        $Parameters.Http        = $http
        $Parameters.Credential  = $Credential
      }
      $Parameters.Method      = 'Get'
      $Parameters.Action      = '/api/v1/files/cliScript'

      try 
      { 
        $Result = Invoke-MediantWebRequest @Parameters
        $Result = [System.Text.Encoding]::UTF8.GetString($Result.Content)
        $Result = ($Result -replace 'GET /topAreaStaus.json').trim()
        if($PSBoundParameters.file) 
        {
          Out-File -FilePath $File -InputObject ($Result).trim()
        }
        else 
        {
          return $Result
        }
      }
      catch 
      {
        Write-Warning -Message "[Error] - $_.Exception"
        $null
      }
    }
  }
}


Function Get-MediantDeviceFileIni 
{
  [CmdletBinding(DefaultParameterSetName = 'MediantDevice')]
    
  param(
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDevice',Position = 0)]
    [MediantDevice]$MediantDevice, 
      
    [Parameter(Mandatory = $true, ParameterSetName = 'Mediant',Position = 0)]
    [string]$Mediant,
  
    [Parameter(Mandatory = $true, ParameterSetName = 'Mediant',Position = 1)]
    [pscredential]$Credential,
     
    [Parameter(Mandatory = $false, ParameterSetName = 'Mediant',Position = 2)]
    [ValidateSet('http', 'https')]
    [string]$http = 'https',
  
    [Parameter(Mandatory = $false, ParameterSetName = 'MediantDevice',Position = 1)]
    [Parameter(Mandatory = $false, ParameterSetName = 'Mediant',Position = 3)]
    [validatescript({
          Test-Path $_
    })]
    [string]$File 
  
  )

  Process {

    $Parameters             = @{}
    if($PSBoundParameters.MediantDevice) 
    {
      $Parameters.Mediant     = $MediantDevice.Mediant
      $Parameters.Http        = $MediantDevice.http
      $Parameters.Credential  = $MediantDevice.Credential
    }  
    else 
    {
      $Parameters.Mediant     = $Mediant
      $Parameters.Http        = $http
      $Parameters.Credential  = $Credential
    }
    $Parameters.Method      = 'Get'
    $Parameters.Action      = '/api/v1/files/ini'

    try 
    { 
      $Result = Invoke-MediantWebRequest @Parameters
      $Result = [System.Text.Encoding]::UTF8.GetString($Result.Content)
      $Result = ($Result -replace 'GET /topAreaStaus.json').trim()
      $Result = $Result -replace '\[ ', '['
      $Result = $Result -replace ' \]', ']'
      $Result = $Result.trim()
      if($PSBoundParameters.file) 
      {
        Out-File -FilePath $File -InputObject ($Result).trim()
      }
      else 
      {
        return $Result
      }
    }
    catch 
    {
      Write-Warning -Message "[Error] - $_.Exception"
      $null
    }
    
  }
}


Function Get-MediantDeviceFileCliScript 
{
  [CmdletBinding(DefaultParameterSetName = 'MediantDeviceFull', SupportsShouldProcess = $true, ConfirmImpact = 'medium')]
  
  param(
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceFull',Position = 0)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceIncremental',Position = 0)]
    [MediantDevice]$MediantDevice, 
    
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantFull',Position = 0)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantIncremental',Position = 0)]
    [string]$Mediant,

    [Parameter(Mandatory = $true, ParameterSetName = 'MediantFullCli',Position = 1)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantIncremental',Position = 1)]
    [pscredential]$Credential,
   
    [Parameter(Mandatory = $false, ParameterSetName = 'MediantFull',Position = 2)]
    [Parameter(Mandatory = $false, ParameterSetName = 'MediantIncremental',Position = 2)]
    [ValidateSet('http', 'https')]
     [string]$http = 'https',
    
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceFull',Position = 1)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantFull',Position = 3)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceIncremental',Position = 1)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantIncremental',Position = 3)]
    [ValidateSet('Full', 'Incremental')]
    [String]$FileType,
   
    
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceFull',Position = 2)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantFull',Position = 4)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceIncremental',Position = 2)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantIncremental',Position = 4)]
    [String]$file
    
        
    
  )
 

  Begin
  {
    Write-Warning -Message 'Not Implemented Yet' -WarningAction Inquire
    if($PSBoundParameters.MediantDevice)
    {
      $Mediant     = $MediantDevice.Mediant
      $Credential  = $MediantDevice.Credential
      $http        = $MediantDevice.http
    }   

    $Parameters            = @{ }        
    $Parameters.mediant    = $Mediant    
    $Parameters.action     = '/api/v1/files/cliScript'
    
    if($PSBoundParameters.MediantDeviceFull)         
    {
      $Parameters.action  = '/api/v1/files/cliScript'
    }
    if($PSBoundParameters.MediantDeviceIncremental)  
    {
      $Parameters.action  = '/api/v1/files/cliScript/incremental'
    }
    if($PSBoundParameters.MediantFull)               
    {
      $Parameters.action  = '/api/v1/files/cliScript'
    }
    if($PSBoundParameters.MediantIncremental)        
    {
      $Parameters.action  = '/api/v1/files/cliScript/incremental'
    }
    
    $Parameters.credential = $Credential
    $Parameters.method     = 'put'
    $Parameters.http       = $http

  }    
 
  Process
  {
    if ($pscmdlet.ShouldProcess("$Mediant"))
    {
      if (Test-MediantDevice -Mediant $Mediant -Credential $Credential -http $http)
      {
        $Result = (Invoke-MediantWebRequest @Parameters)
        return $Result     
      }
      Else
      {
        return $null
      }   
    }
  }
}





# SIG # Begin signature block
# MIINHwYJKoZIhvcNAQcCoIINEDCCDQwCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU4K+BMHBfmSad6XIjUH1H+nFn
# VI2gggphMIIFKTCCBBGgAwIBAgIQD8tApulPpYV/uEuZ3XX3/jANBgkqhkiG9w0B
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
# CisGAQQBgjcCAQsxDjAMBgorBgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBTsamAu
# +KHafEOA4wiCxGoUfQMPSTANBgkqhkiG9w0BAQEFAASCAQCfV+H006oVjUfBFCYw
# FScoCIjKibEtk8Y78Z00xF4ewetjpXLUvtbBPn/vwehqiXnfaNo8+6It9LuTmooj
# 79b9VRz5WUHMsHtNQm+IWiKoPRrBTHWWeoVXAO8H31RlTdZT24HPrEE0YaAw2lfU
# VFMs/dsw3jnGDUB7w2jEO+Cn1mQikkIjAUP6zgGDgMUmwVlZ4oGZZIvNoQXSGC7j
# Y3UvZvb/kbrkkUqf1spCm+dPsv4zM2EFBjdU2yzhil3pqD34vphSJANtQEwz3PbH
# biMSVM9L2EiMOKic7/89B4xJgxoIvnqw0xfCO7targdzF+XVDzLioDEucsH1tOIE
# mTlt
# SIG # End signature block
