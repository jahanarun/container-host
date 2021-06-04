ARG BASE
FROM mcr.microsoft.com/windows/nanoserver:$BASE

RUN mkdir c:\\inlets
WORKDIR c:\\inlets

COPY artifact\\inlets.exe .

ENTRYPOINT ["inlets.exe"]

CMD ["--help"]