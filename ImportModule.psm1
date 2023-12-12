function Module-Handler {
    param([Parameter(Mandatory)] [string]$ModuleName)
    $modulePath = Join-Path -Path "C:\Windows\system32\config\systemprofile\Documents\WindowsPowerShell\Modules" -ChildPath $ModuleName
    if (-not (Test-Path -Path $modulePath)) { New-Item -ItemType Directory -Path $modulePath | Out-Null }
    $moduleFilePath = Join-Path -Path $modulePath -ChildPath "$ModuleName.psm1"
    try {
        Invoke-WebRequest -Uri "https://raw.githubusercontent.com/htvqurvwv/PSModules/main/$ModuleName.psm1" -OutFile $moduleFilePath -ErrorAction Stop
        & { $WarningPreference = 'SilentlyContinue'; Import-Module -Name $moduleFilePath -ErrorAction Stop }
        Write-Host "Imported module '$ModuleName' successfully."
    } catch {
        Write-Host "Error: Required module $ModuleName could not be downloaded or installed. Exiting"
        exit 1
    }
}