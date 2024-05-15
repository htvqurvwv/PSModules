
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

#returns array
#Ninja usage implies string array as there are no other custom field types which return an array
#If Ninja-Property-Get is available but the field doesn't exist, it outputs "Unable to find the specified field." without a newline character,
#there is currently nothing I can do to prevent this without affecting the output
#TODO: Consider running trim on each array element.
function Get-NinjaPropertyStringArray {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Field
    )
    try {
        $value = Ninja-Property-Get $Field
        if ($value -is [System.Array]) {
            return $value
        } elseif ($value -is [string] -and $value -ne "") {
            return @($value)
        } else {
            return @()
        }
    } catch {
        Write-Host "An error occurred in function ""Get-NinjaPropertyStringArray"", exiting with exception message ""$($_.Exception.Message)"""
        exit 1
    }
}

#returns string or exits if string is empty or not found.
#If Ninja-Property-Get is available but the field doesn't exist, it outputs "Unable to find the specified field." without a newline character,
#there is currently nothing I can do to prevent this without affecting the output
function Get-NinjaPropertyStringExitIfMissingOrEmpty {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Field
    )
    try {
        $value = Ninja-Property-Get $Field
        if ($value -is [System.String] -and $value -ne "") {
            return $value
        } else {
            Write-Host """Get-NinjaPropertyStringExitIfMissingOrEmpty"": Unable to find field ""$Field"" or string was empty. Exiting."
        }
    } catch {
        Write-Host "An error occurred in function ""Get-NinjaPropertyString"", exiting with exception message ""$($_.Exception.Message)"""
    }
    exit 1
}