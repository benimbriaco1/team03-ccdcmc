$ProgressPreference = 'SilentlyContinue'
md C:\Sysinternals -Force | Out-Null
"Autoruns64.exe","procexp64.exe","Procmon64.exe","Tcpview.exe" | % { iwr "https://live.sysinternals.com/$_" -OutFile "C:\Sysinternals\$_" }
