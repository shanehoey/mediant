#requires -Version 5.0
<#
    Copyright (c) 2016 Shane Hoey

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#>

#region classes
class MediantDevice
{
  [string]$Mediant
  [pscredential]$Credential
  [ValidateSet('http','https')]
  [string]$http

  MediantDevice ([string]$Mediant,[pscredential]$Credential,[string]$http)
  {
    $this.Mediant     =  $Mediant
    $this.Credential  =  $Credential
    $this.http        =  $http
  }
}

class MediantWebRequest
{
  [string]$Mediant
  [string]$StatusCode
  [string]$StatusDescription
  [string]$RawContent
  $Content

  MediantWebRequest ([string]$Mediant,[string]$StatusCode,[string]$StatusDescription,[string]$RawContent,$content)
  {
    $this.Mediant            =  $Mediant
    $this.StatusCode         =  $StatusCode
    $this.StatusDescription  =  $StatusDescription
    $this.RawContent         =  $RawContent
    $this.content            =  $content
  }
}

class MediantStatus
{
  [string]$Mediant
  [string]$StatusCode
  [string]$StatusDescription
  [string]$Result

  MediantStatus ([string]$Mediant,[string]$StatusCode,[string]$StatusDescription,[string]$Result)
  {
    $this.Mediant            =  $Mediant
    $this.StatusCode         =  $StatusCode
    $this.StatusDescription  =  $StatusDescription
    $this.Result             =  $Result
  }
}

class MediantDeviceStatus
{
  [string]$Mediant
  [string]$StatusCode
  [string]$StatusDescription
  [string]$LocalTimeStamp
  [string]$IPAddress
  [string]$SubnetMask
  [string]$DefaultGateway
  [string]$ProductType
  [string]$VersionID
  [string]$ProtocolType
  [string]$OperationalState
  [string]$HighAvailability
  [string]$SerialNumber
  [string]$MacAddress
 

  MediantDeviceStatus ( [string]$Mediant, [string]$StatusCode, [string]$StatusDescription, [string]$localTimeStamp, [string]$ipAddress, [string]$subnetMask, [string]$defaultGateway, [string]$productType, [string]$versionID, [string]$protocolType, [string]$operationalState, [string]$highAvailability, [string]$serialNumber, [string]$macAddress)
  {
    $this.Mediant = $Mediant
    $this.StatusCode = $StatusCode
    $this.StatusDescription = $StatusDescription
    $this.localTimeStamp = $localTimeStamp
    $this.ipAddress = $ipAddress
    $this.subnetMask = $subnetMask
    $this.defaultGateway = $defaultGateway
    $this.productType = $productType
    $this.versionID = $versionID
    $this.protocolType = $protocolType
    $this.operationalState = $operationalState
    $this.highAvailability = $highAvailability
    $this.serialNumber = $serialNumber
    $this.macAddress = $macAddress
  }
}
#endregion 

#region Mediant Device

#TEST: Get-MediantDevice

Function Get-MediantDevice 
{
  [CmdletBinding(DefaultParameterSetName='Mediant', SupportsShouldProcess=$true, ConfirmImpact='Medium')]
  
  param(
   
    [Parameter(Mandatory=$true, ParameterSetName='Mediant',Position = 0)]
    [string]$Mediant,

    [Parameter(Mandatory=$true, ParameterSetName='Mediant',Position = 1)]
    [pscredential]$Credential,
   
    [Parameter(Mandatory=$true, ParameterSetName='Mediant',Position = 2)]
    [ValidateSet('http', 'https')]
    [string]$Http
  )
  Begin
  { 
    $Parameters             =  @{ }
    $Parameters.Mediant     =  $mediant
    $Parameters.Credential  =  $Credential
    $Parameters.Http        =  $http
  }
  Process
  {
    if ($pscmdlet.ShouldProcess("$($Parameters.Mediant)"))
    {
      $result  = Test-MediantDevice @Parameters
    }
  }
  End
  {
    if ($result) 
    {
      Return ([mediantdevice]::new($mediant,$credential,$http))
    }       
    else 
    {
      return $null
    }
  }
}

#TEST: Test-MediantDevice
Function Test-MediantDevice 
{
  [CmdletBinding(DefaultParameterSetName='MediantDevice', SupportsShouldProcess=$true, ConfirmImpact='medium')]
  
  param(
    [Parameter(Mandatory=$true, ParameterSetName='MediantDevice',Position = 0)]
    [MediantDevice]$MediantDevice, 
    
    [Parameter(Mandatory=$true, ParameterSetName='Mediant',Position = 0)]
    [string]$Mediant,

    [Parameter(Mandatory=$true, ParameterSetName='Mediant',Position = 1)]
    [pscredential]$Credential,
   
    [Parameter(Mandatory=$false, ParameterSetName='Mediant',Position = 2)]
    [ValidateSet('http', 'https')]
    [string]$Http = "http" 
  )
  Begin
  { 
    $api = "/api"
    $parameters             =  @{ }
    if($PSBoundParameters.MediantDevice)
    {
      $parameters.uri        =  "$($mediantdevice.http)://$($MediantDevice.Mediant)$($api)"
      $parameters.Credential  =  $MediantDevice.Credential
    }  
    else 
    {
      $parameters.uri         =  "$($http)://$($mediant)/api"
      $parameters.Credential  =  $Credential
    }
    $parameters.Method      =  "Get"
  }
  Process
  {
    try 
    { 
      if ($pscmdlet.ShouldProcess("$($Mediant)$($MediantDevice.Mediant)"))
      {
        $result = Invoke-WebRequest @parameters -ErrorAction Stop 
      }
      Write-Verbose -message "`n$($result.rawcontent)" 
      if ($result.statuscode -eq "200") 
      { 
        return $true
      }       
    }
    catch [System.Net.WebException]
    {
      Write-Verbose -message "$($result.statuscode)"
      Write-Verbose -message "$($result.statusdescription)"
      Write-Warning -Message "[Error] - $_"
      return $false     
    }
    
  }
}

#TEST: Restart-MediantDevice
Function Restart-MediantDevice
{
  [CmdletBinding(DefaultParameterSetName='MediantDeviceTimeoutGraceful', SupportsShouldProcess=$true, ConfirmImpact='medium')]
  Param
  (   
    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceTimeoutGraceful')]
    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceTimeoutSeconds')]
    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceTimeoutImmediate')]
    [MediantDevice]$MediantDevice,
    
    [Parameter(Mandatory=$true, ParameterSetName='MediantTimeoutGraceful')]
    [Parameter(Mandatory=$true, ParameterSetName='MediantTimeoutSeconds')]
    [Parameter(Mandatory=$true, ParameterSetName='MediantTimeoutImmediate')]
    [string]$Mediant,
    
    [Parameter(Mandatory=$true, ParameterSetName='MediantTimeoutGraceful')]
    [Parameter(Mandatory=$true, ParameterSetName='MediantTimeoutSeconds')]
    [Parameter(Mandatory=$true, ParameterSetName='MediantTimeoutImmediate')]
    [pscredential]$Credential,
        
    [Parameter(Mandatory=$true, ParameterSetName='MediantTimeoutGraceful')]
    [Parameter(Mandatory=$true, ParameterSetName='MediantTimeoutSeconds')]
    [Parameter(Mandatory=$true, ParameterSetName='MediantTimeoutImmediate')]
    [ValidateSet('http', 'https')]
    [string]$Http,    
    
    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceTimeoutGraceful')]
    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceTimeoutSeconds')]
    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceTimeoutImmediate')]
    [Parameter(Mandatory=$true, ParameterSetName='MediantTimeoutGraceful')]
    [Parameter(Mandatory=$true, ParameterSetName='MediantTimeoutSeconds')]
    [Parameter(Mandatory=$true, ParameterSetName='MediantTimeoutImmediate')]
    [bool]$SaveConfiguration,
    
    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceTimeoutGraceful')]
    [Parameter(Mandatory=$true, ParameterSetName='MediantTimeoutGraceful')]
    [switch]$TimeoutGraceful,
    
    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceTimeoutSeconds')]
    [Parameter(Mandatory=$true, ParameterSetName='MediantTimeoutSeconds')]
    [int]$TimeoutSeconds,
    
    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceTimeoutImmediate')]
    [Parameter(Mandatory=$true, ParameterSetName='MediantTimeoutImmediate')]
    [switch]$TimeoutImmediate 
  )
  
  Begin
  {
    if($PSBoundParameters.MediantDevice)
    {
      $Mediant     =  $MediantDevice.Mediant
      $Credential  =  $MediantDevice.Credential
      $http        =  $MediantDevice.http
    }   
    if($PSBoundParameters.timeoutgraceful)  { $timeout = 1 }
    if($PSBoundParameters.timeoutImmediate) { $timeout = 0 }
    if($PSBoundParameters.timeoutSeconds)   { $timeout = $timeoutseconds }
    
    $parameters            =  @{ }        
    $parameters.mediant    =  $Mediant    
    $parameters.action     =  "/api/v1/actions/reset"
    $parameters.credential =  $Credential
    $parameters.method     =  "Post"
    $parameters.http       =  $http    
    $parameters.body       =  @"
{
    "saveConfiguration": $(($saveconfiguration).tostring().tolower()),
    "gracefulTimeout": $timeout
} 
"@
  }    
 
  Process
  {
    if ($pscmdlet.ShouldProcess("$Mediant"))
    {
      if (Test-MediantDevice -Mediant $Mediant -Credential $Credential -http $http)
      {
        $result = (Invoke-MediantWebRequest @parameters)
        $result = [MediantStatus]::new($Mediant, $result.StatusCode, $result.StatusDescription, ($result.rawcontent | convertfrom-json).description )
        return $result     
      }
      Else
      {
        return $null
      }   
    }
  }
}

