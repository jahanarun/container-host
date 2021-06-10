Set-Location C:\ProgramData\chocolatey\lib\grafana\tools\
$exe_path=Get-ChildItem -Include grafana-server.exe -Recurse -Name
$myprocess = Start-Process $exe_path -ArgumentList '--config "C:\config\custom.ini"' -PassThru
$myprocess.WaitForExit()
