if (Test-Path c:\plex\plex.reg) {
    reg import c:\plex\plex.reg
}
Start-Sleep -Seconds 60
ipconfig /all
$myprocess = Start-Process "c:\Program Files (x86)\Plex\Plex Media Server\Plex Media Server.exe" -PassThru
while (!$myprocess.HasExited) {
    Start-Sleep -Seconds 300
    reg export "HKCU\Software\Plex, Inc." c:\plex\plex.reg /y
}

