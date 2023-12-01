
function Get-NinjaPropertyBool {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Field
    )
    return $(Ninja-Property-Get $Field) -eq "1"
}