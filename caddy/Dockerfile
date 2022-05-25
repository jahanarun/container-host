ARG BASE
FROM mcr.microsoft.com/windows/servercore:$BASE AS builder
ARG GO_VERSION="1.18.2"

ENV DOCKER_CLI_EXPERIMENTAL enabled

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

WORKDIR c:/temp

RUN Invoke-WebRequest -Uri "https://dl.google.com/go/go$env:GO_VERSION.windows-amd64.msi" -OutFile go-install.msi -UseBasicParsing; 

RUN msiexec /package go-install.msi /quiet

WORKDIR c:/caddy

RUN  & 'C:\Program Files\Go\bin\go.exe' install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

RUN xcaddy.exe build --output caddy.exe   --with github.com/caddy-dns/cloudflare


ARG BASE
FROM mcr.microsoft.com/windows/servercore:$BASE

ENV DOCKER_CLI_EXPERIMENTAL enabled

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

WORKDIR c:/caddy

COPY --from=builder c:/caddy/caddy.exe .

ENTRYPOINT ["caddy.exe"]

CMD [ "run", "--config", "c:\\config\\caddy\\Caddyfile" ]