#TEST : Save-MediantDevice
Function Save-MediantDevice
{ 
  [CmdletBinding(DefaultParameterSetName='MediantDevice', SupportsShouldProcess=$true, ConfirmImpact='medium')]
  Param
  (
    [Parameter(Mandatory=$true, ParameterSetName='MediantDevice')]
    [MediantDevice]$MediantDevice,
    
    [Parameter(Mandatory=$true, ParameterSetName='Mediant')]
    [string]$Mediant,

    [Parameter(Mandatory=$true, ParameterSetName='Mediant')]
    [pscredential]$Credential,
        
    [Parameter(Mandatory=$true, ParameterSetName='Mediant')]
    [ValidateSet('http', 'https')]
    [string]$Http 
  )

  Begin
  {
    if($PSBoundParameters.MediantDevice)
    {
      $Mediant     =  $MediantDevice.Mediant
      $Credential  =  $MediantDevice.Credential
      $http        =  $MediantDevice.http
    }   

    $parameters            =  @{ }        
    $parameters.mediant    =  $Mediant    
    $parameters.action     =  "/api/v1/actions/saveConfiguration"
    $parameters.credential =  $Credential
    $parameters.method     =  "Post"
    $parameters.http       =  $http    
    
  } 
  Process
  {
    if ($pscmdlet.ShouldProcess("$Mediant"))
    {
      if (Test-MediantDevice -Mediant $Mediant -Credential $Credential -http $http)
      {
        $result = (Invoke-MediantWebRequest @parameters)
        $result = [MediantStatus]::new($Mediant, $result.StatusCode, $result.StatusDescription, ($result.rawcontent | convertfrom-json).description )
        return $result     
      }
      Else
      {
        return $null
      }   
    }
  }
}

#TODO: Find out how to use authtoken  
#$action = "/api/v1/actions/authtoken"


#TEST: Get-MediantDeviceStatus
Function Get-MediantDeviceStatus
{ 
  [CmdletBinding(DefaultParameterSetName='MediantDevice', SupportsShouldProcess=$true, ConfirmImpact='medium')]
  Param
  (
    [Parameter(Mandatory=$true, ParameterSetName='MediantDevice')]
    [MediantDevice]$MediantDevice,
    
    [Parameter(Mandatory=$true, ParameterSetName='Mediant')]
    [string]$Mediant,

    [Parameter(Mandatory=$true, ParameterSetName='Mediant')]
    [pscredential]$Credential,
        
    [Parameter(Mandatory=$true, ParameterSetName='Mediant')]
    [ValidateSet('http', 'https')]
    [string]$Http
  )

  Begin
  {
    if($PSBoundParameters.MediantDevice)
    {
      $Mediant     =  $MediantDevice.Mediant
      $Credential  =  $MediantDevice.Credential
      $http        =  $MediantDevice.http
    }   

    $parameters            =  @{ }        
    $parameters.mediant    =  $Mediant    
    $parameters.action     =  "/api/v1/status"
    $parameters.credential =  $Credential
    $parameters.method     =  "Post"
    $parameters.http       =  $http    
    
  } 
  Process
  {
    if ($pscmdlet.ShouldProcess("$Mediant"))
    {
      if (Test-MediantDevice -Mediant $Mediant -Credential $Credential -http $http)
      {
        $result = (Invoke-MediantWebRequest @parameters)
        $result = [MediantDeviceStatus]::new($Mediant, 
          $result.StatusCode,
          $result.StatusDescription,
          ($result.rawcontent | convertfrom-json).localTimeStamp,
          ($result.rawcontent | convertfrom-json).ipAddress, 
          ($result.rawcontent | convertfrom-json).subnetMask, 
          ($result.rawcontent | convertfrom-json).defaultGateway, 
          ($result.rawcontent | convertfrom-json).productType, 
          ($result.rawcontent | convertfrom-json).versionID, 
          ($result.rawcontent | convertfrom-json).protocolType, 
          ($result.rawcontent | convertfrom-json).operationalState,
          ($result.rawcontent | convertfrom-json).highAvailability, 
          ($result.rawcontent | convertfrom-json).serialNumber,
          ($result.rawcontent | convertfrom-json).macAddress
        ) 
        return $result   
      }
      Else
      {
        return $null
      }   
    }
  }
}

#endregion

#region Mediant Web Request

#TEST: Invoke-MediantWebRequest
Function Invoke-MediantWebRequest 
{
  [CmdletBinding(DefaultParameterSetName='MediantDevice', SupportsShouldProcess=$true, ConfirmImpact='medium')]
  
  param(
    [Parameter(Mandatory=$true, ParameterSetName='MediantDevice')]
    [MediantDevice]$MediantDevice,
    
    [Parameter(Mandatory=$true, ParameterSetName='Mediant')]
    [string]$Mediant,

    [Parameter(Mandatory=$true, ParameterSetName='Mediant')]
    [pscredential]$Credential,

    [Parameter(Mandatory=$true, ParameterSetName='Mediant')]
    [ValidateSet('http', 'https')]
    [string]$http,
 
    [Parameter(Mandatory=$true, ParameterSetName='Mediant')]
    [Parameter(Mandatory=$true, ParameterSetName='MediantDevice')]
    [ValidateSet('Get', 'Put','Post','Delete')]
    [string]$Method,
    
    [Parameter(Mandatory=$true, ParameterSetName='Mediant')]
    [Parameter(Mandatory=$true, ParameterSetName='MediantDevice')]
    [string]$Action,
    
    [Parameter(Mandatory=$false, ParameterSetName='Mediant')]
    [Parameter(Mandatory=$false, ParameterSetName='MediantDevice')]
    $Body
  )

  Begin
  { 
    
    if($PSBoundParameters.MediantDevice)
    {
      $Mediant     =  $MediantDevice.Mediant
      $Credential  =  $MediantDevice.Credential
      $http        =  $MediantDevice.http
    }

    $parameters             =  @{ }
    $parameters.uri         =  "$($http)://$($Mediant)$($action)"
    $parameters.credential  =  $Credential
    $parameters.Method      =  $Method 
    if ($PSBoundParameters.body) { $parameters.body = $body }
    
  
    if(!(Test-MediantDevice -Mediant $Mediant -Credential $Credential -http $http)) 
    {
      return $null
    }      
  }
  Process
  {
    try 
    { 
      if ($pscmdlet.ShouldProcess("$($parameters.Mediant)", $($parameters.uri)))
      {
        $response = Invoke-WebRequest @parameters -ErrorAction Stop 
        Write-Verbose  "`n`n$($response.rawcontent)"
        return ( [MediantWebRequest]::new($Mediant,$response.StatusCode,$response.StatusDescription,$response.rawcontent,$response.content ) )
      }
    }
    #TODO: Investigate better catch options with  [System.Net.WebException] etc
    catch
    {
      Write-Warning -Message "[Error] - $_.Exception"
      return $null
    }
  }
}
#endregion 

#region File - AMD

#TODO: get-xMediantDeviceFileAMD 
Function get-xMediantDeviceFileAMD 
{
  [CmdletBinding(DefaultParameterSetName='MediantDevice', SupportsShouldProcess=$true, ConfirmImpact='medium')]
  
  param(
    [Parameter(Mandatory=$true, ParameterSetName='MediantDevice',Position = 0)]
    [MediantDevice]$MediantDevice, 
    
    [Parameter(Mandatory=$true, ParameterSetName='Mediant',Position = 0)]
    [string]$Mediant,

    [Parameter(Mandatory=$true, ParameterSetName='Mediant',Position = 1)]
    [pscredential]$Credential,
   
    [Parameter(Mandatory=$false, ParameterSetName='Mediant',Position = 2)]
    [ValidateSet('http', 'https')]
    [string]$Http = "http" 
  )
  
  Begin
  {
    Write-Warning -Message "Not Implemented Yet" -WarningAction Inquire
    
    if($PSBoundParameters.MediantDevice)
    {
      $Mediant     =  $MediantDevice.Mediant
      $Credential  =  $MediantDevice.Credential
      $http        =  $MediantDevice.http
    }   

    $parameters            =  @{ }        
    $parameters.mediant    =  $Mediant    
    $parameters.action     =  "/api/v1/files/amd"
    $parameters.credential =  $Credential
    $parameters.method     =  "get"
    $parameters.http       =  $http    

  }    
 
  Process
  {
    if ($pscmdlet.ShouldProcess("$Mediant"))
    {
      if (Test-MediantDevice -Mediant $Mediant -Credential $Credential -http $http)
      {
        $result = (Invoke-MediantWebRequest @parameters)
        return $result     
      }
      Else
      {
        return $null
      }   
    }
  }
}

