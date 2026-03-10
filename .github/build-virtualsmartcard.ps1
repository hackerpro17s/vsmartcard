$PSNativeCommandUseErrorActionPreference = $true
$ErrorActionPreference = "Stop"
Set-PSDebug -Trace 1

$TestCertFile = Join-Path (Get-Location) "BixVReader.cer"
$cert = New-SelfSignedCertificate -Type CodeSigningCert -Subject 'CN=UMDF Test Certificate' -KeyExportPolicy Exportable -CertStoreLocation Cert:\CurrentUser\My
Export-Certificate -Cert $cert -FilePath "$TestCertFile"

$VS_PATH = & "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe" -latest -products * -property installationPath
& "$VS_PATH\Common7\Tools\Launch-VsDevShell.ps1"
Enter-VsDevShell -VsInstallPath "$VS_PATH" -Arch $env:VCVARS_PLATFORM -HostArch $env:VCVARS_PLATFORM -SkipAutomaticLocation

& cl.exe /MT /Ivirtualsmartcard\src\vpcd virtualsmartcard\src\vpcd-config\vpcd-config.c virtualsmartcard\src\vpcd-config\local-ip.c ws2_32.lib

& msbuild "virtualsmartcard\win32\BixVReader.sln" "/p:Configuration=Release;Platform=$env:MSBUILD_PLATFORM;TestCertFile=$TestCertFile"

& python --version
& python -m pip install -q --upgrade pip
& pip install -q virtualenv
& pip install -q -U setuptools
& pip install -q pycryptodomex
& pip install -q pbkdf2
& pip install -q Pillow
& pip install -q pyreadline3
& pip install -q pyscard
& pip install -q pyinstaller

& pyinstaller --onefile virtualsmartcard\src\vpicc\vicc.in -i doc\_static\chip.ico
