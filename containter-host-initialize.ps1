
function Get-RandomMacAddressFromTransparentHnsNetworkRange
{
    [OutputType([string])]

    $startMac =  (Get-HnsNetwork | Where-Object -FilterScript { $_.Type -eq "transparent" } | Select-Object -ExpandProperty "MacPools" | Select-Object -ExpandProperty "StartMacAddress" ) -replace "-", ""

    $endMac =  (Get-HnsNetwork | Where-Object -FilterScript { $_.Type -eq "transparent" } | Select-Object -ExpandProperty "MacPools" | Select-Object -ExpandProperty "EndMacAddress" ) -replace "-", ""

    $cmd = "0x$($startMac.Substring(8,4))..0x$($endMac.Substring(8,4))"

    $suffix = Invoke-Expression $cmd |ForEach-Object ToString X3 | Get-Random 

    $prefix = $startMac.Substring(0,8)

    $newMac = "$($prefix)$($suffix)"
    $newMac_a = $newMac.ToString().Insert(2,'-').Insert(5,'-').Insert(8,'-').Insert(11,'-').Insert(14,'-')

    return $newMac_a
}

function Initialize-TransparentNetwork
{

    $dockerNetworkList = & docker network list
    $transparentNetwork = $dockerNetworkList | Where-Object {$_ -match 'transparent'}

    if($null -ne $transparentNetwork)
    {
        $networkId = $transparentNetwork.Substring(0, 4)
        $cmd = "docker network rm $($networkId)"

        Invoke-Expression $cmd
    }

    Invoke-Expression @"
    docker network create -d transparent    -o com.docker.network.windowsshim.networkname=MyTransparentNetwork -o com.docker.network.windowsshim.vlanid=60 MyTransparentNetwork
    docker network create -d transparent    -o com.docker.network.windowsshim.networkname=VpnNetwork -o com.docker.network.windowsshim.vlanid=70 VpnNetwork
"@
    }

# Invoke-Expression "docker ps -a"
docker ps --quiet | ForEach-Object {docker stop $_}
docker ps -a --quiet | ForEach-Object {docker rm $_}

Initialize-TransparentNetwork
#docker run -d --restart unless-stopped --network=MyTransparentNetwork --mac-address=`"$(Get-RandomMacAddressFromTransparentHnsNetworkRange)`" --name dex-caddy -e DNS_API_KEY -v s:\Caddy:C:\Users\ContainerAdministrator\AppData\Roaming\Caddy caddy-win:local
docker run `
    -d --restart unless-stopped `
    --network=MyTransparentNetwork --mac-address=`"00:15:5d:29:6f:00`" `
    --name dex-caddy `
    -v s:\caddy-docker\:C:\config `
    -e DNS_API_KEY -e XDG_DATA_HOME=c:\config `
    jhnrn/caddy-win:latest

docker run `
    -d --restart unless-stopped `
    --network=MyTransparentNetwork --mac-address=`"00:15:5d:29:6f:01`" `
    --dns 8.8.8.8 `
    --name dex-inlets `
    jhnrn/inlets-windows `
    client --url=wss://$env:DOMAIN  --upstream=https://10.100.60.12:443 --token=$env:INLET_TOKEN

docker run `
    -d --restart unless-stopped `
    --network=MyTransparentNetwork --mac-address=`"00:15:5d:29:6f:02`" `
    --name dex-plex `
    -v S:\plex-docker\:c:\plex `
    -v M:\:c:\media `
    jhnrn/plex-server:latest 

docker run `
    -d --restart unless-stopped `
    --network=MyTransparentNetwork --mac-address=`"00:15:5d:29:6f:03`" `
    --name github-runner `
    -e GITHUBREPO_OR_ORG=jahanarun/container-host -e GITHUBPAT=$env:GITHUB_PAT_TOKEN `
    -v \\.\pipe\docker_engine:\\.\pipe\docker_engine `
    jhnrn/github-runner:latest

docker run `
    -d --restart unless-stopped `
    --network=MyTransparentNetwork --mac-address=`"00:15:5d:29:6f:04`" `
    -v S:\qbittorrent-docker\:C:\Users\ContainerAdministrator\AppData `
    --name dex-qbittorrent `
    -v t:\:C:\torrents `
    jhnrn/qbittorrent-windows:latest

docker run `
    -d --restart unless-stopped `
    --network=MyTransparentNetwork --mac-address=`"00:15:5d:29:6f:05`" `
    -v S:\sonarr-docker\:C:\sonarr `
    -v M:\Series\:C:\media `
    -v T:\:C:\torrents `
    --name dex-sonarr `
    jhnrn/sonarr-windows:latest

docker run `
    -d --restart unless-stopped `
    --network=MyTransparentNetwork --mac-address=`"00:15:5d:29:6f:06`" `
    -v S:\radarr-docker\:C:\radarr `
    -v M:\Movies\:C:\media `
    -v T:\:C:\torrents `
    --name dex-radarr `
    jhnrn/radarr-windows:latest

docker run `
    -d --restart unless-stopped `
    --network=VpnNetwork --mac-address=`"00:15:5d:29:6f:07`" `
    -v S:\jackett-docker\:C:\config `
    --name dex-jacket `
    jhnrn/jackett-windows:latest

docker run `
    -d --restart unless-stopped `
    --network=MyTransparentNetwork --mac-address=`"00:15:5d:29:6f:08`" `
    -v S:\influxdb-docker\:C:\config `
    --name dex-influxdb `
    jhnrn/influxdb-windows:latest

docker run `
    -d --restart unless-stopped `
    --network=MyTransparentNetwork --mac-address=`"00:15:5d:29:6f:09`" `
    -v S:\grafana-docker\:C:\config `
    --name dex-grafana `
    jhnrn/grafana-windows:latest