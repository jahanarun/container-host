# escape=`
ARG BASE
FROM mcr.microsoft.com/windows/servercore:$BASE AS builder

ENV DOCKER_CLI_EXPERIMENTAL enabled

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
USER ContainerAdministrator

RUN iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')); `
    choco install -y jq;

WORKDIR c:/temp

RUN $response = Invoke-WebRequest -Uri "https://plex.tv/api/downloads/5.json" -UseBasicParsing; `
    $url = $response.Content | jq -r .computer.Windows.releases[0].url; `
    Invoke-WebRequest -Uri $url -OutFile plex-setup.exe -UseBasicParsing; 


ARG BASE
FROM mcr.microsoft.com/windows:$BASE

SHELL ["powershell"]

WORKDIR c:/temp

COPY --from=builder c:/temp/plex-setup.exe .

USER ContainerAdministrator 

RUN powershell.exe -Command Start-Process .\plex-setup.exe -ArgumentList '/quiet' -Wait

RUN Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope LocalMachine
COPY cmd.ps1 .

CMD .\cmd.ps1
