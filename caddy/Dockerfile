ARG BASE
FROM mcr.microsoft.com/windows/servercore:$BASE

RUN mkdir c:\\caddy
WORKDIR c:\\caddy

COPY artifact\\caddy.exe .

ENTRYPOINT ["caddy.exe"]

CMD ["help"]