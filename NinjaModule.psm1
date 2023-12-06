
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