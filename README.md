# Windows docker images for my favorite apps

* Caddy [url: [https://github.com/caddyserver/caddy](https://) ] [github: jhnrn/caddy-win:latest]
* Plex [url: [https://www.plex.tv](https://)]
* Inlets [url: https://github.com/inlets/inlets](https://)] [github: jhnrn/inlets-windows:latest]
* Sonarr [url: https://github.com/Sonarr/Sonarr](https://)] [github: jhnrn/sonarr-windows:latest]
* Radarr [url: https://github.com/Radarr/Radarr](https://)] [github: jhnrn/radarr-windows:latest]
* qBittorrent [url: https://github.com/qbittorrent/qBittorrent](https://)] [github: jhnrn/qbittorrent-windows:latest]
* Jackett [url: https://github.com/Jackett/Jackett/](https://)] [github: jhnrn/jackett-windows:latest]

More to come...

---

All the container images are built by downloading (or building) the latest executables from their repository/website.

The file `container-host-initialize.ps1` contains the `docker run` commands to start containers.

## CI/CD
The images are built using Github Workflow. 
I am using base image as windows servercore 20H2
GitHub Workflow only has support for Windows 1809. So I have a docker-image which can be `self-hosted` in your local computer to support 20H2. 