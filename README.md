# FOR REPO DOWNLOAD ON WINDOWS

in an elevated powershell window, run  
`iwr https://github.com/benimbriaco1/team03-ccdcmc/archive/refs/heads/main.zip -OutFile C:\Windows\scripts.zip`  

then open file explorer and unzip. if errors are thrown, run with prefix 'powershell.exe -ExecutionPolicy Bypass -File' in powershell. example:  
`powershell.exe -ExecutionPolicy Bypass -File .\script.ps1`

If github is sinkholed, cry a little bit and then go check DNS zones or C:\Windows\System32\drivers\etc\hosts

# FOR REPO DOWNLOAD ON LINUX

can run  
`git clone https://github.com/benimbriaco1/team03-ccdcmc.git`

or `curl -l https://github.com/benimbriaco1/team03-ccdcmc/archive/refs/heads/main.zip -o repo.zip` and unzip w/ `unzip repo.zip`. if github is sinkholed check /etc/hosts file

# SCRIPT STUFF

to note:

- wireshark download just downloads the installer, need to run it manually.
- firewall scripts ask for the dc ip to only allow certain inbound traffic if it comes from the dc
