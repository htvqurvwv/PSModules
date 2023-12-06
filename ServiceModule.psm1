function Get-ServiceExists {
    param (
        [Parameter(Mandatory=$true)]
        [string]$ServiceName
    )
    try {
        return $(Get-Service -Name $ServiceName -ErrorAction Stop).Count -gt 0
    } catch {
        Write-Host "An error occurred function ""Get-ServiceExists"", exiting with exception message ""$($_.Exception.Message)"""
        exit 1
    }
}

# Depends on Get-ServiceExists returning $true
# Returns enum type "[System.ServiceProcess.ServiceControllerStatus]" https://learn.microsoft.com/en-us/dotnet/api/system.serviceprocess.servicecontrollerstatus?view=dotnet-plat-ext-8.0#fields
function Get-ServiceStatus {
    param (
        [Parameter(Mandatory=$true)]
        [string]$ServiceName
    )
    try {
        return $(Get-Service -Name $ServiceName -ErrorAction Stop).Status
    } catch {
        Write-Host "An error occurred function ""Get-ServiceStatus"", exiting with exception message ""$($_.Exception.Message)"""
        exit 1
    }
}

# Depends on Get-ServiceExists returning $true
function Get-ServiceIsRunning {
    param (
        [Parameter(Mandatory=$true)]
        [string]$ServiceName
    )
    try {
        return $(Get-Service -Name $ServiceName -ErrorAction Stop).Status.Equals([System.ServiceProcess.ServiceControllerStatus]::Running)
    } catch {
        Write-Host "An error occurred function ""Get-ServiceIsRunning"", exiting with exception message ""$($_.Exception.Message)"""
        exit 1
    }
}
