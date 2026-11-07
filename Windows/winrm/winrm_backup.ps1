mkdir C:\Backup -Force
winrm get winrm/config > C:\Backup\winrm-config.txt
winrm enumerate winrm/config/listener > C:\Backup\winrm-listeners.txt
