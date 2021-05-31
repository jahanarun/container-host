FROM mcr.microsoft.com/windows/servercore:1809 

RUN mkdir c:\\inlets
WORKDIR c:\\inlets

COPY artifact\\inlets.exe .

ENTRYPOINT ["inlets.exe"]

CMD ["--help"]