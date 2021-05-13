FROM mcr.microsoft.com/windows/nanoserver:1903 AS caddy-env
# FROM mcr.microsoft.com/dotnet/core/sdk:2.1 AS caddy-env
RUN mkdir /caddy
WORKDIR /caddy

COPY caddy.exe /caddy
COPY Caddyfile /caddy

ENTRYPOINT ["caddy.exe", "run"]