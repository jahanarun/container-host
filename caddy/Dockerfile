ARG BASE
FROM mcr.microsoft.com/windows/servercore:$BASE

SHELL ["powershell"]

WORKDIR c:\\caddy

COPY artifact\\caddy.exe .
RUN Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope LocalMachine
COPY cmd.ps1 .

CMD .\cmd.ps1