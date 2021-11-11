Set-Location C:\ProgramData\chocolatey\lib\grafana\tools\
$grafana_directory = Get-ChildItem -Include grafana* -Directory -Name
Set-Location ($grafana_directory + "\bin")
grafana-cli --pluginsDir "c:\config\plugins" plugins install grafana-worldmap-panel
grafana-cli --pluginsDir "c:\config\plugins" plugins install grafana-piechart-panel


$myprocess = Start-Process grafana-server.exe -ArgumentList '--config "C:\config\custom.ini"' -PassThru
$myprocess.WaitForExit()