#TODO: set-xMediantDeviceFileAMD
function set-xMediantDeviceFileAMD
{
  [CmdletBinding(DefaultParameterSetName='MediantDeviceImmediate', SupportsShouldProcess=$true, ConfirmImpact='medium')]
  
  param(
    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceImmediate',Position = 0)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceHitless',Position = 0)]
    [MediantDevice]$MediantDevice, 
    
    [Parameter(Mandatory=$true, ParameterSetName='MediantImmediate',Position = 0)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantHitless',Position = 0)]
    [string]$Mediant,

    [Parameter(Mandatory=$true, ParameterSetName='MediantImmediate',Position = 1)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantHitless',Position = 1)]
    [pscredential]$Credential,
   
    [Parameter(Mandatory=$true, ParameterSetName='MediantImmediate',Position = 2)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantHitless',Position = 2)]
    [ValidateSet('http', 'https')]
    [string]$Http,
    
    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceImmediate',Position = 1)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantImmediate',Position = 3)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceHitless',Position = 1)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantHitless',Position = 3)]
    [ValidateSet('Immediate', 'Hitless')]
    [String]$LoadType
     
  )
  Begin
  {
    Write-Warning -Message "Not Implemented Yet" -WarningAction Inquire
    if($PSBoundParameters.MediantDevice)
    {
      $Mediant     =  $MediantDevice.Mediant
      $Credential  =  $MediantDevice.Credential
      $http        =  $MediantDevice.http
    }   

    $parameters            =  @{ }        
    $parameters.mediant    =  $Mediant    

    if($PSBoundParameters.MediantDeviceImmediate) { $parameters.action  =  "/api/v1/files/amd" }
    if($PSBoundParameters.MediantDeviceHitless)   { $parameters.action  =  "/api/v1/files/amd/hitless" }
    if($PSBoundParameters.MediantImmediate)       { $parameters.action  =  "/api/v1/files/amd" }
    if($PSBoundParameters.MediantHitless)         { $parameters.action  =  "/api/v1/files/amd/hitless" }

    $parameters.credential =  $Credential
    $parameters.method     =  "get"
    $parameters.http       =  $http    

  }    
 
  Process
  {
    if ($pscmdlet.ShouldProcess("$Mediant"))
    {
      if (Test-MediantDevice -Mediant $Mediant -Credential $Credential -http $http)
      {
        $result = (Invoke-MediantWebRequest @parameters)
        return $result     
      }
      Else
      {
        return $null
      }   
    }
  }
  }
 
#endregion AMD

#region File - CasTable

#TODO: get-xMediantDeviceFileCasTable
Function get-xMediantDeviceFileCasTable
{
  [CmdletBinding(DefaultParameterSetName='MediantDevice', SupportsShouldProcess=$true, ConfirmImpact='medium')]
  
  param(
    [Parameter(Mandatory=$true, ParameterSetName='MediantDevice',Position = 0)]
    [MediantDevice]$MediantDevice, 
    
    [Parameter(Mandatory=$true, ParameterSetName='Mediant',Position = 0)]
    [string]$Mediant,

    [Parameter(Mandatory=$true, ParameterSetName='Mediant',Position = 1)]
    [pscredential]$Credential,
   
    [Parameter(Mandatory=$false, ParameterSetName='Mediant',Position = 2)]
    [ValidateSet('http', 'https')]
    [string]$Http = "http" 
  )
  Begin
  {
    Write-Warning -Message "Not Implemented Yet" -WarningAction Inquire
    if($PSBoundParameters.MediantDevice)
    {
      $Mediant     =  $MediantDevice.Mediant
      $Credential  =  $MediantDevice.Credential
      $http        =  $MediantDevice.http
    }   

    $parameters            =  @{ }        
    $parameters.mediant    =  $Mediant    
    $parameters.action     =  "/api/v1/files/casTable"
    $parameters.credential =  $Credential
    $parameters.method     =  "get"
    $parameters.http       =  $http    

  }    
 
  Process
  {
    if ($pscmdlet.ShouldProcess("$Mediant"))
    {
      if (Test-MediantDevice -Mediant $Mediant -Credential $Credential -http $http)
      {
        $result = (Invoke-MediantWebRequest @parameters)
        return $result     
      }
      Else
      {
        return $null
      }   
    }
  }
}

#TODO: set-xMediantDeviceFileCasTable
Function set-xMediantDeviceFileCasTable
{
  [CmdletBinding(DefaultParameterSetName='MediantDeviceImmediate', SupportsShouldProcess=$true, ConfirmImpact='medium')]
  
  param(
    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceImmediate',Position = 0)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceHitless',Position = 0)]
    [MediantDevice]$MediantDevice, 
    
    [Parameter(Mandatory=$true, ParameterSetName='MediantImmediate',Position = 0)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantHitless',Position = 0)]
    [string]$Mediant,

    [Parameter(Mandatory=$true, ParameterSetName='MediantImmediate',Position = 1)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantHitless',Position = 1)]
    [pscredential]$Credential,
   
    [Parameter(Mandatory=$true, ParameterSetName='MediantImmediate',Position = 2)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantHitless',Position = 2)]
    [ValidateSet('http', 'https')]
    [string]$Http,
    
    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceImmediate',Position = 1)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantImmediate',Position = 3)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceHitless',Position = 1)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantHitless',Position = 3)]
    [ValidateSet('Immediate', 'Hitless')]
    [String]$LoadType
     
  )
  Begin
  {
    Write-Warning -Message "Not Implemented Yet" -WarningAction Inquire
    if($PSBoundParameters.MediantDevice)
    {
      $Mediant     =  $MediantDevice.Mediant
      $Credential  =  $MediantDevice.Credential
      $http        =  $MediantDevice.http
    }   

    $parameters            =  @{ }        
    $parameters.mediant    =  $Mediant    

    if($PSBoundParameters.MediantDeviceImmediate) { $parameters.action  =  "/api/v1/files/casTable" }
    if($PSBoundParameters.MediantDeviceHitless)   { $parameters.action  =  "/api/v1/files/casTable/hitless" }
    if($PSBoundParameters.MediantImmediate)       { $parameters.action  =  "/api/v1/files/casTable" }
    if($PSBoundParameters.MediantHitless)         { $parameters.action  =  "/api/v1/files/casTable/hitless" }
    
    $parameters.credential =  $Credential
    $parameters.method     =  "get"
    $parameters.http       =  $http    

  }    
 
  Process
  {
    if ($pscmdlet.ShouldProcess("$Mediant"))
    {
      if (Test-MediantDevice -Mediant $Mediant -Credential $Credential -http $http)
      {
        $result = (Invoke-MediantWebRequest @parameters)
        return $result     
      }
      Else
      {
        return $null
      }   
    }
  }
}
#endregion

#region File - CLIScript
#TODO: get-MediantDeviceFileCliScript
Function Get-MediantDeviceFileCliScript
{
  [CmdletBinding(DefaultParameterSetName='MediantDevice', SupportsShouldProcess=$true, ConfirmImpact='medium')]
  
  param(
    [Parameter(Mandatory=$true, ParameterSetName='MediantDevice',Position = 0)]
    [MediantDevice]$MediantDevice, 
    
    [Parameter(Mandatory=$true, ParameterSetName='Mediant',Position = 0)]
    [string]$Mediant,

    [Parameter(Mandatory=$true, ParameterSetName='Mediant',Position = 1)]
    [pscredential]$Credential,
   
    [Parameter(Mandatory=$false, ParameterSetName='Mediant',Position = 2)]
    [ValidateSet('http', 'https')]
    [string]$Http = "http",

    #TODO: Add Validate script to validate at lease folder location    
    [Parameter(Mandatory=$false, ParameterSetName='MediantDevice',Position = 1)]
    [Parameter(Mandatory=$false, ParameterSetName='Mediant',Position = 3)]
    [string]$filepath 

  )
  Begin
  {
    Write-Warning -Message "Not Implemented Yet" -WarningAction Inquire
    if($PSBoundParameters.MediantDevice)
    {
      $Mediant     =  $MediantDevice.Mediant
      $Credential  =  $MediantDevice.Credential
      $http        =  $MediantDevice.http
    }   

    $parameters            =  @{ }        
    $parameters.mediant    =  $Mediant    
    $parameters.action     =  "/api/v1/files/cliScript"
    $parameters.credential =  $Credential
    $parameters.method     =  "get"
    $parameters.http       =  $http    

  }    
 
  Process
  {
    if ($pscmdlet.ShouldProcess("$Mediant"))
    {
      if (Test-MediantDevice -Mediant $Mediant -Credential $Credential -http $http)
      {
        $result = Invoke-MediantWebRequest @parameters
        
        $result = [System.Text.Encoding]::UTF8.GetString($result.Content)
        
        $result = ($result -replace "GET /topAreaStaus.json").trim()
            #$config = $config -replace '\[ ','['
            #$config = $config -replace ' \]',']'
            #$config = $config.trim()
            #$config
            #$config -replace '[\*'
            #$config
            #$test = @"
            #$config
            #"@
         if($PSBoundParameters.filepath) 
         {

          Out-File -FilePath $filepath -InputObject ($result).trim()
         }
         else 
         { 
         return $result     
         }
      }
      Else
      {
        return $null
      }   
    }
  }
}

