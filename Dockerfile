FROM mcr.microsoft.com/windows/servercore:1809 AS caddy-env
# FROM mcr.microsoft.com/dotnet/core/sdk:2.1 AS caddy-env
RUN mkdir c:\\caddy
WORKDIR c:\\caddy

COPY caddy.exe c:\\caddy
COPY Caddyfile c:\\caddy

ENTRYPOINT ["caddy.exe", "run"]