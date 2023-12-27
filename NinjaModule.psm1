
function Get-NinjaPropertyBool {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Field
    )
    try {
        return $(Ninja-Property-Get $Field) -eq "1"
    } catch {
        Write-Host "An error occurred in function ""Get-NinjaPropertyBool"", exiting with exception message ""$($_.Exception.Message)"""
        exit 1
    }
}

#returns string or $null
#If Ninja-Property-Get is available but the field doesn't exist, it outputs "Unable to find the specified field." without a newline character,
#there is currently nothing I can do to prevent this without affecting the output
function Get-NinjaPropertyString {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Field
    )
    try {
        $value = Ninja-Property-Get $Field
        if ($value -is [System.String] -and $value -ne "") {
            return $value
        } else {
            return $null
        }
    } catch {
        Write-Host "An error occurred in function ""Get-NinjaPropertyString"", exiting with exception message ""$($_.Exception.Message)"""
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