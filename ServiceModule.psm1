# Returns ServiceController or $null
# Script will exit for any other exception
function Get-Service_ {
    param (
        [Parameter(Mandatory=$true)]
        [string]$ServiceName
    )
    try {
        return $(Get-Service -Name $ServiceName -ErrorAction Stop)
    } catch {
        if ($_.Exception.Message -like "Cannot find any service with service name '*'.") {
            return $null
        } else {
            Write-Host "An error occurred in function ""Get-Service_"", exiting with exception message ""$($_.Exception.Message)"""
            exit 1
        }
    }
}

# Returns boolean
function Get-ServiceExists {
    param (
        [Parameter(Mandatory=$true)]
        [string]$ServiceName
    )
    $service = Get-Service_ -ServiceName $ServiceName
    return $null -ne $service
}

# Returns enum type "[System.ServiceProcess.ServiceControllerStatus]" or $null
# Reference: https://learn.microsoft.com/en-us/dotnet/api/system.serviceprocess.servicecontrollerstatus?view=dotnet-plat-ext-8.0#fields
function Get-ServiceStatus {
    param (
        [Parameter(Mandatory=$true)]
        [string]$ServiceName
    )
    $service = Get-Service_ -ServiceName $ServiceName
    if ($null -eq $service) {
        return $null
    } else {
        ($service).Status
    }
}

# Returns boolean or $null
function Get-ServiceIsRunning {
    param (
        [Parameter(Mandatory=$true)]
        [string]$ServiceName
    )
    $status = Get-ServiceStatus -ServiceName $ServiceName
    if ($null -eq $status) {
        return $null
    } else {
        return $status.Equals([System.ServiceProcess.ServiceControllerStatus]::Running)
    }
}

# Returns boolean for whether the service was running after completion, any errors/exceptions are outputted to stdout
function Start-Service_ {
    param (
        [Parameter(Mandatory=$true)]
        [string]$ServiceName
    )
    $service = Get-Service_ -ServiceName $ServiceName
    if ($null -eq $service) {
        Write-Host "Service '$ServiceName' does not exist."
        return $false
    }
    if (($service).Status.Equals([System.ServiceProcess.ServiceControllerStatus]::Running)) {
        Write-Host "Service '$ServiceName' is already running."
        return $true
    }
    Write-Host "Service '$ServiceName' not running, attempting to start."
    try {
        Start-Service -ServiceName $ServiceName -ErrorAction Stop
        $service.Refresh()
        if ($service.Status -eq 'Running') {
            Write-Host "Service '$ServiceName' started successfully."
            return $true
        } else {
            Write-Host "Service '$ServiceName' failed to start within the timeout period."
            return $false
        }
    } catch {
        Write-Host "Service '$ServiceName' failed to start: $($_.Exception.Message)"
        return $false
    }
}