taskkill /im jackett* /f
$myprocess = Start-Process "c:\ProgramData\Jackett\JackettConsole.exe" -ArgumentList "--DataFolder=c:\config" -PassThru
$myprocess.WaitForExit()

