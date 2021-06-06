reg import c:\plex\plex.reg
Write-Output Sleeping...
Start-Sleep -Seconds 60
ipconfig /all
$myprocss = Start-Process "c:\Program Files (x86)\Plex\Plex Media Server\Plex Media Server.exe" -PassThru
$myprocss.WaitForExit()