#TODO: set-MediantDeviceFileCliScript
Function Set-xMediantDeviceFileCliScript 
{
  [CmdletBinding(DefaultParameterSetName='MediantDeviceFull', SupportsShouldProcess=$true, ConfirmImpact='medium')]
  
  param(
    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceFull',Position = 0)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceIncremental',Position = 0)]
    [MediantDevice]$MediantDevice, 
    
    [Parameter(Mandatory=$true, ParameterSetName='MediantFull',Position = 0)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantIncremental',Position = 0)]
    [string]$Mediant,

    [Parameter(Mandatory=$true, ParameterSetName='MediantFullCli',Position = 1)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantIncremental',Position = 1)]
    [pscredential]$Credential,
   
    [Parameter(Mandatory=$true, ParameterSetName='MediantFull',Position = 2)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantIncremental',Position = 2)]
    [ValidateSet('http', 'https')]
    [string]$Http,
    
    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceFull',Position = 1)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantFull',Position = 3)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceIncremental',Position = 1)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantIncremental',Position = 3)]
    [ValidateSet('Full', 'Incremental')]
    [String]$FileType
        
    
  )
 

  Begin
  {
    Write-Warning -Message "Not Implemented Yet" -WarningAction Inquire
    if($PSBoundParameters.MediantDevice)
    {
      $Mediant     =  $MediantDevice.Mediant
      $Credential  =  $MediantDevice.Credential
      $http        =  $MediantDevice.http
    }   

    $parameters            =  @{ }        
    $parameters.mediant    =  $Mediant    
    $parameters.action     =  "/api/v1/files/cliScript"
    
    if($PSBoundParameters.MediantDeviceFull)         { $parameters.action  =  "/api/v1/files/cliScript" }
    if($PSBoundParameters.MediantDeviceIncremental)  { $parameters.action  =  "/api/v1/files/cliScript/incremental" }
    if($PSBoundParameters.MediantFull)               { $parameters.action  =  "/api/v1/files/cliScript" }
    if($PSBoundParameters.MediantIncremental)        { $parameters.action  =  "/api/v1/files/cliScript/incremental" }
    
    $parameters.credential =  $Credential
    $parameters.method     =  "get"
    $parameters.http       =  $http    

  }    
 
  Process
  {
    if ($pscmdlet.ShouldProcess("$Mediant"))
    {
      if (Test-MediantDevice -Mediant $Mediant -Credential $Credential -http $http)
      {
        $result = (Invoke-MediantWebRequest @parameters)
        return $result     
      }
      Else
      {
        return $null
      }   
    }
  }
}

#endregion 

#region File - CoderTable

#TODO: get-xMediantDeviceFileCoderTable
Function get-xMediantDeviceFileCoderTable
{
  [CmdletBinding(DefaultParameterSetName='MediantDevice', SupportsShouldProcess=$true, ConfirmImpact='medium')]
  
  param(
    [Parameter(Mandatory=$true, ParameterSetName='MediantDevice',Position = 0)]
    [MediantDevice]$MediantDevice, 
    
    [Parameter(Mandatory=$true, ParameterSetName='Mediant',Position = 0)]
    [string]$Mediant,

    [Parameter(Mandatory=$true, ParameterSetName='Mediant',Position = 1)]
    [pscredential]$Credential,
   
    [Parameter(Mandatory=$false, ParameterSetName='Mediant',Position = 2)]
    [ValidateSet('http', 'https')]
    [string]$Http = "http" 
  )
  Begin
  {
    Write-Warning -Message "Not Implemented Yet" -WarningAction Inquire
    if($PSBoundParameters.MediantDevice)
    {
      $Mediant     =  $MediantDevice.Mediant
      $Credential  =  $MediantDevice.Credential
      $http        =  $MediantDevice.http
    }   

    $parameters            =  @{ }        
    $parameters.mediant    =  $Mediant    
    $parameters.action     =  "/api/v1/files/coderTable"
    $parameters.credential =  $Credential
    $parameters.method     =  "get"
    $parameters.http       =  $http    

  }    
 
  Process
  {
    if ($pscmdlet.ShouldProcess("$Mediant"))
    {
      if (Test-MediantDevice -Mediant $Mediant -Credential $Credential -http $http)
      {
        $result = (Invoke-MediantWebRequest @parameters)
        return $result     
      }
      Else
      {
        return $null
      }   
    }
  }
}

#TODO: set-xMediantDeviceFileCoderTable
Function set-xMediantDeviceFileCoderTable
{
  [CmdletBinding(DefaultParameterSetName='MediantDeviceImmediate', SupportsShouldProcess=$true, ConfirmImpact='medium')]
  
  param(
    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceImmediate',Position = 0)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceHitless',Position = 0)]
    [MediantDevice]$MediantDevice, 
    
    [Parameter(Mandatory=$true, ParameterSetName='MediantImmediate',Position = 0)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantHitless',Position = 0)]
    [string]$Mediant,

    [Parameter(Mandatory=$true, ParameterSetName='MediantImmediate',Position = 1)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantHitless',Position = 1)]
    [pscredential]$Credential,
   
    [Parameter(Mandatory=$true, ParameterSetName='MediantImmediate',Position = 2)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantHitless',Position = 2)]
    [ValidateSet('http', 'https')]
    [string]$Http,
    
    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceImmediate',Position = 1)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantImmediate',Position = 3)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceHitless',Position = 1)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantHitless',Position = 3)]
    [ValidateSet('Immediate', 'Hitless')]
    [String]$LoadType
     
  )
  Begin
  {
    Write-Warning -Message "Not Implemented Yet" -WarningAction Inquire
    if($PSBoundParameters.MediantDevice)
    {
      $Mediant     =  $MediantDevice.Mediant
      $Credential  =  $MediantDevice.Credential
      $http        =  $MediantDevice.http
    }   

    $parameters            =  @{ }        
    $parameters.mediant    =  $Mediant    
   
    if($PSBoundParameters.MediantDeviceImmediate) { $parameters.action  =  "/api/v1/files/coderTable" }
    if($PSBoundParameters.MediantDeviceHitless)   { $parameters.action  =  "/api/v1/files/coderTable/hitless" }
    if($PSBoundParameters.MediantImmediate)       { $parameters.action  =  "/api/v1/files/coderTable" }
    if($PSBoundParameters.MediantHitless)         { $parameters.action  =  "/api/v1/files/coderTable/hitless" }
    
    $parameters.credential =  $Credential
    $parameters.method     =  "get"
    $parameters.http       =  $http    

  }    
 
  Process
  {
    if ($pscmdlet.ShouldProcess("$Mediant"))
    {
      if (Test-MediantDevice -Mediant $Mediant -Credential $Credential -http $http)
      {
        $result = (Invoke-MediantWebRequest @parameters)
        return $result     
      }
      Else
      {
        return $null
      }   
    }
  }
}

#endregion 

#region File - CPTTable
#TODO: get-xMediantDeviceFileCPT
Function get-xMediantDeviceFileCPT
{
  [CmdletBinding(DefaultParameterSetName='MediantDevice', SupportsShouldProcess=$true, ConfirmImpact='medium')]
  
  param(
    [Parameter(Mandatory=$true, ParameterSetName='MediantDevice',Position = 0)]
    [MediantDevice]$MediantDevice, 
    
    [Parameter(Mandatory=$true, ParameterSetName='Mediant',Position = 0)]
    [string]$Mediant,

    [Parameter(Mandatory=$true, ParameterSetName='Mediant',Position = 1)]
    [pscredential]$Credential,
   
    [Parameter(Mandatory=$false, ParameterSetName='Mediant',Position = 2)]
    [ValidateSet('http', 'https')]
    [string]$Http = "http" 
  )
  Begin
  {
    Write-Warning -Message "Not Implemented Yet" -WarningAction Inquire
    if($PSBoundParameters.MediantDevice)
    {
      $Mediant     =  $MediantDevice.Mediant
      $Credential  =  $MediantDevice.Credential
      $http        =  $MediantDevice.http
    }   

    $parameters            =  @{ }        
    $parameters.mediant    =  $Mediant    
    $parameters.action     =  "/api/v1/files/cpt"
    $parameters.credential =  $Credential
    $parameters.method     =  "get"
    $parameters.http       =  $http    

  }    
 
  Process
  {
    if ($pscmdlet.ShouldProcess("$Mediant"))
    {
      if (Test-MediantDevice -Mediant $Mediant -Credential $Credential -http $http)
      {
        $result = (Invoke-MediantWebRequest @parameters)
        return $result     
      }
      Else
      {
        return $null
      }   
    }
  }
}

#TODO: set-xMediantDeviceFileCPT
Function set-xMediantDeviceFileCPT
{
  [CmdletBinding(DefaultParameterSetName='MediantDeviceImmediate', SupportsShouldProcess=$true, ConfirmImpact='medium')]
  
  param(
    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceImmediate',Position = 0)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceHitless',Position = 0)]
    [MediantDevice]$MediantDevice, 
    
    [Parameter(Mandatory=$true, ParameterSetName='MediantImmediate',Position = 0)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantHitless',Position = 0)]
    [string]$Mediant,

    [Parameter(Mandatory=$true, ParameterSetName='MediantImmediate',Position = 1)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantHitless',Position = 1)]
    [pscredential]$Credential,
   
    [Parameter(Mandatory=$true, ParameterSetName='MediantImmediate',Position = 2)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantHitless',Position = 2)]
    [ValidateSet('http', 'https')]
    [string]$Http,
    
    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceImmediate',Position = 1)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantImmediate',Position = 3)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceHitless',Position = 1)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantHitless',Position = 3)]
    [ValidateSet('Immediate', 'Hitless')]
    [String]$LoadType
     
  )
  Begin
  {
    Write-Warning -Message "Not Implemented Yet" -WarningAction Inquire

    if($PSBoundParameters.MediantDevice)
    {
      $Mediant     =  $MediantDevice.Mediant
      $Credential  =  $MediantDevice.Credential
      $http        =  $MediantDevice.http
    }   

    $parameters            =  @{ }        
    $parameters.mediant    =  $Mediant    
   
    if($PSBoundParameters.MediantDeviceImmediate) { $parameters.action  =  "/api/v1/files/cpt" }
    if($PSBoundParameters.MediantDeviceHitless)   { $parameters.action  =  "/api/v1/files/cpt/hitless" }
    if($PSBoundParameters.MediantImmediate)       { $parameters.action  =  "/api/v1/files/cpt" }
    if($PSBoundParameters.MediantHitless)         { $parameters.action  =  "/api/v1/files/cpt/hitless" }

    $parameters.credential =  $Credential
    $parameters.method     =  "get"
    $parameters.http       =  $http    

  }    
 
  Process
  {
    if ($pscmdlet.ShouldProcess("$Mediant"))
    {
      if (Test-MediantDevice -Mediant $Mediant -Credential $Credential -http $http)
      {
        $result = (Invoke-MediantWebRequest @parameters)
        return $result     
      }
      Else
      {
        return $null
      }   
    }
  }
}
#endregion 

