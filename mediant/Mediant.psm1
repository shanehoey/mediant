#requires -Version 5.0
<#
    Copyright (c) 2016-2018 Shane Hoey

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#>

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
  [string]$http

  MediantDevice ([string]$Mediant,[pscredential]$Credential,[string]$http) 
  {
    $this.Mediant     = $Mediant
    $this.Credential  = $Credential
    $this.http        = $http
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
  [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'medium')]
  param(
    [Parameter(Mandatory = $true)]
    [string]$Mediant,
  
    [Parameter(Mandatory = $true)]
    [pscredential]$Credential,
  
    [Parameter(Mandatory = $true)]
    [ValidateSet('http', 'https')]
    [string]$http,
   
    [Parameter(Mandatory = $true)]
    [ValidateSet('Get', 'Put','Post','Delete')]
    [string]$Method,
      
    [Parameter(Mandatory = $true)]
    [string]$Action,
      
    [Parameter(Mandatory = $false)]
    $Body
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
      $Response = Invoke-WebRequest @Parameters -ErrorAction Stop 
      [MediantWebRequest]::new($Mediant,$Response.StatusCode,$Response.StatusDescription,$Response.rawcontent,$Response.content )
    }
    catch 
    {
      Write-Warning -Message "[Error] - $_.Exception"
      $null
    }
  }
}


Function Get-MediantDevice 
{
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true, ParameterSetName = 'Mediant',Position = 0)]
    [string]$Mediant,

    [Parameter(Mandatory = $true, ParameterSetName = 'Mediant',Position = 1)]
    [pscredential]$Credential,
   
    [Parameter(Mandatory = $true, ParameterSetName = 'Mediant',Position = 2)]
    [ValidateSet('http', 'https')]
    [string]$http
  )

  process {
    $Parameters             = @{ }
    $Parameters.Mediant     = $Mediant
    $Parameters.Credential  = $Credential
    $Parameters.Http        = $http

    if (Test-MediantDevice @Parameters) 
    {
      Return ([mediantdevice]::new($Mediant,$Credential,$http))
    }
    else 
    {
      return $null
    }

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
   
    [Parameter(Mandatory = $true, ParameterSetName = 'Mediant',Position = 2)]
    [ValidateSet('http', 'https')]
    [string]$http,

    [Parameter(Mandatory = $false, ParameterSetName = 'MediantDevice')]
    [Parameter(Mandatory = $false, ParameterSetName = 'Mediant')]
    [switch]$quiet
  )
  Process { 

    $Parameters             = @{ }
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
    $Parameters.Action      = '/api'

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
    [string]$http,    

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
        
    [Parameter(Mandatory = $true, ParameterSetName = 'Mediant')]
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
        
    [Parameter(Mandatory = $true, ParameterSetName = 'Mediant')]
    [ValidateSet('http', 'https')]
    [string]$http
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
          
    [Parameter(Mandatory = $true, ParameterSetName = 'Mediant')]
    [ValidateSet('http', 'https')]
    [string]$http
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
        
    [Parameter(Mandatory = $true, ParameterSetName = 'Mediant',Position = 0)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantAfter',Position = 0)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantBefore',Position = 0)]
    [ValidateSet('http', 'https')]
    [string]$http = 'http',
    
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
          
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantSpecific')]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantListAvailable')]
    [ValidateSet('http', 'https')]
    [string]$http = 'http',
     
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
    [string]$http = 'http',
  

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
    [string]$http = 'http',
  
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

 