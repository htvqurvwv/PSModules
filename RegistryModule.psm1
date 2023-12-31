
# Returns value or $null
# Script will exit for any other exception
function Get-RegistryValue {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Key,
        [Parameter(Mandatory=$true)]
        [string]$Name
    )
    try {
        return (Get-ItemProperty -Path $Key -Name $Name -ErrorAction Stop).$Name
    } catch {
        if ($_.Exception.Message -like "Property $Name does not exist at path *") {
            return $null
        } elseif ($_.Exception.Message -like "Cannot find path '*' because it does not exist.") {
            return $null
        } else {
            Write-Host "An error occurred in function ""Get-RegistryValue"", exiting with exception message ""$($_.Exception.Message)"""
            exit 1
        }
    }
}