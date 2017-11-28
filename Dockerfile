# inspired by instruction: https://docs.microsoft.com/en-us/visualstudio/install/build-tools-container
# workload and component id for build tools: https://github.com/MicrosoftDocs/visualstudio-docs/blob/master/docs/install/workload-component-id-vs-build-tools.md

FROM microsoft/windowsservercore:latest

# Download useful tools to C:\Bin.
ADD https://dist.nuget.org/win-x86-commandline/v4.1.0/nuget.exe C:\\Bin\\nuget.exe

# Download the Build Tools bootstrapper outside of the PATH.
ADD https://aka.ms/vs/15/release/vs_buildtools.exe C:\\TEMP\\vs_buildtools.exe

# Add C:\Bin to PATH and install Build Tools excluding workloads and components with known issues.
RUN setx /m PATH "%PATH%;C:\Bin" \
  && C:\TEMP\vs_buildtools.exe --quiet --wait --norestart --nocache --installPath C:\BuildTools \
  --add Microsoft.VisualStudio.Workload.MSBuildTools \
  --add Microsoft.VisualStudio.Workload.WebBuildTools \
  --includeRecommended \
  --includeOptional \
  || IF "%ERRORLEVEL%"=="3010" EXIT 0

# Start developer command prompt with any other commands specified.
ENTRYPOINT C:\BuildTools\Common7\Tools\VsDevCmd.bat &&

# Default to PowerShell if no other command specified.
CMD ["powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]
