
function Check-ServiceExists {
    param (
        [Parameter(Mandatory=$true)]
        [string]$serviceName
    )
    $service = Get-Service | Where-Object { $_.Name -eq $serviceName }
    return $null -ne $service
}

function Check-ServiceRunning {
    param (
        [Parameter(Mandatory=$true)]
        [string]$serviceName
    )
    $service = Get-Service | Where-Object { $_.Name -eq $serviceName -and $_.Status -eq 'Running' }
    return $null -ne $service
}
