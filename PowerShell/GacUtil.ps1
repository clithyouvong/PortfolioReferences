$gacUtil = "${Env:ProgramFiles(x86)}\Microsoft SDKs\Windows\v7.0A\Bin\NETFX 4.0 Tools\gacutil.exe";

function Add-GacItem([string]$path) {

    #Full Path Name or Relative - ex: C:\Temp\Larned.dll
    & $gacutil "/nologo" "/i" "$path"
}

function Remove-GacItem([string]$name) {
    
    #Assembly Name - ex: if Dll was Larned.dll then  Larned
    & $gacutil "/nologo" "/u" "$name"
}

function Search-GacItem([string]$name) {
    
    #Assembly Name - ex: if Dll was Larned.dll then  Larned
    & $gacutil "/nologo" "/l" "$name"
