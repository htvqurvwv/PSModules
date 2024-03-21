function ValidateLocalAccount {
    param(
        [string]$Username,
        [string]$Password
    )

    $isValid = $null

    try {
        Add-Type -AssemblyName System.DirectoryServices.AccountManagement
        $domain_role = Get-WmiObject -Class Win32_ComputerSystem | Select-Object -ExpandProperty DomainRole
        $contextType = if ($domain_role -eq 5 -or $domain_role -eq 4) {
            [System.DirectoryServices.AccountManagement.ContextType]::Domain
        } else {
            [System.DirectoryServices.AccountManagement.ContextType]::Machine
        }
        $pc = New-Object System.DirectoryServices.AccountManagement.PrincipalContext($contextType, $env:COMPUTERNAME)
        
        $user = [System.DirectoryServices.AccountManagement.UserPrincipal]::FindByIdentity($pc, $Username)
        Write-Host """$user"""
        Write-Host "$($null -eq $user)"
        if ($null -eq $user) {
            $isValid = $false
        } else {
            $isValid = $pc.ValidateCredentials($Username, $Password)
        }
    } catch {
        Write-Host "An error occurred in function ""ValidateLocalAccount"", exiting with exception message ""$($_.Exception.Message)"""
        exit(1)
    }
    if ($isValid -eq $false) {
        $user = [System.DirectoryServices.AccountManagement.UserPrincipal]::FindByIdentity($pc, $Username)
        if ($null -eq $user) {
            Write-Host "Account $($Username) does not exist."
            return $null
        }
    }
    return $isValid
}