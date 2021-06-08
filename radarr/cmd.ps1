Start-Sleep -Seconds 60
taskkill /im radarr* /f
$myprocess = Start-Process "c:\ProgramData\Radarr\bin\Radarr.Console.exe" -ArgumentList "--data=c:\radarr" -PassThru
$myprocess.WaitForExit()

