
# This function will only create directories to prevent any path without a trailing \ from creating an empty file
# This function will exit the script if it doesn't have the required access for a path or some other unknown error occurs
function EnsurePathExists {
    param (
        [string]$Path
    )
    try {
        if (-not (Test-Path $Path)) {
            New-Item -Path $Path -ItemType Directory -ErrorAction Stop -Force | Out-Null
        }
    } catch {
        Write-Host "An error occurred in function ""EnsurePathExists"", exiting with exception message ""$($_.Exception.Message)"""
        exit 1
    }
}