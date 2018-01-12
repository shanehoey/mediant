##ALL BELOW ARE BETA ONLY AND CURRENTLY DO NOT WORK. IF YOU CAN GET THEM GOING PLEASE LET ME KNOW VIA GITHUB

##set-MediantDeviceLicense defer
Function set-MediantDeviceLicense 
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
    [string]$http,

    #OPTIONAL
    [string]$serialNumber,
    [string]$key,

    #OPTION2 
    $File

  )
  #Note to Self can be json or file
  Begin
  {
    if($PSBoundParameters.MediantDevice)
    {
      $Mediant     = $MediantDevice.Mediant
      $Credential  = $MediantDevice.Credential
      $http        = $MediantDevice.http
    }   
    
    $Parameters            = @{ }        
    $Parameters.mediant    = $Mediant    
    $Parameters.action     = '/api/v1/license'
    $Parameters.credential = $Credential
    $Parameters.method     = 'GET'
    $Parameters.http       = $http    
        
  } 
  Process
  {
    if ($pscmdlet.ShouldProcess("$Mediant")) 
    {
      if (Test-MediantDevice -Mediant $Parameters.Mediant -Credential $Parameters.Credential -http $Parameters.http) 
      { 
        $Result = (Invoke-MediantWebRequest @Parameters)
        $Result = $Result.content | ConvertFrom-Json
        return $Result   
      }
      Else 
      {
        return $null
      }   
    }
  }
}


##set-MediantDeviceFileAMD defer
Function Set-MediantDeviceFileAMD 
{
  [CmdletBinding(DefaultParameterSetName = 'MediantDeviceImmediate', SupportsShouldProcess = $true, ConfirmImpact = 'medium')]
  
  param(
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceImmediate',Position = 0)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceHitless',Position = 0)]
    [MediantDevice]$MediantDevice, 
    
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantImmediate',Position = 0)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantHitless',Position = 0)]
    [string]$Mediant,

    [Parameter(Mandatory = $true, ParameterSetName = 'MediantImmediate',Position = 1)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantHitless',Position = 1)]
    [pscredential]$Credential,
   
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantImmediate',Position = 2)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantHitless',Position = 2)]
    [ValidateSet('http', 'https')]
    [string]$http,
    
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceImmediate',Position = 1)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantImmediate',Position = 3)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceHitless',Position = 1)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantHitless',Position = 3)]
    [ValidateSet('Immediate', 'Hitless')]
    [String]$LoadType
     
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

    if($PSBoundParameters.MediantDeviceImmediate) 
    {
      $Parameters.action  = '/api/v1/files/amd'
    }
    if($PSBoundParameters.MediantDeviceHitless)   
    {
      $Parameters.action  = '/api/v1/files/amd/hitless'
    }
    if($PSBoundParameters.MediantImmediate)       
    {
      $Parameters.action  = '/api/v1/files/amd'
    }
    if($PSBoundParameters.MediantHitless)         
    {
      $Parameters.action  = '/api/v1/files/amd/hitless'
    }

    $Parameters.credential = $Credential
    $Parameters.method     = 'get'
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
 

##set-mediantMediantDeviceFileCasTable defer
Function Set-MediantDeviceFileCasTable 
{
  [CmdletBinding(DefaultParameterSetName = 'MediantDeviceImmediate', SupportsShouldProcess = $true, ConfirmImpact = 'medium')]
  
  param(
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceImmediate',Position = 0)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceHitless',Position = 0)]
    [MediantDevice]$MediantDevice, 
    
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantImmediate',Position = 0)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantHitless',Position = 0)]
    [string]$Mediant,

    [Parameter(Mandatory = $true, ParameterSetName = 'MediantImmediate',Position = 1)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantHitless',Position = 1)]
    [pscredential]$Credential,
   
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantImmediate',Position = 2)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantHitless',Position = 2)]
    [ValidateSet('http', 'https')]
    [string]$http,
    
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceImmediate',Position = 1)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantImmediate',Position = 3)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceHitless',Position = 1)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantHitless',Position = 3)]
    [ValidateSet('Immediate', 'Hitless')]
    [String]$LoadType
     
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

    if($PSBoundParameters.MediantDeviceImmediate) 
    {
      $Parameters.action  = '/api/v1/files/casTable'
    }
    if($PSBoundParameters.MediantDeviceHitless)   
    {
      $Parameters.action  = '/api/v1/files/casTable/hitless'
    }
    if($PSBoundParameters.MediantImmediate)       
    {
      $Parameters.action  = '/api/v1/files/casTable'
    }
    if($PSBoundParameters.MediantHitless)         
    {
      $Parameters.action  = '/api/v1/files/casTable/hitless'
    }
    
    $Parameters.credential = $Credential
    $Parameters.method     = 'get'
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

