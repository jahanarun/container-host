# escape=`
ARG BASE
FROM mcr.microsoft.com/windows/servercore:$BASE AS builder
ARG GO_VERSION="1.18.2"

ENV DOCKER_CLI_EXPERIMENTAL enabled

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

WORKDIR c:/temp

RUN Write-Output "https://dl.google.com/go/go$env:GO_VERSION.windows-amd64.zip"

RUN Invoke-WebRequest -Uri "https://dl.google.com/go/go$env:GO_VERSION.windows-amd64.zip" -OutFile go-install.zip -UseBasicParsing; `
    Expand-Archive go-install.zip -DestinationPath . ; `
    Remove-Item go-install.zip; 


RUN  & '.\go\bin\go.exe' install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

RUN xcaddy.exe build --output caddy.exe   --with github.com/caddy-dns/cloudflare


ARG BASE
FROM mcr.microsoft.com/windows/servercore:$BASE

ENV DOCKER_CLI_EXPERIMENTAL enabled

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

WORKDIR c:/caddy

COPY --from=builder c:/temp/caddy.exe .

ENTRYPOINT ["caddy.exe"]

CMD [ "run", "--config", "c:\\config\\caddy\\Caddyfile" ]
