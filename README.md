# ServiceExecuteHelper
Service helper with log viewer

# To Do
- Code for Clearing log file so on start it has a clean log file
- Show the log file some how by hopefully having Get-Content MyLog.txt -wait run and visible for live updates to log.

Clearing Contents can be done with
```
clear-content .\AfeNavigatorServer.log
```

Need to open a pwsh and run a command
```
Start-Process powershell -ArgumentList "-noexit", "-noprofile", "-command &{Get-Location}"
```

Need to give titles to spawned windows
https://serverfault.com/questions/322928/how-do-i-add-a-title-to-a-powershell-window