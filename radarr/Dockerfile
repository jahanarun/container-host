# escape=`
ARG BASE
FROM mcr.microsoft.com/windows/servercore:$BASE

SHELL ["powershell"]

RUN iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')); `
    choco install radarr -y;

USER ContainerAdministrator 

RUN Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope LocalMachine

COPY cmd.ps1 .

CMD .\cmd.ps1