##set-MediantDeviceFileCliScript defer
Function Set-MediantDeviceFileCliScript 
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
   
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantFull',Position = 2)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantIncremental',Position = 2)]
    [ValidateSet('http', 'https')]
    [string]$http,
    
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceFull',Position = 1)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantFull',Position = 3)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceIncremental',Position = 1)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantIncremental',Position = 3)]
    [ValidateSet('Full', 'Incremental')]
    [String]$FileType
        
    
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
    $Parameters.method     = 'get'
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

##set-MediantDeviceFileCoderTable defer
Function Set-MediantDeviceFileCoderTable 
{
  [CmdletBinding(DefaultParameterSetName = 'MediantDeviceImmediate', SupportsShouldProcess = $true, ConfirmImpact = 'medium')]
  
  param(
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceImmediate',Position = 0)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceHitless',Position = 0)]
    [MediantDevice]$MediantDevice, 
    
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantImmediate',Position = 0)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantHitless',Position = 0)]
    [string]$Mediant,

    [Parameter(Mandatory = $true, ParameterSetName = 'MediantImmediate',Position = 1)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantHitless',Position = 1)]
    [pscredential]$Credential,
   
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantImmediate',Position = 2)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantHitless',Position = 2)]
    [ValidateSet('http', 'https')]
    [string]$http,
    
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceImmediate',Position = 1)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantImmediate',Position = 3)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceHitless',Position = 1)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantHitless',Position = 3)]
    [ValidateSet('Immediate', 'Hitless')]
    [String]$LoadType
     
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
   
    if($PSBoundParameters.MediantDeviceImmediate) 
    {
      $Parameters.action  = '/api/v1/files/coderTable'
    }
    if($PSBoundParameters.MediantDeviceHitless)   
    {
      $Parameters.action  = '/api/v1/files/coderTable/hitless'
    }
    if($PSBoundParameters.MediantImmediate)       
    {
      $Parameters.action  = '/api/v1/files/coderTable'
    }
    if($PSBoundParameters.MediantHitless)         
    {
      $Parameters.action  = '/api/v1/files/coderTable/hitless'
    }
    
    $Parameters.credential = $Credential
    $Parameters.method     = 'get'
    $Parameters.http       = $http    

  }    
 
  Process {
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

##set-MediantDeviceFileCPT defer 
Function Set-MediantDeviceFileCPT 
{
  [CmdletBinding(DefaultParameterSetName = 'MediantDeviceImmediate', SupportsShouldProcess = $true, ConfirmImpact = 'medium')]
  
  param(
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceImmediate',Position = 0)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceHitless',Position = 0)]
    [MediantDevice]$MediantDevice, 
    
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantImmediate',Position = 0)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantHitless',Position = 0)]
    [string]$Mediant,

    [Parameter(Mandatory = $true, ParameterSetName = 'MediantImmediate',Position = 1)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantHitless',Position = 1)]
    [pscredential]$Credential,
   
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantImmediate',Position = 2)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantHitless',Position = 2)]
    [ValidateSet('http', 'https')]
    [string]$http,
    
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceImmediate',Position = 1)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantImmediate',Position = 3)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceHitless',Position = 1)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantHitless',Position = 3)]
    [ValidateSet('Immediate', 'Hitless')]
    [String]$LoadType
     
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
   
    if($PSBoundParameters.MediantDeviceImmediate) 
    {
      $Parameters.action  = '/api/v1/files/cpt'
    }
    if($PSBoundParameters.MediantDeviceHitless)   
    {
      $Parameters.action  = '/api/v1/files/cpt/hitless'
    }
    if($PSBoundParameters.MediantImmediate)       
    {
      $Parameters.action  = '/api/v1/files/cpt'
    }
    if($PSBoundParameters.MediantHitless)         
    {
      $Parameters.action  = '/api/v1/files/cpt/hitless'
    }

    $Parameters.credential = $Credential
    $Parameters.method     = 'get'
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

