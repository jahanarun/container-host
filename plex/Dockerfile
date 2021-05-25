FROM mcr.microsoft.com/windows/servercore:1809 

RUN mkdir c:\\temp
WORKDIR c:\\temp

COPY plex-setup.exe .
RUN plex-server.exe /quiet /passive

COPY run.bat .

ENTRYPOINT ["run.bat"]