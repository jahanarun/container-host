ARG BASE
FROM mcr.microsoft.com/windows/servercore:$BASE

SHELL ["powershell"]

WORKDIR c:\\caddy

COPY artifact\\caddy.exe .

CMD [ "caddy.exe", "run", "-config c:\\config\\caddy\\Caddyfile" ]