##set-MediantDeviceFileDialPlan defer
Function Set-MediantDeviceFileDialPlan 
{  
  [CmdletBinding(DefaultParameterSetName = 'MediantDeviceImmediate', SupportsShouldProcess = $true, ConfirmImpact = 'medium')]
  
  param(
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceImmediate',Position = 0)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceHitless',Position = 0)]
    [MediantDevice]$MediantDevice, 
    
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantImmediate',Position = 0)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantHitless',Position = 0)]
    [string]$Mediant,

    [Parameter(Mandatory = $true, ParameterSetName = 'MediantImmediate',Position = 1)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantHitless',Position = 1)]
    [pscredential]$Credential,
   
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantImmediate',Position = 2)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantHitless',Position = 2)]
    [ValidateSet('http', 'https')]
    [string]$http,
    
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceImmediate',Position = 1)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantImmediate',Position = 3)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceHitless',Position = 1)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantHitless',Position = 3)]
    [ValidateSet('Immediate', 'Hitless')]
    [String]$LoadType
     
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
 
    if($PSBoundParameters.MediantDeviceImmediate) 
    {
      $Parameters.action  = '/api/v1/files/dialplan'
    }
    if($PSBoundParameters.MediantDeviceHitless)   
    {
      $Parameters.action  = '/api/v1/files/dialplan/hitless'
    }
    if($PSBoundParameters.MediantImmediate)       
    {
      $Parameters.action  = '/api/v1/files/dialplan'
    }
    if($PSBoundParameters.MediantHitless)         
    {
      $Parameters.action  = '/api/v1/files/dialplan/hitless'
    }

    $Parameters.credential = $Credential
    $Parameters.method     = 'get'
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

##set-MediantDeviceFileIni defer
Function Set-MediantDeviceFileIni 
{
  [CmdletBinding(DefaultParameterSetName = 'MediantDevice', SupportsShouldProcess = $true, ConfirmImpact = 'medium')]
  
  param(
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDevice',Position = 0)]
    [MediantDevice]$MediantDevice, 
    
    [Parameter(Mandatory = $true, ParameterSetName = 'Mediant',Position = 0)]
    [string]$Mediant,

    [Parameter(Mandatory = $true, ParameterSetName = 'Mediant')]
    [pscredential]$Credential,
   
    [Parameter(Mandatory = $true, ParameterSetName = 'Mediant')]
    [ValidateSet('http', 'https')]
    [string]$http,
    
    [Parameter(Mandatory = $true, ParameterSetName = 'Mediant')]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDevice')]
    [ValidateSet('Full', 'Incremental')]
    [String]$FileType,

    [Parameter(Mandatory = $true, ParameterSetName = 'Mediant')]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDevice')]
    [string]$filepath
        
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
    
    if($PSBoundParameters.MediantDeviceFull)         
    {
      $Parameters.action  = '/api/v1/files/ini'
    }
    if($PSBoundParameters.MediantDeviceIncremental)  
    {
      $Parameters.action  = '/api/v1/files/ini/incremental'
    }
    if($PSBoundParameters.MediantFull)               
    {
      $Parameters.action  = '/api/v1/files/ini'
    }
    if($PSBoundParameters.MediantIncremental)        
    {
      $Parameters.action  = '/api/v1/files/ini/incremental'
    }

    $Parameters.credential = $Credential
    $Parameters.method     = 'get'
    $Parameters.http       = $http    

  }    
 
  Process {
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

##set-MediantDeviceFileprt defer
Function Set-MediantDeviceFileprt 
{
  [CmdletBinding(DefaultParameterSetName = 'MediantDeviceImmediate', SupportsShouldProcess = $true, ConfirmImpact = 'medium')]
  
  param(
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceImmediate',Position = 0)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceHitless',Position = 0)]
    [MediantDevice]$MediantDevice, 
    
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantImmediate',Position = 0)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantHitless',Position = 0)]
    [string]$Mediant,

    [Parameter(Mandatory = $true, ParameterSetName = 'MediantImmediate',Position = 1)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantHitless',Position = 1)]
    [pscredential]$Credential,
   
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantImmediate',Position = 2)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantHitless',Position = 2)]
    [ValidateSet('http', 'https')]
    [string]$http,
    
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceImmediate',Position = 1)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantImmediate',Position = 3)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceHitless',Position = 1)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantHitless',Position = 3)]
    [ValidateSet('Immediate', 'Hitless')]
    [String]$LoadType
     
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

    if($PSBoundParameters.MediantDeviceImmediate) 
    {
      $Parameters.action  = '/api/v1/files/prt'
    }
    if($PSBoundParameters.MediantDeviceHitless)   
    {
      $Parameters.action  = '/api/v1/files/prt/hitless'
    }
    if($PSBoundParameters.MediantImmediate)       
    {
      $Parameters.action  = '/api/v1/files/prt'
    }
    if($PSBoundParameters.MediantHitless)         
    {
      $Parameters.action  = '/api/v1/files/prt/hitless'
    }

    $Parameters.credential = $Credential
    $Parameters.method     = 'get'
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

