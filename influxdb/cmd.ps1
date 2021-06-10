# Start-Sleep -Seconds 60
$influx_path=Get-ChildItem -Include influxd.exe -Recurse -Name
$myprocess = Start-Process $influx_path -ArgumentList '--config "C:\config\influxdb.conf"' -PassThru
$myprocess.WaitForExit()

