
function Get-RandomMacAddressFromTransparentHnsNetworkRange {
    [OutputType([string])]

    $startMac = (Get-HnsNetwork | Where-Object -FilterScript { $_.Type -eq "transparent" } | Select-Object -ExpandProperty "MacPools" | Select-Object -ExpandProperty "StartMacAddress" ) -replace "-", ""

    $endMac = (Get-HnsNetwork | Where-Object -FilterScript { $_.Type -eq "transparent" } | Select-Object -ExpandProperty "MacPools" | Select-Object -ExpandProperty "EndMacAddress" ) -replace "-", ""

    $cmd = "0x$($startMac.Substring(8,4))..0x$($endMac.Substring(8,4))"

    $suffix = Invoke-Expression $cmd | ForEach-Object ToString X3 | Get-Random 

    $prefix = $startMac.Substring(0, 8)

    $newMac = "$($prefix)$($suffix)"
    $newMac_a = $newMac.ToString().Insert(2, '-').Insert(5, '-').Insert(8, '-').Insert(11, '-').Insert(14, '-')

    return $newMac_a
}

function Initialize-TransparentNetwork {

    $dockerNetworkList = & docker network list
    $transparentNetwork = $dockerNetworkList | Where-Object { $_ -match 'transparent' }
    $measure = $transparentNetwork | Measure-Object  

    if (2 -eq $measure.Count) {
        $message = "Network is already configured."
        Write-Output $message
        Write-EventLog -LogName "Application" -Source "Container-Initialize" -EntryType Information -EventID 1 -Message $message

        return
    }

    if ($null -ne $transparentNetwork) {
        Write-Output "Removing existing Transparent networks..."
        $networkId = $transparentNetwork.Substring(0, 4)
        $cmd = "docker network rm $($networkId)"

        Invoke-Expression $cmd
    }

    $message = "Creating new Transparent networks..."
    Write-Output $message
    Write-EventLog -LogName "Application" -Source "Container-Initialize" -EntryType Information -EventID 1 -Message $message

    Invoke-Expression @"
    docker network create -d transparent    -o com.docker.network.windowsshim.networkname=MyTransparentNetwork -o com.docker.network.windowsshim.vlanid=60 MyTransparentNetwork
    docker network create -d transparent    -o com.docker.network.windowsshim.networkname=VpnNetwork -o com.docker.network.windowsshim.vlanid=70 VpnNetwork
"@
}
New-EventLog -LogName "Application" -Source "Container-Initialize" -ErrorAction Continue
$message = "Starting..."
Write-EventLog -LogName "Application" -Source "Container-Initialize" -EntryType Information -EventID 1 -Message $message

# Invoke-Expression "docker ps -a"
docker ps -a --quiet | ForEach-Object { docker stop $_; docker rm $_; }
# docker ps -a --quiet | ForEach-Object { docker rm $_ }

Initialize-TransparentNetwork
#docker run -d --restart unless-stopped --network=MyTransparentNetwork --mac-address=`"$(Get-RandomMacAddressFromTransparentHnsNetworkRange)`" --name dex-caddy -e DNS_API_KEY -v s:\Caddy:C:\Users\ContainerAdministrator\AppData\Roaming\Caddy caddy-win:local
if (1 -ne (docker ps --filter "name=dex-caddy" -q | Measure-Object).Count) {
    $message = "Creating dex-caddy container..."
    Write-Output $message
    Write-EventLog -LogName "Application" -Source "Container-Initialize" -EntryType Information -EventID 1 -Message $message

    docker run `
        -d --restart unless-stopped `
        --network=MyTransparentNetwork --mac-address=`"00:15:5d:29:6f:00`" `
        --name dex-caddy `
        -v s:\caddy-docker\:C:\config `
        -e DNS_API_KEY -e XDG_DATA_HOME=c:\config `
        jhnrn/caddy-win:latest
}

if (1 -ne (docker ps --filter "name=dex-inlets" -q | Measure-Object).Count) {
    $message = "Creating dex-inlets container..."
    Write-Output $message
    Write-EventLog -LogName "Application" -Source "Container-Initialize" -EntryType Information -EventID 1 -Message $message
    docker run `
        -d --restart unless-stopped `
        --network=MyTransparentNetwork --mac-address=`"00:15:5d:29:6f:01`" `
        --dns 8.8.8.8 `
        --name dex-inlets `
        jhnrn/inlets-windows `
        client --url=wss://$env:DOMAIN  --upstream=https://10.100.60.12:443 --token=$env:INLET_TOKEN
}

