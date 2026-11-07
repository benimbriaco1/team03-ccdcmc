$Backup = "C:\CCDC-Backup"

New-Item -ItemType Directory -Path $Backup -Force | Out-Null

# Backup SMB share configuration
Get-SmbShare | Export-Clixml "$Backup\Shares.xml"

# Backup each share
foreach ($share in Get-SmbShare) {

    if ($share.Special -or $share.Path -notmatch '^[A-Za-z]:\\') {
        continue
    }

    $name = $share.Name
    $source = $share.Path
    $dest = "$Backup\$name"

    # Backup files and NTFS permissions
    robocopy $source $dest /E /COPYALL /B /R:1 /W:1

    # Backup share permissions
    Get-SmbShareAccess -Name $name |
        Export-Csv "$Backup\$name-Permissions.csv" -NoTypeInformation

    # Backup NTFS permissions
    icacls $source /save "$Backup\$name-ACLs.txt" /T /C
}

Write-Host "SMB backup complete: $Backup"
