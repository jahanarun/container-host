ARG BASE
FROM mcr.microsoft.com/windows/servercore:$BASE

SHELL ["powershell"]

WORKDIR c:\\caddy

COPY artifact\\caddy.exe .
RUN Start-Sleep -Seconds 60

CMD [ "c:\\caddy\\caddy.exe", "run", "--config c:\\config\\caddy\\Caddyfile" ]
