
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
"@
    }

# Invoke-Expression "docker ps -a"
docker ps --quiet | ForEach-Object {docker stop $_}
docker ps -a --quiet | ForEach-Object {docker rm $_}

Initialize-TransparentNetwork
#docker run -d --restart always --network=MyTransparentNetwork --mac-address=`"$(Get-RandomMacAddressFromTransparentHnsNetworkRange)`" --name dex-caddy -e DNS_API_KEY -v s:\Caddy:C:\Users\ContainerAdministrator\AppData\Roaming\Caddy caddy-win:local
docker run -d --restart always --network=MyTransparentNetwork --mac-address=`"00:15:5d:29:6f:00`" --name dex-caddy -e DNS_API_KEY -e XDG_DATA_HOME=c:\config -v s:\:C:\config jhnrn/caddy-win:latest run --config C:\config\Caddy\Caddyfile

docker run -d --restart always --network=MyTransparentNetwork --mac-address=`"00:15:5d:29:6f:01`" --name dex-inlets --dns 8.8.8.8 jhnrn/inlets-windows client  --url=wss://$env:DOMAIN  --upstream=https://10.100.60.12:443 --token=$env:INLET_TOKEN

# docker run -it --name plex-test --network=MyTransparentNetwork --mac-address=`"00:15:5d:29:6f:02`" -v S:\plex-docker\:c:\plex plex-test:latest

# docker run --rm -it --network=MyTransparentNetwork --mac-address=`"00:15:5d:29:6f:02`"  --platform linux plexinc/pms-docker:latest