
$disk = Get-WmiObject Win32_LogicalDisk -ComputerName placeholder -Filter "DeviceID='C:'" |
Select-Object Size,FreeSpace

$size = $disk.Size
$size = (($size / 1024) / 1024) / 1024;
$size = [math]::Round($size,2);

$free = $disk.FreeSpace
$free = (($free / 1024) / 1024) / 1024;
$free = [math]::Round($free,2);

$percent = ($free / $size) * 100;
$percent = [math]::Round($percent,2);

$Message = "C Drive: $($percent)% Free, $($free) GB / $($size) GB"

