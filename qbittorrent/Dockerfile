# escape=`
ARG BASE
FROM mcr.microsoft.com/windows/servercore:$BASE

SHELL ["powershell"]

RUN iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
RUN choco install qbittorrent -y

USER ContainerAdministrator 

CMD [ "C:\\Program Files\\qBittorrent\\qbittorrent.exe" ]
