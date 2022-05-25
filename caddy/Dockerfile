ARG BASE
FROM mcr.microsoft.com/windows/servercore:$BASE

ENV DOCKER_CLI_EXPERIMENTAL enabled

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

WORKDIR c:/caddy
COPY caddy.exe .

ENTRYPOINT ["caddy.exe"]

CMD [ "run", "--config", "c:\\config\\caddy\\Caddyfile" ]
