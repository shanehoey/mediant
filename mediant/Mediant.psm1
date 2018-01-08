#requires -Version 5.0
<#
    Copyright (c) 2016-2018 Shane Hoey

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
  <#
    .SYNOPSIS
    Describe purpose of "Get-MediantDevice" in 1-2 sentences.

    .DESCRIPTION
    Add a more complete description of what the function does.

    .PARAMETER Mediant
    Describe parameter -Mediant.

    .PARAMETER Credential
    Describe parameter -Credential.

    .PARAMETER Http
    Describe parameter -Http.

    .EXAMPLE
    Get-MediantDevice -Mediant Value -Credential Value -Http Value
    Describe what this call does

    .NOTES
    Place additional notes here.

    .LINK
    URLs to related sites
    The first link is opened by Get-Help -Online Get-MediantDevice

    .INPUTS
    List of input types that are accepted by this function.

    .OUTPUTS
    List of output types produced by this function.
  #>


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
  <#
    .SYNOPSIS
    Describe purpose of "Test-MediantDevice" in 1-2 sentences.

    .DESCRIPTION
    Add a more complete description of what the function does.

    .PARAMETER MediantDevice
    Describe parameter -MediantDevice.

    .PARAMETER Mediant
    Describe parameter -Mediant.

    .PARAMETER Credential
    Describe parameter -Credential.

    .PARAMETER Http
    Describe parameter -Http.

    .EXAMPLE
    Test-MediantDevice -MediantDevice Value
    Describe what this call does

    .EXAMPLE
    Test-MediantDevice -Mediant Value -Credential Value -Http Value
    Describe what this call does

    .NOTES
    Place additional notes here.

    .LINK
    URLs to related sites
    The first link is opened by Get-Help -Online Test-MediantDevice

    .INPUTS
    List of input types that are accepted by this function.

    .OUTPUTS
    List of output types produced by this function.
  #>


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
    [string]$Http = 'http' 
  )
  Begin
  { 
    $api = '/api'
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
    $parameters.Method      =  'Get'
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
      if ($result.statuscode -eq '200') 
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
  <#
    .SYNOPSIS
    Describe purpose of "Restart-MediantDevice" in 1-2 sentences.

    .DESCRIPTION
    Add a more complete description of what the function does.

    .PARAMETER MediantDevice
    Describe parameter -MediantDevice.

    .PARAMETER Mediant
    Describe parameter -Mediant.

    .PARAMETER Credential
    Describe parameter -Credential.

    .PARAMETER Http
    Describe parameter -Http.

    .PARAMETER SaveConfiguration
    Describe parameter -SaveConfiguration.

    .PARAMETER TimeoutGraceful
    Describe parameter -TimeoutGraceful.

    .PARAMETER TimeoutSeconds
    Describe parameter -TimeoutSeconds.

    .PARAMETER TimeoutImmediate
    Describe parameter -TimeoutImmediate.

    .EXAMPLE
    Restart-MediantDevice -MediantDevice Value -SaveConfiguration Value -TimeoutGraceful
    Describe what this call does

    .EXAMPLE
    Restart-MediantDevice -Mediant Value -Credential Value -Http Value
    Describe what this call does

    .EXAMPLE
    Restart-MediantDevice -TimeoutSeconds Value
    Describe what this call does

    .EXAMPLE
    Restart-MediantDevice -TimeoutImmediate
    Describe what this call does

    .NOTES
    Place additional notes here.

    .LINK
    URLs to related sites
    The first link is opened by Get-Help -Online Restart-MediantDevice

    .INPUTS
    List of input types that are accepted by this function.

    .OUTPUTS
    List of output types produced by this function.
  #>


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
    $parameters.action     =  '/api/v1/actions/reset'
    $parameters.credential =  $Credential
    $parameters.method     =  'Post'
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
  <#
    .SYNOPSIS
    Describe purpose of "Save-MediantDevice" in 1-2 sentences.

    .DESCRIPTION
    Add a more complete description of what the function does.

    .PARAMETER MediantDevice
    Describe parameter -MediantDevice.

    .PARAMETER Mediant
    Describe parameter -Mediant.

    .PARAMETER Credential
    Describe parameter -Credential.

    .PARAMETER Http
    Describe parameter -Http.

    .EXAMPLE
    Save-MediantDevice -MediantDevice Value
    Describe what this call does

    .EXAMPLE
    Save-MediantDevice -Mediant Value -Credential Value -Http Value
    Describe what this call does

    .NOTES
    Place additional notes here.

    .LINK
    URLs to related sites
    The first link is opened by Get-Help -Online Save-MediantDevice

    .INPUTS
    List of input types that are accepted by this function.

    .OUTPUTS
    List of output types produced by this function.
  #>

 
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
    $parameters.action     =  '/api/v1/actions/saveConfiguration'
    $parameters.credential =  $Credential
    $parameters.method     =  'Post'
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
  <#
    .SYNOPSIS
    Describe purpose of "Get-MediantDeviceStatus" in 1-2 sentences.

    .DESCRIPTION
    Add a more complete description of what the function does.

    .PARAMETER MediantDevice
    Describe parameter -MediantDevice.

    .PARAMETER Mediant
    Describe parameter -Mediant.

    .PARAMETER Credential
    Describe parameter -Credential.

    .PARAMETER Http
    Describe parameter -Http.

    .EXAMPLE
    Get-MediantDeviceStatus -MediantDevice Value
    Describe what this call does

    .EXAMPLE
    Get-MediantDeviceStatus -Mediant Value -Credential Value -Http Value
    Describe what this call does

    .NOTES
    Place additional notes here.

    .LINK
    URLs to related sites
    The first link is opened by Get-Help -Online Get-MediantDeviceStatus

    .INPUTS
    List of input types that are accepted by this function.

    .OUTPUTS
    List of output types produced by this function.
  #>

 
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
    $parameters.action     =  '/api/v1/status'
    $parameters.credential =  $Credential
    $parameters.method     =  'Post'
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
  <#
    .SYNOPSIS
    Describe purpose of "Invoke-MediantWebRequest" in 1-2 sentences.

    .DESCRIPTION
    Add a more complete description of what the function does.

    .PARAMETER MediantDevice
    Describe parameter -MediantDevice.

    .PARAMETER Mediant
    Describe parameter -Mediant.

    .PARAMETER Credential
    Describe parameter -Credential.

    .PARAMETER http
    Describe parameter -http.

    .PARAMETER Method
    Describe parameter -Method.

    .PARAMETER Action
    Describe parameter -Action.

    .PARAMETER Body
    Describe parameter -Body.

    .EXAMPLE
    Invoke-MediantWebRequest -MediantDevice Value
    Describe what this call does

    .EXAMPLE
    Invoke-MediantWebRequest -Mediant Value -Credential Value -http Value -Method Value -Action Value -Body Value
    Describe what this call does

    .NOTES
    Place additional notes here.

    .LINK
    URLs to related sites
    The first link is opened by Get-Help -Online Invoke-MediantWebRequest

    .INPUTS
    List of input types that are accepted by this function.

    .OUTPUTS
    List of output types produced by this function.
  #>


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
        Write-Verbose  -Message "`n`n$($response.rawcontent)"
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
    [string]$Http = 'http' 
  )
  
  Begin
  {
    Write-Warning -Message 'Not Implemented Yet' -WarningAction Inquire
    
    if($PSBoundParameters.MediantDevice)
    {
      $Mediant     =  $MediantDevice.Mediant
      $Credential  =  $MediantDevice.Credential
      $http        =  $MediantDevice.http
    }   

    $parameters            =  @{ }        
    $parameters.mediant    =  $Mediant    
    $parameters.action     =  '/api/v1/files/amd'
    $parameters.credential =  $Credential
    $parameters.method     =  'get'
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
    Write-Warning -Message 'Not Implemented Yet' -WarningAction Inquire
    if($PSBoundParameters.MediantDevice)
    {
      $Mediant     =  $MediantDevice.Mediant
      $Credential  =  $MediantDevice.Credential
      $http        =  $MediantDevice.http
    }   

    $parameters            =  @{ }        
    $parameters.mediant    =  $Mediant    

    if($PSBoundParameters.MediantDeviceImmediate) { $parameters.action  =  '/api/v1/files/amd' }
    if($PSBoundParameters.MediantDeviceHitless)   { $parameters.action  =  '/api/v1/files/amd/hitless' }
    if($PSBoundParameters.MediantImmediate)       { $parameters.action  =  '/api/v1/files/amd' }
    if($PSBoundParameters.MediantHitless)         { $parameters.action  =  '/api/v1/files/amd/hitless' }

    $parameters.credential =  $Credential
    $parameters.method     =  'get'
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
    [string]$Http = 'http' 
  )
  Begin
  {
    Write-Warning -Message 'Not Implemented Yet' -WarningAction Inquire
    if($PSBoundParameters.MediantDevice)
    {
      $Mediant     =  $MediantDevice.Mediant
      $Credential  =  $MediantDevice.Credential
      $http        =  $MediantDevice.http
    }   

    $parameters            =  @{ }        
    $parameters.mediant    =  $Mediant    
    $parameters.action     =  '/api/v1/files/casTable'
    $parameters.credential =  $Credential
    $parameters.method     =  'get'
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
    Write-Warning -Message 'Not Implemented Yet' -WarningAction Inquire
    if($PSBoundParameters.MediantDevice)
    {
      $Mediant     =  $MediantDevice.Mediant
      $Credential  =  $MediantDevice.Credential
      $http        =  $MediantDevice.http
    }   

    $parameters            =  @{ }        
    $parameters.mediant    =  $Mediant    

    if($PSBoundParameters.MediantDeviceImmediate) { $parameters.action  =  '/api/v1/files/casTable' }
    if($PSBoundParameters.MediantDeviceHitless)   { $parameters.action  =  '/api/v1/files/casTable/hitless' }
    if($PSBoundParameters.MediantImmediate)       { $parameters.action  =  '/api/v1/files/casTable' }
    if($PSBoundParameters.MediantHitless)         { $parameters.action  =  '/api/v1/files/casTable/hitless' }
    
    $parameters.credential =  $Credential
    $parameters.method     =  'get'
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
  <#
    .SYNOPSIS
    Describe purpose of "Get-MediantDeviceFileCliScript" in 1-2 sentences.

    .DESCRIPTION
    Add a more complete description of what the function does.

    .PARAMETER MediantDevice
    Describe parameter -MediantDevice.

    .PARAMETER Mediant
    Describe parameter -Mediant.

    .PARAMETER Credential
    Describe parameter -Credential.

    .PARAMETER Http
    Describe parameter -Http.

    .PARAMETER filepath
    Describe parameter -filepath.

    .EXAMPLE
    Get-MediantDeviceFileCliScript -MediantDevice Value -filepath Value
    Describe what this call does

    .EXAMPLE
    Get-MediantDeviceFileCliScript -Mediant Value -Credential Value -Http Value
    Describe what this call does

    .NOTES
    Place additional notes here.

    .LINK
    URLs to related sites
    The first link is opened by Get-Help -Online Get-MediantDeviceFileCliScript

    .INPUTS
    List of input types that are accepted by this function.

    .OUTPUTS
    List of output types produced by this function.
  #>


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
    [string]$Http = 'http',

    #TODO: Add Validate script to validate at lease folder location    
    [Parameter(Mandatory=$false, ParameterSetName='MediantDevice',Position = 1)]
    [Parameter(Mandatory=$false, ParameterSetName='Mediant',Position = 3)]
    [string]$filepath 

  )
  Begin
  {
    Write-Warning -Message 'Not Implemented Yet' -WarningAction Inquire
    if($PSBoundParameters.MediantDevice)
    {
      $Mediant     =  $MediantDevice.Mediant
      $Credential  =  $MediantDevice.Credential
      $http        =  $MediantDevice.http
    }   

    $parameters            =  @{ }        
    $parameters.mediant    =  $Mediant    
    $parameters.action     =  '/api/v1/files/cliScript'
    $parameters.credential =  $Credential
    $parameters.method     =  'get'
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
        
        $result = ($result -replace 'GET /topAreaStaus.json').trim()
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
    Write-Warning -Message 'Not Implemented Yet' -WarningAction Inquire
    if($PSBoundParameters.MediantDevice)
    {
      $Mediant     =  $MediantDevice.Mediant
      $Credential  =  $MediantDevice.Credential
      $http        =  $MediantDevice.http
    }   

    $parameters            =  @{ }        
    $parameters.mediant    =  $Mediant    
    $parameters.action     =  '/api/v1/files/cliScript'
    
    if($PSBoundParameters.MediantDeviceFull)         { $parameters.action  =  '/api/v1/files/cliScript' }
    if($PSBoundParameters.MediantDeviceIncremental)  { $parameters.action  =  '/api/v1/files/cliScript/incremental' }
    if($PSBoundParameters.MediantFull)               { $parameters.action  =  '/api/v1/files/cliScript' }
    if($PSBoundParameters.MediantIncremental)        { $parameters.action  =  '/api/v1/files/cliScript/incremental' }
    
    $parameters.credential =  $Credential
    $parameters.method     =  'get'
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
    [string]$Http = 'http' 
  )
  Begin
  {
    Write-Warning -Message 'Not Implemented Yet' -WarningAction Inquire
    if($PSBoundParameters.MediantDevice)
    {
      $Mediant     =  $MediantDevice.Mediant
      $Credential  =  $MediantDevice.Credential
      $http        =  $MediantDevice.http
    }   

    $parameters            =  @{ }        
    $parameters.mediant    =  $Mediant    
    $parameters.action     =  '/api/v1/files/coderTable'
    $parameters.credential =  $Credential
    $parameters.method     =  'get'
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
    Write-Warning -Message 'Not Implemented Yet' -WarningAction Inquire
    if($PSBoundParameters.MediantDevice)
    {
      $Mediant     =  $MediantDevice.Mediant
      $Credential  =  $MediantDevice.Credential
      $http        =  $MediantDevice.http
    }   

    $parameters            =  @{ }        
    $parameters.mediant    =  $Mediant    
   
    if($PSBoundParameters.MediantDeviceImmediate) { $parameters.action  =  '/api/v1/files/coderTable' }
    if($PSBoundParameters.MediantDeviceHitless)   { $parameters.action  =  '/api/v1/files/coderTable/hitless' }
    if($PSBoundParameters.MediantImmediate)       { $parameters.action  =  '/api/v1/files/coderTable' }
    if($PSBoundParameters.MediantHitless)         { $parameters.action  =  '/api/v1/files/coderTable/hitless' }
    
    $parameters.credential =  $Credential
    $parameters.method     =  'get'
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
    [string]$Http = 'http' 
  )
  Begin
  {
    Write-Warning -Message 'Not Implemented Yet' -WarningAction Inquire
    if($PSBoundParameters.MediantDevice)
    {
      $Mediant     =  $MediantDevice.Mediant
      $Credential  =  $MediantDevice.Credential
      $http        =  $MediantDevice.http
    }   

    $parameters            =  @{ }        
    $parameters.mediant    =  $Mediant    
    $parameters.action     =  '/api/v1/files/cpt'
    $parameters.credential =  $Credential
    $parameters.method     =  'get'
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
    Write-Warning -Message 'Not Implemented Yet' -WarningAction Inquire

    if($PSBoundParameters.MediantDevice)
    {
      $Mediant     =  $MediantDevice.Mediant
      $Credential  =  $MediantDevice.Credential
      $http        =  $MediantDevice.http
    }   

    $parameters            =  @{ }        
    $parameters.mediant    =  $Mediant    
   
    if($PSBoundParameters.MediantDeviceImmediate) { $parameters.action  =  '/api/v1/files/cpt' }
    if($PSBoundParameters.MediantDeviceHitless)   { $parameters.action  =  '/api/v1/files/cpt/hitless' }
    if($PSBoundParameters.MediantImmediate)       { $parameters.action  =  '/api/v1/files/cpt' }
    if($PSBoundParameters.MediantHitless)         { $parameters.action  =  '/api/v1/files/cpt/hitless' }

    $parameters.credential =  $Credential
    $parameters.method     =  'get'
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
    [string]$Http = 'http' 
  )
  Begin
  {
    Write-Warning -Message 'Not Implemented Yet' -WarningAction Inquire

    if($PSBoundParameters.MediantDevice)
    {
      $Mediant     =  $MediantDevice.Mediant
      $Credential  =  $MediantDevice.Credential
      $http        =  $MediantDevice.http
    }   

    $parameters            =  @{ }        
    $parameters.mediant    =  $Mediant    
    $parameters.action     =  '/api/v1/files/dialplan'
    $parameters.credential =  $Credential
    $parameters.method     =  'get'
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
    Write-Warning -Message 'Not Implemented Yet' -WarningAction Inquire

    if($PSBoundParameters.MediantDevice)
    {
      $Mediant     =  $MediantDevice.Mediant
      $Credential  =  $MediantDevice.Credential
      $http        =  $MediantDevice.http
    }   

    $parameters            =  @{ }        
    $parameters.mediant    =  $Mediant    
 
    if($PSBoundParameters.MediantDeviceImmediate) { $parameters.action  =  '/api/v1/files/dialplan' }
    if($PSBoundParameters.MediantDeviceHitless)   { $parameters.action  =  '/api/v1/files/dialplan/hitless' }
    if($PSBoundParameters.MediantImmediate)       { $parameters.action  =  '/api/v1/files/dialplan' }
    if($PSBoundParameters.MediantHitless)         { $parameters.action  =  '/api/v1/files/dialplan/hitless' }

    $parameters.credential =  $Credential
    $parameters.method     =  'get'
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
  <#
    .SYNOPSIS
    Describe purpose of "Get-MediantDeviceFileIni" in 1-2 sentences.

    .DESCRIPTION
    Add a more complete description of what the function does.

    .PARAMETER MediantDevice
    Describe parameter -MediantDevice.

    .PARAMETER Mediant
    Describe parameter -Mediant.

    .PARAMETER Credential
    Describe parameter -Credential.

    .PARAMETER Http
    Describe parameter -Http.

    .PARAMETER filepath
    Describe parameter -filepath.

    .EXAMPLE
    Get-MediantDeviceFileIni -MediantDevice Value -filepath Value
    Describe what this call does

    .EXAMPLE
    Get-MediantDeviceFileIni -Mediant Value -Credential Value -Http Value
    Describe what this call does

    .NOTES
    Place additional notes here.

    .LINK
    URLs to related sites
    The first link is opened by Get-Help -Online Get-MediantDeviceFileIni

    .INPUTS
    List of input types that are accepted by this function.

    .OUTPUTS
    List of output types produced by this function.
  #>


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
    [string]$Http = 'http',

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
    $parameters.action     =  '/api/v1/files/ini'
    $parameters.credential =  $Credential
    $parameters.method     =  'get'
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
        $result = ($result -replace 'GET /topAreaStaus.json').trim()
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
    Write-Warning -Message 'Not Implemented Yet' -WarningAction Inquire

    if($PSBoundParameters.MediantDevice)
    {
      $Mediant     =  $MediantDevice.Mediant
      $Credential  =  $MediantDevice.Credential
      $http        =  $MediantDevice.http
    }   

    $parameters            =  @{ }        
    $parameters.mediant    =  $Mediant    
    
    if($PSBoundParameters.MediantDeviceFull)         { $parameters.action  =  '/api/v1/files/ini' }
    if($PSBoundParameters.MediantDeviceIncremental)  { $parameters.action  =  '/api/v1/files/ini/incremental' }
    if($PSBoundParameters.MediantFull)               { $parameters.action  =  '/api/v1/files/ini' }
    if($PSBoundParameters.MediantIncremental)        { $parameters.action  =  '/api/v1/files/ini/incremental' }

    $parameters.credential =  $Credential
    $parameters.method     =  'get'
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
    [string]$Http = 'http' 
  )
  Begin
  {
    Write-Warning -Message 'Not Implemented Yet' -WarningAction Inquire

    if($PSBoundParameters.MediantDevice)
    {
      $Mediant     =  $MediantDevice.Mediant
      $Credential  =  $MediantDevice.Credential
      $http        =  $MediantDevice.http
    }   

    $parameters            =  @{ }        
    $parameters.mediant    =  $Mediant    
    $parameters.action     =  '/api/v1/files/prt'
    $parameters.credential =  $Credential
    $parameters.method     =  'get'
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
    Write-Warning -Message 'Not Implemented Yet' -WarningAction Inquire

    if($PSBoundParameters.MediantDevice)
    {
      $Mediant     =  $MediantDevice.Mediant
      $Credential  =  $MediantDevice.Credential
      $http        =  $MediantDevice.http
    }   

    $parameters            =  @{ }        
    $parameters.mediant    =  $Mediant    

    if($PSBoundParameters.MediantDeviceImmediate) { $parameters.action  =  '/api/v1/files/prt' }
    if($PSBoundParameters.MediantDeviceHitless)   { $parameters.action  =  '/api/v1/files/prt/hitless' }
    if($PSBoundParameters.MediantImmediate)       { $parameters.action  =  '/api/v1/files/prt' }
    if($PSBoundParameters.MediantHitless)         { $parameters.action  =  '/api/v1/files/prt/hitless' }

    $parameters.credential =  $Credential
    $parameters.method     =  'get'
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
    [string]$Http = 'http' 
  )
  Begin
  {
    Write-Warning -Message 'Not Implemented Yet' -WarningAction Inquire

    if($PSBoundParameters.MediantDevice)
    {
      $Mediant     =  $MediantDevice.Mediant
      $Credential  =  $MediantDevice.Credential
      $http        =  $MediantDevice.http
    }   

    $parameters            =  @{ }        
    $parameters.mediant    =  $Mediant    
    $parameters.action     =  '/api/v1/files/software'
    $parameters.credential =  $Credential
    $parameters.method     =  'get'
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
    Write-Warning -Message 'Not Implemented Yet' -WarningAction Inquire

    if($PSBoundParameters.MediantDevice)
    {
      $Mediant     =  $MediantDevice.Mediant
      $Credential  =  $MediantDevice.Credential
      $http        =  $MediantDevice.http
    }   

    $parameters            =  @{ }        
    $parameters.mediant    =  $Mediant    
 
    if($PSBoundParameters.MediantDeviceImmediate)   { $parameters.action  =  '/api/v1/files/software' }
    if($PSBoundParameters.MediantDeviceHitless)     { $parameters.action  =  '/api/v1/files/software/hitless' }
    if($PSBoundParameters.MediantImmediate)         { $parameters.action  =  '/api/v1/files/software' }
    if($PSBoundParameters.MediantHitless)           { $parameters.action  =  '/api/v1/files/software/hitless' }


    $parameters.credential =  $Credential
    $parameters.method     =  'get'
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
    [string]$Http = 'http' 
  )
  Begin
  {
    Write-Warning -Message 'Not Implemented Yet' -WarningAction Inquire

    if($PSBoundParameters.MediantDevice)
    {
      $Mediant     =  $MediantDevice.Mediant
      $Credential  =  $MediantDevice.Credential
      $http        =  $MediantDevice.http
    }   

    $parameters            =  @{ }        
    $parameters.mediant    =  $Mediant    
    $parameters.action     =  '/api/v1/files/usersinfo'
    $parameters.credential =  $Credential
    $parameters.method     =  'get'
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
    Write-Warning -Message 'Not Implemented Yet' -WarningAction Inquire

    if($PSBoundParameters.MediantDevice)
    {
      $Mediant     =  $MediantDevice.Mediant
      $Credential  =  $MediantDevice.Credential
      $http        =  $MediantDevice.http
    }   

    $parameters            =  @{ }        
    $parameters.mediant    =  $Mediant    
    $parameters.action     =  '/api/v1/files/usersinfo'

    if($PSBoundParameters.MediantDeviceImmediate) { $parameters.action  =  '/api/v1/files/usersinfo' }
    if($PSBoundParameters.MediantDeviceHitless)   { $parameters.action  =  '/api/v1/files/usersinfo/hitless' }
    if($PSBoundParameters.MediantImmediate)       { $parameters.action  =  '/api/v1/files/usersinfo' }
    if($PSBoundParameters.MediantHitless)         { $parameters.action  =  '/api/v1/files/usersinfo/hitless' }

    $parameters.credential =  $Credential
    $parameters.method     =  'get'
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
    [string]$Http = 'http' 
  )
  Begin
  {
    Write-Warning -Message 'Not Implemented Yet' -WarningAction Inquire

    if($PSBoundParameters.MediantDevice)
    {
      $Mediant     =  $MediantDevice.Mediant
      $Credential  =  $MediantDevice.Credential
      $http        =  $MediantDevice.http
    }   

    $parameters            =  @{ }        
    $parameters.mediant    =  $Mediant    
    $parameters.action     =  '/api/v1/files/voicePrompts'
    $parameters.credential =  $Credential
    $parameters.method     =  'Get'
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
    Write-Warning -Message 'Not Implemented Yet' -WarningAction Inquire

    if($PSBoundParameters.MediantDevice)
    {
      $Mediant     =  $MediantDevice.Mediant
      $Credential  =  $MediantDevice.Credential
      $http        =  $MediantDevice.http
    }   

    $parameters            =  @{ }        
    $parameters.mediant    =  $Mediant    

    if($PSBoundParameters.MediantDeviceImmediate) { $parameters.action  =  '/api/v1/files/VoicePrompts' }
    if($PSBoundParameters.MediantDeviceHitless)   { $parameters.action  =  '/api/v1/files/VoicePrompts/hitless' }
    if($PSBoundParameters.MediantImmediate)       { $parameters.action  =  '/api/v1/files/VoicePrompts' }
    if($PSBoundParameters.MediantHitless)         { $parameters.action  =  '/api/v1/files/VoicePrompts/hitless' }

    
    $parameters.credential =  $Credential
    $parameters.method     =  'Get'
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
    [string]$Http = 'http',
    
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
      $result = [MediantWebRequest]::new($Mediant,'Unknown','Unable to Connect',$Null )
      break
    } 
    
    $parameters             =  @{}
    $parameters.mediant     =  $mediant
    $parameters.Credential  =  $Credential
    $parameters.http        =  $Http
    $parameters.Method      =  'Get'
    $parameters.action      =  "/api/v1/alarms/$($alarm)/?limit=$($alarmlimit)"
    if($PSBoundParameters.ContainsKey('alarmafter')) { $parameters.action = $parameters.action + "&after=$alarmafter"}
    if($PSBoundParameters.ContainsKey('alarmbefore')) { $parameters.action = $parameters.action + "&before=$alarmbefore"}
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
    [string]$Http = 'http',
  
    [Parameter(Mandatory=$true, ParameterSetName='Specific')]
    [ValidateSet('Realtime', 'average','averageprev')]
    [string]$interval
  )
  DynamicParam {
    # Set the dynamic parameters' name
    $ParameterName = 'PerfomanceMonitor'
            
    # Create the dictionary 
    $RuntimeParameterDictionary = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameterDictionary

    # Create the collection of attributes
    $AttributeCollection = New-Object -TypeName System.Collections.ObjectModel.Collection[System.Attribute]
            
    # Create and set the parameters' attributes
    $ParameterAttribute = New-Object -TypeName System.Management.Automation.ParameterAttribute
    $ParameterAttribute.ParameterSetName = 'Specific'
    $ParameterAttribute.Mandatory = $true

    # Add the attributes to the attributes collection
    $AttributeCollection.Add($ParameterAttribute)

    # Generate and set the ValidateSet 
    $arrSet = ((Invoke-MediantWebRequest -Mediant $Mediant -Credential $Credential -Http $http -method Get -action '/api/v1/performanceMonitoring').rawcontent | convertfrom-json).items
    $ValidateSetAttribute = New-Object -TypeName System.Management.Automation.ValidateSetAttribute -ArgumentList ($arrSet)

    # Add the ValidateSet to the attributes collection
    $AttributeCollection.Add($ValidateSetAttribute)

    # Create and return the dynamic parameter
    $RuntimeParameter = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameter -ArgumentList ($ParameterName, [string], $AttributeCollection)
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
      $result = [MediantWebRequest]::new($Mediant,'Unknown','Unable to Connect',$Null )
      break
    } 
    
    $parameters             =  @{}
    $parameters.mediant     =  $mediant
    $parameters.Credential  =  $Credential
    $parameters.http        =  $Http
    $parameters.Method      =  'Get'
    $parameters.action      =  '/api/v1/performanceMonitoring'
    
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
# MIINCgYJKoZIhvcNAQcCoIIM+zCCDPcCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUvpM1GPENk26r2tU/WYVlT9S7
# kUKgggpMMIIFFDCCA/ygAwIBAgIQDq/cAHxKXBt+xmIx8FoOkTANBgkqhkiG9w0B
# AQsFADByMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYD
# VQQLExB3d3cuZGlnaWNlcnQuY29tMTEwLwYDVQQDEyhEaWdpQ2VydCBTSEEyIEFz
# c3VyZWQgSUQgQ29kZSBTaWduaW5nIENBMB4XDTE4MDEwMzAwMDAwMFoXDTE5MDEw
# ODEyMDAwMFowUTELMAkGA1UEBhMCQVUxGDAWBgNVBAcTD1JvY2hlZGFsZSBTb3V0
# aDETMBEGA1UEChMKU2hhbmUgSG9leTETMBEGA1UEAxMKU2hhbmUgSG9leTCCASIw
# DQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBANAI9q03Pl+EpWcVZ7PQ3AOJ17k6
# OoS9SCIbZprs7NhyRIg7mKzxdcHMnjKwUe/7NDlt5mYzXT2yY/0MeUkyspiEs1+t
# eiHJ6IIs9llWgPGOkV4Ro5fZzlutqeeaomEW/ulH7mVjihVCR6mP/O09YSNo0Dv4
# AltYmVXqhXTB64NdwupL2G8fmTmVUJsww9abtGxy3mhL/l2W3VBcozZbCZVw363p
# 9mjeR9WUz5AxZji042xldKB/97cNHd/2YyWuJ8eMlYfRqz1nVgmmpuU+SuApRult
# hy6wNEngVmJBVhH/a8AH29dEZNL9pzhJGRwGBFi+m/vIr5SFhQVFZYJy79kCAwEA
# AaOCAcUwggHBMB8GA1UdIwQYMBaAFFrEuXsqCqOl6nEDwGD5LfZldQ5YMB0GA1Ud
# DgQWBBROEIC6bKfPIk2DtUTZh7HSa5ajqDAOBgNVHQ8BAf8EBAMCB4AwEwYDVR0l
# BAwwCgYIKwYBBQUHAwMwdwYDVR0fBHAwbjA1oDOgMYYvaHR0cDovL2NybDMuZGln
# aWNlcnQuY29tL3NoYTItYXNzdXJlZC1jcy1nMS5jcmwwNaAzoDGGL2h0dHA6Ly9j
# cmw0LmRpZ2ljZXJ0LmNvbS9zaGEyLWFzc3VyZWQtY3MtZzEuY3JsMEwGA1UdIARF
# MEMwNwYJYIZIAYb9bAMBMCowKAYIKwYBBQUHAgEWHGh0dHBzOi8vd3d3LmRpZ2lj
# ZXJ0LmNvbS9DUFMwCAYGZ4EMAQQBMIGEBggrBgEFBQcBAQR4MHYwJAYIKwYBBQUH
# MAGGGGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNvbTBOBggrBgEFBQcwAoZCaHR0cDov
# L2NhY2VydHMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0U0hBMkFzc3VyZWRJRENvZGVT
# aWduaW5nQ0EuY3J0MAwGA1UdEwEB/wQCMAAwDQYJKoZIhvcNAQELBQADggEBAIly
# KESC2V2sBAl6sIQiHRRgQ9oQdtQamES3fVBNHwmsXl76DdjDURDNi6ptwve3FALo
# ROZHkrjTU+5r6GaOIopKwE4IXkboVoPBP0wJ4jcVm7kcfKJqllSBGZfpnSUjlaRp
# EE5k1XdVAGEoz+m0GG+tmb9gGblHUiCAnGWLw9bmRoGbJ20a0IQ8jZsiEq+91Ft3
# 1vJSBO2RRBgqHTama5GD16OyE3Aps5ypaKYXuq0cnNZCaCasRtDJPolSP4KQ+NVg
# Z/W/rDiO8LNOTDwGcZ2bYScAT88A5KX42wiKnKldmyXnd4ffrwWk8fPngR5sVhus
# Arv6TbwR8dRMGwXwQqMwggUwMIIEGKADAgECAhAECRgbX9W7ZnVTQ7VvlVAIMA0G
# CSqGSIb3DQEBCwUAMGUxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJ
# bmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xJDAiBgNVBAMTG0RpZ2lDZXJ0
# IEFzc3VyZWQgSUQgUm9vdCBDQTAeFw0xMzEwMjIxMjAwMDBaFw0yODEwMjIxMjAw
# MDBaMHIxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNV
# BAsTEHd3dy5kaWdpY2VydC5jb20xMTAvBgNVBAMTKERpZ2lDZXJ0IFNIQTIgQXNz
# dXJlZCBJRCBDb2RlIFNpZ25pbmcgQ0EwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAw
# ggEKAoIBAQD407Mcfw4Rr2d3B9MLMUkZz9D7RZmxOttE9X/lqJ3bMtdx6nadBS63
# j/qSQ8Cl+YnUNxnXtqrwnIal2CWsDnkoOn7p0WfTxvspJ8fTeyOU5JEjlpB3gvmh
# hCNmElQzUHSxKCa7JGnCwlLyFGeKiUXULaGj6YgsIJWuHEqHCN8M9eJNYBi+qsSy
# rnAxZjNxPqxwoqvOf+l8y5Kh5TsxHM/q8grkV7tKtel05iv+bMt+dDk2DZDv5LVO
# pKnqagqrhPOsZ061xPeM0SAlI+sIZD5SlsHyDxL0xY4PwaLoLFH3c7y9hbFig3NB
# ggfkOItqcyDQD2RzPJ6fpjOp/RnfJZPRAgMBAAGjggHNMIIByTASBgNVHRMBAf8E
# CDAGAQH/AgEAMA4GA1UdDwEB/wQEAwIBhjATBgNVHSUEDDAKBggrBgEFBQcDAzB5
# BggrBgEFBQcBAQRtMGswJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0
# LmNvbTBDBggrBgEFBQcwAoY3aHR0cDovL2NhY2VydHMuZGlnaWNlcnQuY29tL0Rp
# Z2lDZXJ0QXNzdXJlZElEUm9vdENBLmNydDCBgQYDVR0fBHoweDA6oDigNoY0aHR0
# cDovL2NybDQuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNzdXJlZElEUm9vdENBLmNy
# bDA6oDigNoY0aHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNzdXJl
# ZElEUm9vdENBLmNybDBPBgNVHSAESDBGMDgGCmCGSAGG/WwAAgQwKjAoBggrBgEF
# BQcCARYcaHR0cHM6Ly93d3cuZGlnaWNlcnQuY29tL0NQUzAKBghghkgBhv1sAzAd
# BgNVHQ4EFgQUWsS5eyoKo6XqcQPAYPkt9mV1DlgwHwYDVR0jBBgwFoAUReuir/SS
# y4IxLVGLp6chnfNtyA8wDQYJKoZIhvcNAQELBQADggEBAD7sDVoks/Mi0RXILHwl
# KXaoHV0cLToaxO8wYdd+C2D9wz0PxK+L/e8q3yBVN7Dh9tGSdQ9RtG6ljlriXiSB
# ThCk7j9xjmMOE0ut119EefM2FAaK95xGTlz/kLEbBw6RFfu6r7VRwo0kriTGxycq
# oSkoGjpxKAI8LpGjwCUR4pwUR6F6aGivm6dcIFzZcbEMj7uo+MUSaJ/PQMtARKUT
# 8OZkDCUIQjKyNookAv4vcn4c10lFluhZHen6dGRrsutmQ9qzsIzV6Q3d9gEgzpkx
# Yz0IGhizgZtPxpMQBvwHgfqL2vmCSfdibqFT+hKUGIUukpHqaGxEMrJmoecYpJpk
# Ue8xggIoMIICJAIBATCBhjByMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNl
# cnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMTEwLwYDVQQDEyhEaWdp
# Q2VydCBTSEEyIEFzc3VyZWQgSUQgQ29kZSBTaWduaW5nIENBAhAOr9wAfEpcG37G
# YjHwWg6RMAkGBSsOAwIaBQCgeDAYBgorBgEEAYI3AgEMMQowCKACgAChAoAAMBkG
# CSqGSIb3DQEJAzEMBgorBgEEAYI3AgEEMBwGCisGAQQBgjcCAQsxDjAMBgorBgEE
# AYI3AgEVMCMGCSqGSIb3DQEJBDEWBBT7yidjMhmaBwuaOU2vdPpSUqcd/DANBgkq
# hkiG9w0BAQEFAASCAQAEH/Wvw95/nkqOFxjSxlCUPxMyv2zbOOCoLx5hAY4sNpvq
# DNLVP6xG3e0jzpEwOz6llqKjAvTs1wJblzLAcVLKGgtBn7vIM0Sa4QSidFjmN8fy
# w+TIkOPWKJ/fqlmVBjXoATnzK5YnZ0ArdiqB80klEccAXRH63X2Wv/4+RnKT7dm/
# p5inA3p/ctN8uaAvhMZIj7PgazRnbIqOQiktNbhwHSBEEzkZkgHQuCuCvCN0MJWL
# PBQv7TCSwlMQ34iVczpXEIQlQLSwiIlyLQTS0mhw2FbGvSgMnzMwex5qv6slplcd
# l/tQWq3Ny+opQNNSwL10jpouAG+nyRj/y0O2vbxP
# SIG # End signature block
