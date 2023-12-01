
function Check-ProgramInstalled {
    param (
        [Parameter(Mandatory=$true)]
        [string]$programName
    )
    $program = Get-Package | Where-Object { $_.Name -eq $programName }
    return $null -ne $program
}