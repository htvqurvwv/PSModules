
function Get-NinjaPropertyBool {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Field
    )
    try {
        return $(Ninja-Property-Get $Field) -eq "1"
    } catch {
        Write-Host "An error occurred function ""Get-NinjaPropertyBool"", exiting with exception message ""$($_.Exception.Message)"""
        exit 1
    }
}

function DocumentServiceStates {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ServiceName,
        [Parameter(Mandatory=$true)]
        [string]$RunningPropertyName,
        [Parameter(Mandatory=$true)]
        [string]$ExistsPropertyName
    )
    Ninja-Property-Set $ExistsPropertyName $(Get-ServiceExists -ServiceName $ServiceName)
    Ninja-Property-Set $RunningPropertyName $(Get-ServiceIsRunning -ServiceName $ServiceName)
}