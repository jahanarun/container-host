# Windows docker images for my favorite apps

* Caddy [url: [https://github.com/caddyserver/caddy](https://) ] [github: jhnrn/caddy-win:latest]
* Plex [url: [https://www.plex.tv](https://)]
* Inlets [url: https://github.com/inlets/inlets](https://)] [github: jhnrn/inlets-windows:latest]
* More to come...

The images are hosted in Github using the tag

jhnrn/caddy-win:latest


---



All the container images are built by downloading (or building) the latest executables from their repository/website.


The file `container-host-initialize.ps1` contains the `docker run` commands to start containers


The pipelines are configured using Github Workflow. Since, the virtual environment in Github Workflow supports only Windows 1809, you can only run the containers in Windows Host with 1809.