#region File - DialPlan
#TODO: get-xMediantDeviceFileDialPlan
Function get-xMediantDeviceFileDialPlan
{
  [CmdletBinding(DefaultParameterSetName='MediantDevice', SupportsShouldProcess=$true, ConfirmImpact='medium')]
  
  param(
    [Parameter(Mandatory=$true, ParameterSetName='MediantDevice',Position = 0)]
    [MediantDevice]$MediantDevice, 
    
    [Parameter(Mandatory=$true, ParameterSetName='Mediant',Position = 0)]
    [string]$Mediant,

    [Parameter(Mandatory=$true, ParameterSetName='Mediant',Position = 1)]
    [pscredential]$Credential,
   
    [Parameter(Mandatory=$false, ParameterSetName='Mediant',Position = 2)]
    [ValidateSet('http', 'https')]
    [string]$Http = "http" 
  )
  Begin
  {
    Write-Warning -Message "Not Implemented Yet" -WarningAction Inquire

    if($PSBoundParameters.MediantDevice)
    {
      $Mediant     =  $MediantDevice.Mediant
      $Credential  =  $MediantDevice.Credential
      $http        =  $MediantDevice.http
    }   

    $parameters            =  @{ }        
    $parameters.mediant    =  $Mediant    
    $parameters.action     =  "/api/v1/files/dialplan"
    $parameters.credential =  $Credential
    $parameters.method     =  "get"
    $parameters.http       =  $http    

  }    
 
  Process
  {
    if ($pscmdlet.ShouldProcess("$Mediant"))
    {
      if (Test-MediantDevice -Mediant $Mediant -Credential $Credential -http $http)
      {
        $result = (Invoke-MediantWebRequest @parameters)
        return $result     
      }
      Else
      {
        return $null
      }   
    }
  }
}

#TODO: set-xMediantDeviceFileDialPlan
Function set-xMediantDeviceFileDialPlan
{  
  [CmdletBinding(DefaultParameterSetName='MediantDeviceImmediate', SupportsShouldProcess=$true, ConfirmImpact='medium')]
  
  param(
    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceImmediate',Position = 0)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceHitless',Position = 0)]
    [MediantDevice]$MediantDevice, 
    
    [Parameter(Mandatory=$true, ParameterSetName='MediantImmediate',Position = 0)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantHitless',Position = 0)]
    [string]$Mediant,

    [Parameter(Mandatory=$true, ParameterSetName='MediantImmediate',Position = 1)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantHitless',Position = 1)]
    [pscredential]$Credential,
   
    [Parameter(Mandatory=$true, ParameterSetName='MediantImmediate',Position = 2)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantHitless',Position = 2)]
    [ValidateSet('http', 'https')]
    [string]$Http,
    
    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceImmediate',Position = 1)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantImmediate',Position = 3)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceHitless',Position = 1)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantHitless',Position = 3)]
    [ValidateSet('Immediate', 'Hitless')]
    [String]$LoadType
     
  )
  Begin
  {
    Write-Warning -Message "Not Implemented Yet" -WarningAction Inquire

    if($PSBoundParameters.MediantDevice)
    {
      $Mediant     =  $MediantDevice.Mediant
      $Credential  =  $MediantDevice.Credential
      $http        =  $MediantDevice.http
    }   

    $parameters            =  @{ }        
    $parameters.mediant    =  $Mediant    
 
    if($PSBoundParameters.MediantDeviceImmediate) { $parameters.action  =  "/api/v1/files/dialplan" }
    if($PSBoundParameters.MediantDeviceHitless)   { $parameters.action  =  "/api/v1/files/dialplan/hitless" }
    if($PSBoundParameters.MediantImmediate)       { $parameters.action  =  "/api/v1/files/dialplan" }
    if($PSBoundParameters.MediantHitless)         { $parameters.action  =  "/api/v1/files/dialplan/hitless" }

    $parameters.credential =  $Credential
    $parameters.method     =  "get"
    $parameters.http       =  $http    

  }    
 
  Process
  {
    if ($pscmdlet.ShouldProcess("$Mediant"))
    {
      if (Test-MediantDevice -Mediant $Mediant -Credential $Credential -http $http)
      {
        $result = (Invoke-MediantWebRequest @parameters)
        return $result     
      }
      Else
      {
        return $null
      }   
    }
  }
}
#endregion

#region File - FileINI
#TODO: get-xMediantDeviceFileIni
Function Get-MediantDeviceFileIni
{
  [CmdletBinding(DefaultParameterSetName='MediantDevice', SupportsShouldProcess=$true, ConfirmImpact='medium')]
  
  param(
    [Parameter(Mandatory=$true, ParameterSetName='MediantDevice',Position = 0)]
    [MediantDevice]$MediantDevice, 
    
    [Parameter(Mandatory=$true, ParameterSetName='Mediant',Position = 0)]
    [string]$Mediant,

    [Parameter(Mandatory=$true, ParameterSetName='Mediant',Position = 1)]
    [pscredential]$Credential,
   
    [Parameter(Mandatory=$false, ParameterSetName='Mediant',Position = 2)]
    [ValidateSet('http', 'https')]
    [string]$Http = "http",

    #TODO: Add Validate script to validate at lease folder location    
    [Parameter(Mandatory=$false, ParameterSetName='MediantDevice',Position = 1)]
    [Parameter(Mandatory=$false, ParameterSetName='Mediant',Position = 3)]
    [string]$filepath 

  )
  Begin
  {
   
    if($PSBoundParameters.MediantDevice)
    {
      $Mediant     =  $MediantDevice.Mediant
      $Credential  =  $MediantDevice.Credential
      $http        =  $MediantDevice.http
    }   

    $parameters            =  @{ }        
    $parameters.mediant    =  $Mediant    
    $parameters.action     =  "/api/v1/files/ini"
    $parameters.credential =  $Credential
    $parameters.method     =  "get"
    $parameters.http       =  $http    

  }    
 
  Process
  {
    if ($pscmdlet.ShouldProcess("$Mediant"))
    {
      if (Test-MediantDevice -Mediant $Mediant -Credential $Credential -http $http)
      {
        $result = Invoke-MediantWebRequest @parameters
        $result = [System.Text.Encoding]::UTF8.GetString($result.Content)
        $result = ($result -replace "GET /topAreaStaus.json").trim()
        $result = $result -replace '\[ ','['
        $result = $result -replace ' \]',']'
        $result = $result.trim()
            #$config
            #$config -replace '[\*'
            #$config
            #$test = @"
            #$config
            #"@
         if($PSBoundParameters.filepath) 
         {

          Out-File -FilePath $filepath -InputObject ($result).trim()
         }
         else 
         { 
         return $result     
         }
      }
      Else
      {
        return $null
      }   
    }
  }
}

#TODO: set-xMediantDeviceFileIni
Function set-xMediantDeviceFileIni 
{
  [CmdletBinding(DefaultParameterSetName='MediantDeviceFull', SupportsShouldProcess=$true, ConfirmImpact='medium')]
  
  param(
    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceFull',Position = 0)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceIncremental',Position = 0)]
    [MediantDevice]$MediantDevice, 
    
    [Parameter(Mandatory=$true, ParameterSetName='MediantFull',Position = 0)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantIncremental',Position = 0)]
    [string]$Mediant,

    [Parameter(Mandatory=$true, ParameterSetName='MediantFullCli',Position = 1)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantIncremental',Position = 1)]
    [pscredential]$Credential,
   
    [Parameter(Mandatory=$true, ParameterSetName='MediantFull',Position = 2)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantIncremental',Position = 2)]
    [ValidateSet('http', 'https')]
    [string]$Http,
    
    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceFull',Position = 1)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantFull',Position = 3)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceIncremental',Position = 1)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantIncremental',Position = 3)]
    [ValidateSet('Full', 'Incremental')]
    [String]$FileType,

    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceFull',Position = 1)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantFull',Position = 3)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceIncremental',Position = 1)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantIncremental',Position = 3)]
    [string]$filepath
        
  )
  Begin
  {
    Write-Warning -Message "Not Implemented Yet" -WarningAction Inquire

    if($PSBoundParameters.MediantDevice)
    {
      $Mediant     =  $MediantDevice.Mediant
      $Credential  =  $MediantDevice.Credential
      $http        =  $MediantDevice.http
    }   

    $parameters            =  @{ }        
    $parameters.mediant    =  $Mediant    
    
    if($PSBoundParameters.MediantDeviceFull)         { $parameters.action  =  "/api/v1/files/ini" }
    if($PSBoundParameters.MediantDeviceIncremental)  { $parameters.action  =  "/api/v1/files/ini/incremental" }
    if($PSBoundParameters.MediantFull)               { $parameters.action  =  "/api/v1/files/ini" }
    if($PSBoundParameters.MediantIncremental)        { $parameters.action  =  "/api/v1/files/ini/incremental" }

    $parameters.credential =  $Credential
    $parameters.method     =  "get"
    $parameters.http       =  $http    

  }    
 
  Process
  {
    if ($pscmdlet.ShouldProcess("$Mediant"))
    {
      if (Test-MediantDevice -Mediant $Mediant -Credential $Credential -http $http)
      {
        $result = (Invoke-MediantWebRequest @parameters)
        return $result     
      }
      Else
      {
        return $null
      }   
    }
  }
}
#endregion

