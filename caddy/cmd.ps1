Start-Sleep -Seconds 60
ipconfig /all
$myprocess = Start-Process "c:\caddy\caddy.exe" -ArgumentList 'run', '--config c:\config\caddy\Caddyfile' -PassThru
$myprocess.WaitForExit()
