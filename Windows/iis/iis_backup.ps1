# backing up IIS configuration
Backup-WebConfiguration -Name “baseline” 
Copy-Item “C:\Windows\System32\inetsrv\backup\baseline” “C:\Program Files\Windows Explorer\” -Recurse -Force

# backing up log and website files
Copy-Item “C:\inetpub\logs\LogFiles” “C:\Program Files\Windows Explorer\” -Recurse -Force
Copy-Item “C:\inetpub\wwwroot\” “C:\Program Files\Windows Explorer\” -Recurse -Force
