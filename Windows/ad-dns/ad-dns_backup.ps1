$Backup = "C:\Backup"

New-Item -ItemType Directory -Path $Backup -Force | Out-Null

Import-Module ActiveDirectory
Import-Module DnsServer

# Backup Active Directory
Get-ADDomain | Export-Clixml "$Backup\AD-Domain.xml"
Get-ADForest | Export-Clixml "$Backup\AD-Forest.xml"
Get-ADUser -Filter * -Properties * | Export-Clixml "$Backup\AD-Users.xml"
Get-ADGroup -Filter * -Properties Members | Export-Clixml "$Backup\AD-Groups.xml"
Get-ADOrganizationalUnit -Filter * | Export-Clixml "$Backup\AD-OUs.xml"

# Backup DNS
Get-DnsServerSetting -All | Export-Clixml "$Backup\DNS-Settings.xml"
Get-DnsServerZone | Export-Clixml "$Backup\DNS-Zones.xml"

foreach ($zone in Get-DnsServerZone) {
    Get-DnsServerResourceRecord -ZoneName $zone.ZoneName |
        Export-Clixml "$Backup\DNS-$($zone.ZoneName).xml"
}

# Backup SYSVOL
robocopy "C:\Windows\SYSVOL\sysvol" "$Backup\SYSVOL" /E /COPYALL /B /R:1 /W:1

Write-Host "AD, DNS, and SYSVOL backup complete: $Backup"