##set-MediantDeviceSoftware defer
Function Set-MediantDeviceSoftware 
{
  [CmdletBinding(DefaultParameterSetName = 'MediantDeviceImmediate', SupportsShouldProcess = $true, ConfirmImpact = 'medium')]
  
  param(
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceImmediate',Position = 0)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceHitless',Position = 0)]
    [MediantDevice]$MediantDevice, 
    
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantImmediate',Position = 0)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantHitless',Position = 0)]
    [string]$Mediant,

    [Parameter(Mandatory = $true, ParameterSetName = 'MediantImmediate',Position = 1)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantHitless',Position = 1)]
    [pscredential]$Credential,
   
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantImmediate',Position = 2)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantHitless',Position = 2)]
    [ValidateSet('http', 'https')]
    [string]$http,
    
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceImmediate',Position = 1)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantImmediate',Position = 3)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceHitless',Position = 1)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantHitless',Position = 3)]
    [ValidateSet('Immediate', 'Hitless')]
    [String]$LoadType
     
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
 
    if($PSBoundParameters.MediantDeviceImmediate)   
    {
      $Parameters.action  = '/api/v1/files/software'
    }
    if($PSBoundParameters.MediantDeviceHitless)     
    {
      $Parameters.action  = '/api/v1/files/software/hitless'
    }
    if($PSBoundParameters.MediantImmediate)         
    {
      $Parameters.action  = '/api/v1/files/software'
    }
    if($PSBoundParameters.MediantHitless)           
    {
      $Parameters.action  = '/api/v1/files/software/hitless'
    }


    $Parameters.credential = $Credential
    $Parameters.method     = 'get'
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

##set-MediantDeviceFileusersinfo defer
Function Set-MediantDeviceFileusersinfo 
{
  [CmdletBinding(DefaultParameterSetName = 'MediantDeviceImmediate', SupportsShouldProcess = $true, ConfirmImpact = 'medium')]
  
  param(
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceImmediate',Position = 0)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceHitless',Position = 0)]
    [MediantDevice]$MediantDevice, 
    
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantImmediate',Position = 0)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantHitless',Position = 0)]
    [string]$Mediant,

    [Parameter(Mandatory = $true, ParameterSetName = 'MediantImmediate',Position = 1)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantHitless',Position = 1)]
    [pscredential]$Credential,
   
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantImmediate',Position = 2)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantHitless',Position = 2)]
    [ValidateSet('http', 'https')]
    [string]$http,
    
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceImmediate',Position = 1)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantImmediate',Position = 3)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceHitless',Position = 1)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantHitless',Position = 3)]
    [ValidateSet('Immediate', 'Hitless')]
    [String]$LoadType
     
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
    $Parameters.action     = '/api/v1/files/usersinfo'

    if($PSBoundParameters.MediantDeviceImmediate) 
    {
      $Parameters.action  = '/api/v1/files/usersinfo'
    }
    if($PSBoundParameters.MediantDeviceHitless)   
    {
      $Parameters.action  = '/api/v1/files/usersinfo/hitless'
    }
    if($PSBoundParameters.MediantImmediate)       
    {
      $Parameters.action  = '/api/v1/files/usersinfo'
    }
    if($PSBoundParameters.MediantHitless)         
    {
      $Parameters.action  = '/api/v1/files/usersinfo/hitless'
    }

    $Parameters.credential = $Credential
    $Parameters.method     = 'get'
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

##set-MediantDeviceFileVoicePrompts defer
Function Set-MediantDeviceFileVoicePrompts 
{
  [CmdletBinding(DefaultParameterSetName = 'MediantDeviceImmediate', SupportsShouldProcess = $true, ConfirmImpact = 'medium')]
  
  param(
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceImmediate',Position = 0)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceHitless',Position = 0)]
    [MediantDevice]$MediantDevice, 
    
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantImmediate',Position = 0)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantHitless',Position = 0)]
    [string]$Mediant,

    [Parameter(Mandatory = $true, ParameterSetName = 'MediantImmediate',Position = 1)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantHitless',Position = 1)]
    [pscredential]$Credential,
   
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantImmediate',Position = 2)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantHitless',Position = 2)]
    [ValidateSet('http', 'https')]
    [string]$http,
    
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceImmediate',Position = 1)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantImmediate',Position = 3)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantDeviceHitless',Position = 1)]
    [Parameter(Mandatory = $true, ParameterSetName = 'MediantHitless',Position = 3)]
    [ValidateSet('Immediate', 'Hitless')]
    [String]$LoadType
     
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

    if($PSBoundParameters.MediantDeviceImmediate) 
    {
      $Parameters.action  = '/api/v1/files/VoicePrompts'
    }
    if($PSBoundParameters.MediantDeviceHitless)   
    {
      $Parameters.action  = '/api/v1/files/VoicePrompts/hitless'
    }
    if($PSBoundParameters.MediantImmediate)       
    {
      $Parameters.action  = '/api/v1/files/VoicePrompts'
    }
    if($PSBoundParameters.MediantHitless)         
    {
      $Parameters.action  = '/api/v1/files/VoicePrompts/hitless'
    }

    
    $Parameters.credential = $Credential
    $Parameters.method     = 'Get'
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

