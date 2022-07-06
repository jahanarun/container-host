# escape=`
ARG BASE

FROM jhnrn/vsbuildtools2017:latest AS windows-container-tools

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

RUN VsDevCmd.bat && `
    msbuild /t:LogMonitor /p:platform=x64 /p:configuration=Release


FROM mcr.microsoft.com/windows/servercore:$BASE

SHELL ["powershell"]

RUN iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
RUN choco install qbittorrent -y

USER ContainerUser 

COPY --from=windows-container-tools C:\app\windows-container-tools\LogMonitor\x64\Release\LogMonitor.exe  C:\LogMonitor\
COPY LogMonitorConfig.json C:\LogMonitor\

# Creating the log directory before LogMonitor starts as LogMonitor will not function properly if directory doesn't exist.
RUN mkdir 'C:\Users\ContainerUser\AppData\Local\qBittorrent\logs' -Force


ENTRYPOINT C:\LogMonitor\LogMonitor.exe "C:\Program Files\qBittorrent\qbittorrent.exe"
