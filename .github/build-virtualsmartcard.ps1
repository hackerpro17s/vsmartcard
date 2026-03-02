$ErrorActionPreference = "Stop"
Set-PSDebug -Trace 1

& git submodule update --init --recursive

$VS_PATH = & "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe" -latest -products * -property installationPath
& "$VS_PATH\Common7\Tools\Launch-VsDevShell.ps1"
Enter-VsDevShell -VsInstallPath "$VS_PATH" -Arch $env:VCVARS_PLATFORM -HostArch $env:VCVARS_PLATFORM -SkipAutomaticLocation

& cl.exe /MT /Ivirtualsmartcard\src\vpcd virtualsmartcard\src\vpcd-config\vpcd-config.c virtualsmartcard\src\vpcd-config\local-ip.c ws2_32.lib

& msbuild "virtualsmartcard\win32\BixVReader.sln" "/p:Configuration=Release;Platform=$env:MSBUILD_PLATFORM"

& python --version
& python -m pip install --upgrade pip
& pip install virtualenv
& pip install -U setuptools
& pip install pycryptodomex
& pip install pbkdf2
& pip install Pillow
& pip install pyreadline3
& pip install pyscard
& pip install pyinstaller

& pyinstaller --onefile virtualsmartcard\src\vpicc\vicc.in -i doc\_static\chip.ico

dir "D:\a\vsmartcard\vsmartcard\virtualsmartcard\win32" -Recurse
dir "D:\a\vsmartcard\vsmartcard\dist" -Recurse
