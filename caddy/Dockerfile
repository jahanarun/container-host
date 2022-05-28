# escape=`
ARG BASE
FROM mcr.microsoft.com/windows/servercore:$BASE AS builder
ARG GO_VERSION="1.18.2"

ENV DOCKER_CLI_EXPERIMENTAL enabled

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

WORKDIR c:/temp
ENV GOPATH "c:/temp"

USER ContainerAdministrator

RUN Invoke-WebRequest -Uri "https://dl.google.com/go/go$env:GO_VERSION.windows-amd64.msi" -OutFile go-install.msi -UseBasicParsing;
RUN Start-Process 'go-install.msi' '/qn /norestart' -PassThru | Wait-Process;
RUN  & 'C:\Program Files\Go\bin\go.exe' install github.com/caddyserver/xcaddy/cmd/xcaddy@latest


# In order to set system PATH, ContainerAdministrator must be used
SHELL ["cmd", "/C "]
RUN setx /M PATH "%PATH%;c:\temp\go\bin"

USER ContainerUser
WORKDIR c:/temp
RUN bin\xcaddy.exe build --output caddy.exe   --with github.com/caddy-dns/cloudflare


ARG BASE
FROM mcr.microsoft.com/windows/servercore:$BASE

ENV DOCKER_CLI_EXPERIMENTAL enabled

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

WORKDIR c:/caddy

COPY --from=builder c:/temp/caddy.exe .

ENTRYPOINT ["caddy.exe"]

CMD [ "run", "--config", "c:\\config\\caddy\\Caddyfile" ]
