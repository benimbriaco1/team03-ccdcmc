
# Usage:
#   .\PasswordReset.ps1 -Users alice,bob,administrator
#
# Import-Module ActiveDirectory required

param(
    [string[]] $Users
)

if (-not $Users) {
    Write-Host "Specify users with -Users" -ForegroundColor Red
    exit 1
}

# Prompt for new password
$password = Read-Host "New password" -AsSecureString
$confirm  = Read-Host "Confirm password" -AsSecureString

$plain1 = [System.Net.NetworkCredential]::new("", $password).Password
$plain2 = [System.Net.NetworkCredential]::new("", $confirm).Password

if ($plain1 -ne $plain2) {
    Write-Host "Passwords do not match" -ForegroundColor Red
    exit 1
}

# Get all domain users
Import-Module ActiveDirectory

$allUsers = Get-ADUser -Filter * |
    Select-Object -ExpandProperty SamAccountName

# Select only specified users that exist in AD
$targets = $allUsers | Where-Object { $_ -in $Users }

# Reset passwords
foreach ($user in $targets) {
    try {
        Set-ADAccountPassword -Identity $user -Reset -NewPassword $password -ErrorAction Stop
        Write-Host "[+] $user" -ForegroundColor Green
    } catch {
        Write-Host "[!] $user - $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "Done." -ForegroundColor Cyan