if (1 -ne (docker ps --filter "name=dex-plex" -q | Measure-Object).Count) {
    $message = "Creating dex-plex container..."
    Write-Output $message
    Write-EventLog -LogName "Application" -Source "Container-Initialize" -EntryType Information -EventID 1 -Message $message
    docker run `
        -d --restart unless-stopped `
        --network=MyTransparentNetwork --mac-address=`"00:15:5d:29:6f:02`" `
        --name dex-plex `
        -v S:\plex-docker\:c:\plex `
        -v M:\:c:\media `
        jhnrn/plex-server:latest 
}

if (1 -ne (docker ps --filter "name=github-runner" -q | Measure-Object).Count) {
    $message = "Creating github-runner container..."
    Write-Output $message
    Write-EventLog -LogName "Application" -Source "Container-Initialize" -EntryType Information -EventID 1 -Message $message
    docker run `
        -d --restart unless-stopped `
        --network=MyTransparentNetwork --mac-address=`"00:15:5d:29:6f:03`" `
        --name github-runner `
        -e GITHUBREPO_OR_ORG=jahanarun/container-host -e GITHUBPAT=$env:GITHUB_PAT_TOKEN `
        -v \\.\pipe\docker_engine:\\.\pipe\docker_engine `
        jhnrn/github-runner:20H2
}

if (1 -ne (docker ps --filter "name=dex-qbittorrent" -q | Measure-Object).Count) {
    $message = "Creating dex-qbittorrent container..."
    Write-Output $message
    Write-EventLog -LogName "Application" -Source "Container-Initialize" -EntryType Information -EventID 1 -Message $message
    docker run `
        -d --restart unless-stopped `
        --network=MyTransparentNetwork --mac-address=`"00:15:5d:29:6f:04`" `
        -v S:\qbittorrent-docker\:C:\Users\ContainerAdministrator\AppData `
        --name dex-qbittorrent `
        -v t:\:C:\torrents `
        jhnrn/qbittorrent-windows:latest
}

if (1 -ne (docker ps --filter "name=dex-sonarr" -q | Measure-Object).Count) {
    $message = "Creating dex-sonarr container..."
    Write-Output $message
    Write-EventLog -LogName "Application" -Source "Container-Initialize" -EntryType Information -EventID 1 -Message $message
    docker run `
        -d --restart unless-stopped `
        --network=MyTransparentNetwork --mac-address=`"00:15:5d:29:6f:05`" `
        -v S:\sonarr-docker\:C:\sonarr `
        -v M:\Series\:C:\media `
        -v T:\:C:\torrents `
        --name dex-sonarr `
        jhnrn/sonarr-windows:latest
}

if (1 -ne (docker ps --filter "name=dex-radarr" -q | Measure-Object).Count) {
    $message = "Creating dex-radarr container..."
    Write-Output $message
    Write-EventLog -LogName "Application" -Source "Container-Initialize" -EntryType Information -EventID 1 -Message $message
    docker run `
        -d --restart unless-stopped `
        --network=MyTransparentNetwork --mac-address=`"00:15:5d:29:6f:06`" `
        -v S:\radarr-docker\:C:\radarr `
        -v M:\Movies\:C:\media `
        -v T:\:C:\torrents `
        --name dex-radarr `
        jhnrn/radarr-windows:latest
}

if (1 -ne (docker ps --filter "name=dex-jacket" -q | Measure-Object).Count) {
    $message = "Creating dex-jacket container..."
    Write-Output $message
    Write-EventLog -LogName "Application" -Source "Container-Initialize" -EntryType Information -EventID 1 -Message $message
    docker run `
        -d --restart unless-stopped `
        --network=VpnNetwork --mac-address=`"00:15:5d:29:6f:07`" `
        -v S:\jackett-docker\:C:\config `
        --name dex-jacket `
        jhnrn/jackett-windows:latest
}

if (1 -ne (docker ps --filter "name=dex-influxdb" -q | Measure-Object).Count) {
    $message = "Creating dex-influxdb container..."
    Write-Output $message
    Write-EventLog -LogName "Application" -Source "Container-Initialize" -EntryType Information -EventID 1 -Message $message
    docker run `
        -d --restart unless-stopped `
        --network=MyTransparentNetwork --mac-address=`"00:15:5d:29:6f:08`" `
        -v S:\influxdb-docker\:C:\config `
        --name dex-influxdb `
        jhnrn/influxdb-windows:latest
}

if (1 -ne (docker ps --filter "name=dex-grafana" -q | Measure-Object).Count) {
    $message = "Creating dex-grafana container..."
    Write-Output $message
    Write-EventLog -LogName "Application" -Source "Container-Initialize" -EntryType Information -EventID 1 -Message $message
    docker run `
        -d --restart unless-stopped `
        --network=MyTransparentNetwork --mac-address=`"00:15:5d:29:6f:09`" `
        -v S:\grafana-docker\:C:\config `
        --name dex-grafana `
        jhnrn/grafana-windows:latest
}