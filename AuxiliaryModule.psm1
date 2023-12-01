
function Show-Countdown {
    param (
        [Parameter(Mandatory=$true)]
        [int]$DelayInSeconds,
        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    $numberOfIntervals = $DelayInSeconds * 4
    for ($i = 0; $i -lt $numberOfIntervals; $i++) {
        $elapsedTimeInSeconds = $i * 0.25
        $remainingSecondsDisplay = [math]::Ceiling($DelayInSeconds - $elapsedTimeInSeconds)
        Write-Progress -Activity $Message -Status ("{0} seconds remaining" -f $remainingSecondsDisplay) -PercentComplete (($elapsedTimeInSeconds / $DelayInSeconds) * 100)
        Start-Sleep -Milliseconds 250
    }
}