#region File - FilePRT
#TODO: get-xMediantDeviceFileprt
Function get-xMediantDeviceFileprt
{
  [CmdletBinding(DefaultParameterSetName='MediantDevice', SupportsShouldProcess=$true, ConfirmImpact='medium')]
  
  param(
    [Parameter(Mandatory=$true, ParameterSetName='MediantDevice',Position = 0)]
    [MediantDevice]$MediantDevice, 
    
    [Parameter(Mandatory=$true, ParameterSetName='Mediant',Position = 0)]
    [string]$Mediant,

    [Parameter(Mandatory=$true, ParameterSetName='Mediant',Position = 1)]
    [pscredential]$Credential,
   
    [Parameter(Mandatory=$false, ParameterSetName='Mediant',Position = 2)]
    [ValidateSet('http', 'https')]
    [string]$Http = "http" 
  )
  Begin
  {
    Write-Warning -Message "Not Implemented Yet" -WarningAction Inquire

    if($PSBoundParameters.MediantDevice)
    {
      $Mediant     =  $MediantDevice.Mediant
      $Credential  =  $MediantDevice.Credential
      $http        =  $MediantDevice.http
    }   

    $parameters            =  @{ }        
    $parameters.mediant    =  $Mediant    
    $parameters.action     =  "/api/v1/files/prt"
    $parameters.credential =  $Credential
    $parameters.method     =  "get"
    $parameters.http       =  $http    

  }    
 
  Process
  {
    if ($pscmdlet.ShouldProcess("$Mediant"))
    {
      if (Test-MediantDevice -Mediant $Mediant -Credential $Credential -http $http)
      {
        $result = (Invoke-MediantWebRequest @parameters)
        return $result     
      }
      Else
      {
        return $null
      }   
    }
  }
}

#TODO: set-xMediantDeviceFileprt
Function set-xMediantDeviceFileprt
{
  [CmdletBinding(DefaultParameterSetName='MediantDeviceImmediate', SupportsShouldProcess=$true, ConfirmImpact='medium')]
  
  param(
    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceImmediate',Position = 0)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceHitless',Position = 0)]
    [MediantDevice]$MediantDevice, 
    
    [Parameter(Mandatory=$true, ParameterSetName='MediantImmediate',Position = 0)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantHitless',Position = 0)]
    [string]$Mediant,

    [Parameter(Mandatory=$true, ParameterSetName='MediantImmediate',Position = 1)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantHitless',Position = 1)]
    [pscredential]$Credential,
   
    [Parameter(Mandatory=$true, ParameterSetName='MediantImmediate',Position = 2)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantHitless',Position = 2)]
    [ValidateSet('http', 'https')]
    [string]$Http,
    
    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceImmediate',Position = 1)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantImmediate',Position = 3)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceHitless',Position = 1)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantHitless',Position = 3)]
    [ValidateSet('Immediate', 'Hitless')]
    [String]$LoadType
     
  )
  Begin
  {
    Write-Warning -Message "Not Implemented Yet" -WarningAction Inquire

    if($PSBoundParameters.MediantDevice)
    {
      $Mediant     =  $MediantDevice.Mediant
      $Credential  =  $MediantDevice.Credential
      $http        =  $MediantDevice.http
    }   

    $parameters            =  @{ }        
    $parameters.mediant    =  $Mediant    

    if($PSBoundParameters.MediantDeviceImmediate) { $parameters.action  =  "/api/v1/files/prt" }
    if($PSBoundParameters.MediantDeviceHitless)   { $parameters.action  =  "/api/v1/files/prt/hitless" }
    if($PSBoundParameters.MediantImmediate)       { $parameters.action  =  "/api/v1/files/prt" }
    if($PSBoundParameters.MediantHitless)         { $parameters.action  =  "/api/v1/files/prt/hitless" }

    $parameters.credential =  $Credential
    $parameters.method     =  "get"
    $parameters.http       =  $http    

  }    
 
  Process
  {
    if ($pscmdlet.ShouldProcess("$Mediant"))
    {
      if (Test-MediantDevice -Mediant $Mediant -Credential $Credential -http $http)
      {
        $result = (Invoke-MediantWebRequest @parameters)
        return $result     
      }
      Else
      {
        return $null
      }   
    }
  }
}
#endregion 

#region File - Software
#TODO: get-xMediantDeviceSoftware
Function get-xMediantDeviceSoftware
{
  [CmdletBinding(DefaultParameterSetName='MediantDevice', SupportsShouldProcess=$true, ConfirmImpact='medium')]
  
  param(
    [Parameter(Mandatory=$true, ParameterSetName='MediantDevice',Position = 0)]
    [MediantDevice]$MediantDevice, 
    
    [Parameter(Mandatory=$true, ParameterSetName='Mediant',Position = 0)]
    [string]$Mediant,

    [Parameter(Mandatory=$true, ParameterSetName='Mediant',Position = 1)]
    [pscredential]$Credential,
   
    [Parameter(Mandatory=$false, ParameterSetName='Mediant',Position = 2)]
    [ValidateSet('http', 'https')]
    [string]$Http = "http" 
  )
  Begin
  {
    Write-Warning -Message "Not Implemented Yet" -WarningAction Inquire

    if($PSBoundParameters.MediantDevice)
    {
      $Mediant     =  $MediantDevice.Mediant
      $Credential  =  $MediantDevice.Credential
      $http        =  $MediantDevice.http
    }   

    $parameters            =  @{ }        
    $parameters.mediant    =  $Mediant    
    $parameters.action     =  "/api/v1/files/software"
    $parameters.credential =  $Credential
    $parameters.method     =  "get"
    $parameters.http       =  $http    

  }    
 
  Process
  {
    if ($pscmdlet.ShouldProcess("$Mediant"))
    {
      if (Test-MediantDevice -Mediant $Mediant -Credential $Credential -http $http)
      {
        $result = (Invoke-MediantWebRequest @parameters)
        return $result     
      }
      Else
      {
        return $null
      }   
    }
  }
}

#TODO: set-xMediantDeviceSoftware
Function set-xMediantDeviceSoftware 
{
  [CmdletBinding(DefaultParameterSetName='MediantDeviceImmediate', SupportsShouldProcess=$true, ConfirmImpact='medium')]
  
  param(
    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceImmediate',Position = 0)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceHitless',Position = 0)]
    [MediantDevice]$MediantDevice, 
    
    [Parameter(Mandatory=$true, ParameterSetName='MediantImmediate',Position = 0)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantHitless',Position = 0)]
    [string]$Mediant,

    [Parameter(Mandatory=$true, ParameterSetName='MediantImmediate',Position = 1)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantHitless',Position = 1)]
    [pscredential]$Credential,
   
    [Parameter(Mandatory=$true, ParameterSetName='MediantImmediate',Position = 2)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantHitless',Position = 2)]
    [ValidateSet('http', 'https')]
    [string]$Http,
    
    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceImmediate',Position = 1)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantImmediate',Position = 3)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceHitless',Position = 1)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantHitless',Position = 3)]
    [ValidateSet('Immediate', 'Hitless')]
    [String]$LoadType
     
  )
 
  Begin
  {
    Write-Warning -Message "Not Implemented Yet" -WarningAction Inquire

    if($PSBoundParameters.MediantDevice)
    {
      $Mediant     =  $MediantDevice.Mediant
      $Credential  =  $MediantDevice.Credential
      $http        =  $MediantDevice.http
    }   

    $parameters            =  @{ }        
    $parameters.mediant    =  $Mediant    
 
    if($PSBoundParameters.MediantDeviceImmediate)   { $parameters.action  =  "/api/v1/files/software" }
    if($PSBoundParameters.MediantDeviceHitless)     { $parameters.action  =  "/api/v1/files/software/hitless" }
    if($PSBoundParameters.MediantImmediate)         { $parameters.action  =  "/api/v1/files/software" }
    if($PSBoundParameters.MediantHitless)           { $parameters.action  =  "/api/v1/files/software/hitless" }


    $parameters.credential =  $Credential
    $parameters.method     =  "get"
    $parameters.http       =  $http    

  }    
 
  Process
  {
    if ($pscmdlet.ShouldProcess("$Mediant"))
    {
      if (Test-MediantDevice -Mediant $Mediant -Credential $Credential -http $http)
      {
        $result = (Invoke-MediantWebRequest @parameters)
        return $result     
      }
      Else
      {
        return $null
      }   
    }
  }
}
#endregion 

