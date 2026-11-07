$ProgressPreference = 'SilentlyContinue'
md C:\Wireshark -Force | Out-Null
iwr "https://www.wireshark.org/download/win64/Wireshark-latest-x64.exe" -OutFile "C:\Wireshark\Wireshark-latest-x64.exe"
