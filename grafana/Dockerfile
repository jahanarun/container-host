# escape=`
ARG BASE
FROM mcr.microsoft.com/windows/servercore:$BASE

SHELL ["powershell"]
USER ContainerAdministrator 

RUN iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
RUN choco install grafana -y


RUN Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope LocalMachine

COPY cmd.ps1 .

CMD .\cmd.ps1