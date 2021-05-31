FROM mcr.microsoft.com/windows/servercore:20H2 AS caddy-env

RUN mkdir c:\\caddy
WORKDIR c:\\caddy

COPY caddy.exe c:\\caddy

ENTRYPOINT ["caddy.exe"]

CMD ["help"]