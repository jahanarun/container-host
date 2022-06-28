# escape=`
ARG BASE

FROM mcr.microsoft.com/windows/servercore:$BASE AS builder

ENV DOCKER_CLI_EXPERIMENTAL enabled

WORKDIR c:/app
RUN git clone https://github.com/microsoft/windows-container-tools.git

WORKDIR c:/app/windows-container-tools/LogMonitor


### Build project with MSBuild
# We must invoke VsDevCmd.bat before using msbuild
# Otherwise, we'll get:
# "C:\app\windows-container-tools\LogMonitor\LogMonitor.sln" (default target) (1) ->
# "C:\app\windows-container-tools\LogMonitor\LogMonitorTests\LogMonitorTests.vcxproj" (default target) (3) ->
#   C:\app\windows-container-tools\LogMonitor\LogMonitorTests\LogMonitorTests.vcxproj(29,3): error MSB4019: 
# The imported project "c:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\MSBuild\Microsoft\VC\v170\Microsoft.Cpp.Default.props" was not found.
# Confirm that the expression in the Import declaration "c:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\MSBuild\Microsoft\VC\v170\\Microsoft.Cpp.Default.props" is correct, 
# and that the file exists on disk.

RUN msbuild /t:LogMonitor /p:platform=x64 /p:configuration=Release

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
USER ContainerAdministrator

RUN choco install -y jq;

WORKDIR c:/temp

RUN $response = Invoke-WebRequest -Uri "https://plex.tv/api/downloads/5.json" -UseBasicParsing; `
    $url = $response.Content | jq -r .computer.Windows.releases[0].url; `
    Invoke-WebRequest -Uri $url -OutFile plex-setup.exe -UseBasicParsing; 


FROM mcr.microsoft.com/windows:$BASE

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

WORKDIR c:/temp

COPY --from=builder c:/temp/plex-setup.exe .
COPY cmd.ps1 .
COPY --from=builder C:\app\windows-container-tools\LogMonitor\x64\Release\LogMonitor.exe  C:\LogMonitor\
COPY LogMonitorConfig.json C:\LogMonitor\

USER ContainerAdministrator 
RUN powershell.exe -Command Start-Process .\plex-setup.exe -ArgumentList '/quiet' -Wait

USER ContainerUser

# Creating the log directory before LogMonitor starts as LogMonitor will not function properly if directory doesn't exist.
RUN mkdir 'C:\Users\ContainerUser\AppData\Local\Plex Media Server\Logs' -Force

ENTRYPOINT C:\LogMonitor\LogMonitor.exe powershell.exe -executionpolicy remotesigned -File  cmd.ps1