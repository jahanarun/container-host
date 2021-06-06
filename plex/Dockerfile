ARG BASE
FROM mcr.microsoft.com/windows:$BASE

SHELL ["powershell"]

WORKDIR c:\\temp


USER ContainerAdministrator 

COPY artifact\\plex-setup.exe .
RUN powershell.exe -Command Start-Process .\plex-setup.exe -ArgumentList '/quiet' -Wait

RUN Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope LocalMachine
COPY cmd.ps1 .

CMD .\cmd.ps1
