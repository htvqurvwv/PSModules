
function Get-ProgramInstalled {
    param (
        [Parameter(Mandatory=$true)]
        [string]$ProgramName
    )
    try {
        return $(Get-Package -Name $ProgramName -ErrorAction Stop).Count -gt 0
    } catch {
        if ($_.Exception.Message -like "No package found for '*'.") {
            return $false
        } else {
            Write-Host "An error occurred in function ""Get-ProgramInstalled"", exiting with exception message ""$($_.Exception.Message)"""
            exit 1
        }
    }
}

function Get-ChocolateyAvailable {
    param ()
    try {
        choco --noop | Out-Null
        return $true
    } catch {
        return $false
    }
}

function Ensure-ChocolateyInstalled {
    param ()
    if ($(Get-ChocolateyAvailable) -eq $false) {
        Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    }
    if ($(Get-ChocolateyAvailable) -eq $false) {
        Write-Host "Chocolatey not available after running installer. Exiting."
        exit 1
    }
}

function Get-AllowGlobalConfirmationState {
    param ()
    $allowGlobalConfirmationState = choco feature get allowGlobalConfirmation --limit-output
    if ($allowGlobalConfirmationState -eq "Enabled") {
        return $true
    } elseif ($allowGlobalConfirmationState -eq "Disabled") {
        return $false
    }
    Write-Host "Couldn't explicitly determine state of Chocolatey ""allowGlobalConfirmation"" config. Exiting."
    exit (1)
}

function Ensure-AllowGlobalConfirmationEnabled {
    param ()
    $state = Get-AllowGlobalConfirmationState
    if ($state -eq $false) {
        if ($(choco feature enable allowGlobalConfirmation --limit-output) -ne "Enabled allowGlobalConfirmation") {
            Write-Host "An error occured when enabling ""allowGlobalConfirmation"" in Chocolatey"
            exit 1
        }
    }
}

#
function PrepareChocolatey {
    param ()
    Ensure-ChocolateyInstalled
    Ensure-AllowGlobalConfirmationEnabled
    try {
        choco upgrade chocolatey --no-progress --nocolor --limit-output
    } catch {
        Write-Host "An error occurred in function ""PrepareChocolatey"", exiting with exception message ""$($_.Exception.Message)"""
    }
}

# This function has no validation and does nothing to confirm it actually installed.
# It is simply a best-effort function, relying on usage of this function and inputs being tested
function Install-ChocolateyProgram {
    param (
        [Parameter(Mandatory=$true)]
        [string]$ProgramName
    )
    try {
        choco install $ProgramName --no-progress --nocolor --limit-output
    } catch {
        Write-Host "An error occurred when trying to install Chocolatey program $ProgramName. Exiting."
        exit 1
    }
}