# CCDC teamradio read-only audit. Review and test before use.
$Out = Join-Path $env:USERPROFILE ("teamradio-audit-{0}.txt" -f (Get-Date -Format 'yyyyMMdd-HHmmss'))
$results = @()
function Section($title, [scriptblock]$command) {
    $script:results += "`r`n=== $title ==="
    try { $script:results += (& $command | Out-String -Width 220) } catch { $script:results += $_.Exception.Message }
}
Section 'HOST' { hostname; ipconfig /all }
Section 'WINRM' { Get-Service WinRM; winrm enumerate winrm/config/listener; winrm get winrm/config/service; winrm get winrm/config/service/auth }
Section 'USERS' { Get-LocalUser; Get-LocalGroupMember Administrators; Get-LocalGroupMember 'Remote Management Users' }
Section 'FIREWALL' { Get-NetFirewallProfile; Get-NetFirewallRule -DisplayGroup 'Windows Remote Management' | Select-Object DisplayName,Enabled,Direction,Action,Profile }
Section 'SERVICES' { Get-CimInstance Win32_Service | Select-Object Name,State,StartMode,PathName }
Section 'SCHEDULED TASKS' { Get-ScheduledTask | Select-Object TaskName,TaskPath,State }
Section 'CONNECTIONS' { Get-NetTCPConnection | Select-Object LocalAddress,LocalPort,RemoteAddress,RemotePort,State,OwningProcess }
Section 'WINRM EVENTS' { Get-WinEvent -LogName 'Microsoft-Windows-WinRM/Operational' -MaxEvents 30 -ErrorAction SilentlyContinue | Select-Object TimeCreated,Id,Message }
$results | Out-File -FilePath $Out -Encoding utf8
Write-Host "Audit saved: $Out (may contain sensitive system information; keep on authorized infrastructure)"
