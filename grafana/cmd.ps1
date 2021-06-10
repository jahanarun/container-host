Start-Sleep -Seconds 60
Set-Location C:\ProgramData\chocolatey\lib\grafana\tools\
$grafana_directory = Get-ChildItem -Include grafana* -Directory -Name
Set-Location ($grafana_directory + "\bin")
$myprocess = Start-Process grafana-server.exe -ArgumentList '--config "C:\config\custom.ini"' -PassThru
$myprocess.WaitForExit()