#region File - UserInfo
#TODO: get-xMediantDeviceFileusersinfo
Function get-xMediantDeviceFileusersinfo
{
  [CmdletBinding(DefaultParameterSetName='MediantDevice', SupportsShouldProcess=$true, ConfirmImpact='medium')]
  
  param(
    [Parameter(Mandatory=$true, ParameterSetName='MediantDevice',Position = 0)]
    [MediantDevice]$MediantDevice, 
    
    [Parameter(Mandatory=$true, ParameterSetName='Mediant',Position = 0)]
    [string]$Mediant,

    [Parameter(Mandatory=$true, ParameterSetName='Mediant',Position = 1)]
    [pscredential]$Credential,
   
    [Parameter(Mandatory=$false, ParameterSetName='Mediant',Position = 2)]
    [ValidateSet('http', 'https')]
    [string]$Http = "http" 
  )
  Begin
  {
    Write-Warning -Message "Not Implemented Yet" -WarningAction Inquire

    if($PSBoundParameters.MediantDevice)
    {
      $Mediant     =  $MediantDevice.Mediant
      $Credential  =  $MediantDevice.Credential
      $http        =  $MediantDevice.http
    }   

    $parameters            =  @{ }        
    $parameters.mediant    =  $Mediant    
    $parameters.action     =  "/api/v1/files/usersinfo"
    $parameters.credential =  $Credential
    $parameters.method     =  "get"
    $parameters.http       =  $http    

  }    
 
  Process
  {
    if ($pscmdlet.ShouldProcess("$Mediant"))
    {
      if (Test-MediantDevice -Mediant $Mediant -Credential $Credential -http $http)
      {
        $result = (Invoke-MediantWebRequest @parameters)
        return $result     
      }
      Else
      {
        return $null
      }   
    }
  }
}

#TODO: set-xMediantDeviceFileusersinfo
Function set-xMediantDeviceFileusersinfo
{
  [CmdletBinding(DefaultParameterSetName='MediantDeviceImmediate', SupportsShouldProcess=$true, ConfirmImpact='medium')]
  
  param(
    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceImmediate',Position = 0)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceHitless',Position = 0)]
    [MediantDevice]$MediantDevice, 
    
    [Parameter(Mandatory=$true, ParameterSetName='MediantImmediate',Position = 0)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantHitless',Position = 0)]
    [string]$Mediant,

    [Parameter(Mandatory=$true, ParameterSetName='MediantImmediate',Position = 1)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantHitless',Position = 1)]
    [pscredential]$Credential,
   
    [Parameter(Mandatory=$true, ParameterSetName='MediantImmediate',Position = 2)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantHitless',Position = 2)]
    [ValidateSet('http', 'https')]
    [string]$Http,
    
    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceImmediate',Position = 1)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantImmediate',Position = 3)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceHitless',Position = 1)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantHitless',Position = 3)]
    [ValidateSet('Immediate', 'Hitless')]
    [String]$LoadType
     
  )
  Begin
  {
    Write-Warning -Message "Not Implemented Yet" -WarningAction Inquire

    if($PSBoundParameters.MediantDevice)
    {
      $Mediant     =  $MediantDevice.Mediant
      $Credential  =  $MediantDevice.Credential
      $http        =  $MediantDevice.http
    }   

    $parameters            =  @{ }        
    $parameters.mediant    =  $Mediant    
    $parameters.action     =  "/api/v1/files/usersinfo"

    if($PSBoundParameters.MediantDeviceImmediate) { $parameters.action  =  "/api/v1/files/usersinfo" }
    if($PSBoundParameters.MediantDeviceHitless)   { $parameters.action  =  "/api/v1/files/usersinfo/hitless" }
    if($PSBoundParameters.MediantImmediate)       { $parameters.action  =  "/api/v1/files/usersinfo" }
    if($PSBoundParameters.MediantHitless)         { $parameters.action  =  "/api/v1/files/usersinfo/hitless" }

    $parameters.credential =  $Credential
    $parameters.method     =  "get"
    $parameters.http       =  $http    

  }    
 
  Process
  {
    if ($pscmdlet.ShouldProcess("$Mediant"))
    {
      if (Test-MediantDevice -Mediant $Mediant -Credential $Credential -http $http)
      {
        $result = (Invoke-MediantWebRequest @parameters)
        return $result     
      }
      Else
      {
        return $null
      }   
    }
  }
}
#endregion 

#region File - Voice Prompts
#TODO: get-xMediantDeviceFileVoicePrompts
Function get-xMediantDeviceFileVoicePrompts
{
  [CmdletBinding(DefaultParameterSetName='MediantDevice', SupportsShouldProcess=$true, ConfirmImpact='medium')]
  
  param(
    [Parameter(Mandatory=$true, ParameterSetName='MediantDevice',Position = 0)]
    [MediantDevice]$MediantDevice, 
    
    [Parameter(Mandatory=$true, ParameterSetName='Mediant',Position = 0)]
    [string]$Mediant,

    [Parameter(Mandatory=$true, ParameterSetName='Mediant',Position = 1)]
    [pscredential]$Credential,
   
    [Parameter(Mandatory=$false, ParameterSetName='Mediant',Position = 2)]
    [ValidateSet('http', 'https')]
    [string]$Http = "http" 
  )
  Begin
  {
    Write-Warning -Message "Not Implemented Yet" -WarningAction Inquire

    if($PSBoundParameters.MediantDevice)
    {
      $Mediant     =  $MediantDevice.Mediant
      $Credential  =  $MediantDevice.Credential
      $http        =  $MediantDevice.http
    }   

    $parameters            =  @{ }        
    $parameters.mediant    =  $Mediant    
    $parameters.action     =  "/api/v1/files/voicePrompts"
    $parameters.credential =  $Credential
    $parameters.method     =  "Get"
    $parameters.http       =  $http    

  }    
 
  Process
  {
    if ($pscmdlet.ShouldProcess("$Mediant"))
    {
      if (Test-MediantDevice -Mediant $Mediant -Credential $Credential -http $http)
      {
        $result = (Invoke-MediantWebRequest @parameters)
        return $result     
      }
      Else
      {
        return $null
      }   
    }
  }
}

#TODO: set-xMediantDeviceFileVoicePrompts
Function set-xMediantDeviceFileVoicePrompts
{
  [CmdletBinding(DefaultParameterSetName='MediantDeviceImmediate', SupportsShouldProcess=$true, ConfirmImpact='medium')]
  
  param(
    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceImmediate',Position = 0)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceHitless',Position = 0)]
    [MediantDevice]$MediantDevice, 
    
    [Parameter(Mandatory=$true, ParameterSetName='MediantImmediate',Position = 0)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantHitless',Position = 0)]
    [string]$Mediant,

    [Parameter(Mandatory=$true, ParameterSetName='MediantImmediate',Position = 1)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantHitless',Position = 1)]
    [pscredential]$Credential,
   
    [Parameter(Mandatory=$true, ParameterSetName='MediantImmediate',Position = 2)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantHitless',Position = 2)]
    [ValidateSet('http', 'https')]
    [string]$Http,
    
    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceImmediate',Position = 1)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantImmediate',Position = 3)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantDeviceHitless',Position = 1)]
    [Parameter(Mandatory=$true, ParameterSetName='MediantHitless',Position = 3)]
    [ValidateSet('Immediate', 'Hitless')]
    [String]$LoadType
     
  )
  Begin
  {
    Write-Warning -Message "Not Implemented Yet" -WarningAction Inquire

    if($PSBoundParameters.MediantDevice)
    {
      $Mediant     =  $MediantDevice.Mediant
      $Credential  =  $MediantDevice.Credential
      $http        =  $MediantDevice.http
    }   

    $parameters            =  @{ }        
    $parameters.mediant    =  $Mediant    

    if($PSBoundParameters.MediantDeviceImmediate) { $parameters.action  =  "/api/v1/files/VoicePrompts" }
    if($PSBoundParameters.MediantDeviceHitless)   { $parameters.action  =  "/api/v1/files/VoicePrompts/hitless" }
    if($PSBoundParameters.MediantImmediate)       { $parameters.action  =  "/api/v1/files/VoicePrompts" }
    if($PSBoundParameters.MediantHitless)         { $parameters.action  =  "/api/v1/files/VoicePrompts/hitless" }

    
    $parameters.credential =  $Credential
    $parameters.method     =  "Get"
    $parameters.http       =  $http    

  }    
 
  Process
  {
    if ($pscmdlet.ShouldProcess("$Mediant"))
    {
      if (Test-MediantDevice -Mediant $Mediant -Credential $Credential -http $http)
      {
        $result = (Invoke-MediantWebRequest @parameters)
        return $result     
      }
      Else
      {
        return $null
      }   
    }
  }
}

#endregion


#####


function Get-xMediantAlarm
{
  Param(
    [Parameter(Mandatory=$true, ParameterSetName='Default')]
    [string]$Mediant,

    [Parameter(Mandatory=$true, ParameterSetName='Default')]
    [pscredential]$Credential,
        
    [Parameter(Mandatory=$false, ParameterSetName='Default')]
    [ValidateSet('http', 'https')]
    [string]$Http = "http",
    
    [Parameter(Mandatory=$true, ParameterSetName='Default')]
    [ValidateSet('active', 'history')]
    [string]$alarm,
    
    [Parameter(Mandatory=$false, ParameterSetName='Default')]
    [int]$alarmlimit = 20,
    
    [Parameter(Mandatory=$false, ParameterSetName='Default')]
    [int]$alarmafter,
    
    [Parameter(Mandatory=$false, ParameterSetName='Default')]
    [int]$alarmbefore
    
    
  )
  
  Begin
  {
    if(!(Test-MediantDevice -Mediant $Mediant -Credential $Credential -Http $http)) 
    {
      $result = [MediantWebRequest]::new($Mediant,"Unknown","Unable to Connect",$Null )
      break
    } 
    
    $parameters             =  @{}
    $parameters.mediant     =  $mediant
    $parameters.Credential  =  $Credential
    $parameters.http        =  $Http
    $parameters.Method      =  "Get"
    $parameters.action      =  "/api/v1/alarms/$($alarm)/?limit=$($alarmlimit)"
    if($PSBoundParameters.ContainsKey("alarmafter")) { $parameters.action = $parameters.action + "&after=$alarmafter"}
    if($PSBoundParameters.ContainsKey("alarmbefore")) { $parameters.action = $parameters.action + "&before=$alarmbefore"}
  }
  Process
  {
    $webrequest = Invoke-MediantWebRequest @Parameters
    if ($webrequest.StatusCode -eq 204) 
    {
      $result = [MediantAlarmStatus]::new([string]$webrequest.Mediant,[string]$webrequest.StatusCode,[string]$webrequest.StatusDescription,[string]$webrequest.rawcontent) 
    }
    else 
    { 
      $result = [mediantalarmstatus]::new([string]$webrequest.Mediant,[string]$webrequest.StatusCode,[string]$webrequest.StatusDescription,[string]$webrequest.rawcontent)
      $result.before =($webrequest.RawContent | convertfrom-json).cursor.before
      $result.after =($webrequest.RawContent | convertfrom-json).cursor.after
      foreach ($child in (($webrequest.rawcontent | convertfrom-json).alarms ) ) {
        $parameters.action      =  "$($child.url)"
        $childresult =   ( (Invoke-MediantWebRequest @Parameters).rawcontent | Convertfrom-json)
        $result.alarms += [MediantAlarm]::new($childresult.id,$childresult.description,$childresult.severity,$childresult.source,$childresult.date)
      }
    }
  }
  End
  {
    return $result
  }
}

