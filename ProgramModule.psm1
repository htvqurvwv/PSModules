
function Check-ProgramInstalled {
    param (
        [Parameter(Mandatory=$true)]
        [string]$programName
    )
    $program = Get-Package | Where-Object { $_.Name -eq $programName }
    return $null -ne $program
}

function Check-ChocolateyAvailable {
    param ()
    try {
        choco --noop | Out-Null
        return $true
    } catch {
        return $false
    }
}

function ExitChocolateyIfUnavailable {
    param ()
    try {
        choco --noop | Out-Null
    } catch {
        Write-Host "Chocolatey unavailable"
    }
}

function Ensure-ChocolateyInstalled {
    param ()
    if ($(Check-ChocolateyAvailable) -eq $false) {
        Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    }
    if ($(Check-ChocolateyAvailable) -eq $false) {
        Write-Host "Chocolatey not available after running installation. Exiting."
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

function Update-Chocolatey {
    param ()
    ExitChocolateyIfUnavailable
    choco upgrade chocolatey --no-progress --nocolor --limit-output
}

function Prepare-Chocolatey {
    param ()
    Ensure-ChocolateyInstalled
    Ensure-AllowGlobalConfirmationEnabled
    Update-Chocolatey
}

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