function Get-xMediantPerformanceMonitoring
{
  [cmdletBinding()]
  Param(
    [Parameter(Mandatory=$true, ParameterSetName='Default')]
    [Parameter(Mandatory=$true, ParameterSetName='Specific')]
    [string]$Mediant,

    [Parameter(Mandatory=$true, ParameterSetName='Default')]
    [Parameter(Mandatory=$true, ParameterSetName='Specific')]
    [pscredential]$Credential,
        
    [Parameter(Mandatory=$false, ParameterSetName='Default')]
    [Parameter(Mandatory=$true, ParameterSetName='Specific')]
    [ValidateSet('http', 'https')]
    [string]$Http = "http",
  
    [Parameter(Mandatory=$true, ParameterSetName='Specific')]
    [ValidateSet('Realtime', 'average','averageprev')]
    [string]$interval
  )
  DynamicParam {
    # Set the dynamic parameters' name
    $ParameterName = 'PerfomanceMonitor'
            
    # Create the dictionary 
    $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

    # Create the collection of attributes
    $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
            
    # Create and set the parameters' attributes
    $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
    $ParameterAttribute.ParameterSetName = 'Specific'
    $ParameterAttribute.Mandatory = $true

    # Add the attributes to the attributes collection
    $AttributeCollection.Add($ParameterAttribute)

    # Generate and set the ValidateSet 
    $arrSet = ((Invoke-MediantWebRequest -Mediant $Mediant -Credential $Credential -Http $http -method Get -action "/api/v1/performanceMonitoring").rawcontent | convertfrom-json).items
    $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)

    # Add the ValidateSet to the attributes collection
    $AttributeCollection.Add($ValidateSetAttribute)

    # Create and return the dynamic parameter
    $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterName, [string], $AttributeCollection)
    $RuntimeParameterDictionary.Add($ParameterName, $RuntimeParameter)
    return $RuntimeParameterDictionary
  }
    
  Begin
  {
    $a = $PSBoundParameters[$ParameterName]
    $a 
    pause
    if(!(Test-MediantDevice -Mediant $Mediant -Credential $Credential -Http $http)) 
    {
      $result = [MediantWebRequest]::new($Mediant,"Unknown","Unable to Connect",$Null )
      break
    } 
    
    $parameters             =  @{}
    $parameters.mediant     =  $mediant
    $parameters.Credential  =  $Credential
    $parameters.http        =  $Http
    $parameters.Method      =  "Get"
    $parameters.action      =  "/api/v1/performanceMonitoring"
    
  }
  Process
  {
    $result = Invoke-MediantWebRequest @Parameters
  
  }
  End
  {
    return $result
  }
}

Export-ModuleMember -Function *-MediantDevice*



# SIG # Begin signature block
# MIINHwYJKoZIhvcNAQcCoIINEDCCDQwCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUnlvg8Rq29fp6XAt4uEJ77wpn
# 93KgggphMIIFKTCCBBGgAwIBAgIQBtrXAjG3P3o2mevBuCybGjANBgkqhkiG9w0B
# AQsFADByMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYD
# VQQLExB3d3cuZGlnaWNlcnQuY29tMTEwLwYDVQQDEyhEaWdpQ2VydCBTSEEyIEFz
# c3VyZWQgSUQgQ29kZSBTaWduaW5nIENBMB4XDTE2MTEyOTAwMDAwMFoXDTE3MDcy
# NjEyMDAwMFowZjELMAkGA1UEBhMCQVUxEzARBgNVBAgTClF1ZWVuc2xhbmQxGDAW
# BgNVBAcTD1JvY2hlZGFsZSBTb3V0aDETMBEGA1UEChMKU2hhbmUgSG9leTETMBEG
# A1UEAxMKU2hhbmUgSG9leTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEB
# AOsExz13+X9SULNh4fMOlgXkIjamyX4V06nbovEhDExinPBskdqBDaO303z0OJhi
# DNys4lF6LSFFFbKI8G4xNl2wIGnrmvVRJoXR2soaBPsi2AQbBlonZz79zlt/mG+/
# Y/fzZpvbHj+1zzXHkHMx7VRQUqw9UWNfruWtSoQQijVma/8M5SE3gBFw+AEwsnNw
# 9jDT1R/9sqoieFggryMuriojhiFiSywST7f+OmC77le2Lv9oU60TTaJ6qrah1bSi
# 3IwhHC55sK0hTZtj1IlKAxPi65LE/4ovb9EIGpXKrnNYZxcrCTI0xarcre3/L4sE
# W93dWk4i0j3N3/laZLywnKsCAwEAAaOCAcUwggHBMB8GA1UdIwQYMBaAFFrEuXsq
# CqOl6nEDwGD5LfZldQ5YMB0GA1UdDgQWBBR+/7sqnyudbphzUWqZRcvrqLUejTAO
# BgNVHQ8BAf8EBAMCB4AwEwYDVR0lBAwwCgYIKwYBBQUHAwMwdwYDVR0fBHAwbjA1
# oDOgMYYvaHR0cDovL2NybDMuZGlnaWNlcnQuY29tL3NoYTItYXNzdXJlZC1jcy1n
# MS5jcmwwNaAzoDGGL2h0dHA6Ly9jcmw0LmRpZ2ljZXJ0LmNvbS9zaGEyLWFzc3Vy
# ZWQtY3MtZzEuY3JsMEwGA1UdIARFMEMwNwYJYIZIAYb9bAMBMCowKAYIKwYBBQUH
# AgEWHGh0dHBzOi8vd3d3LmRpZ2ljZXJ0LmNvbS9DUFMwCAYGZ4EMAQQBMIGEBggr
# BgEFBQcBAQR4MHYwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNv
# bTBOBggrBgEFBQcwAoZCaHR0cDovL2NhY2VydHMuZGlnaWNlcnQuY29tL0RpZ2lD
# ZXJ0U0hBMkFzc3VyZWRJRENvZGVTaWduaW5nQ0EuY3J0MAwGA1UdEwEB/wQCMAAw
# DQYJKoZIhvcNAQELBQADggEBANWLmn9cs2FEYtHRn2bJiktq79MnOcKeCBHDR3Ht
# zV11kdfc9InOGHBNE9s7Ot6mD2pxHkjzLlxTqMrSHnlDcXg782jWHH53oMjryUQo
# ur6cOXQwVSFVhq9kVXpgRsPyqd73PBdXWgmz3cS17pzmfHgPLbmjP7m9BoucKbB4
# lrhtfNaim/de5XdBO2QbaQ/9AqNAiJq77XmQ9v39NrJUx9pN2nv89Z7zihnrQoxD
# AnwqDiatXfJsJVHYjxqkatZFeHpodWTjhU7XIeq/pfOqw1Cw4n0MgXF61p5WPHWo
# W6WgbMGVbNzXOY9Bncn5zbjNgJh3B69/3m6aa2qigWG68a0wggUwMIIEGKADAgEC
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
# aWduaW5nIENBAhAG2tcCMbc/ejaZ68G4LJsaMAkGBSsOAwIaBQCgeDAYBgorBgEE
# AYI3AgEMMQowCKACgAChAoAAMBkGCSqGSIb3DQEJAzEMBgorBgEEAYI3AgEEMBwG
# CisGAQQBgjcCAQsxDjAMBgorBgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBQPf5WN
# ypqJAeq1LTEoh1aDRNes8jANBgkqhkiG9w0BAQEFAASCAQDgy4avtok8a7MWDgpV
# zBbA8xN5lJzWzhdEmoqL6dNi09wfJU2FHNBMZkS9R3a/XlwBk2oh8iDSgViVTpUz
# 0Wus6dLQbjSNkgFU7I/ReIunJkdqll+ggKOxXitXz9yc8YvB70BtPNG0MMaz8RuO
# Q0yI0/hKQS5AUsFqKTtfqGdG5F+GJ683HbWc1b/8f4LZnHhXmKYWeRDZiEaNxGmo
# OoLlhr6AQEnndntulIukXDreQ9nT/5ADDVN3cnrwQ0R22aw4HnWcPMrbCAkRDfvs
# NQ1BvEp5BN6dxcWcHAOcK87dPf7sS35Biit9q+/3yTUv58fu/pWyahFY5YZH/176
# 4qHV
# SIG # End signature block
