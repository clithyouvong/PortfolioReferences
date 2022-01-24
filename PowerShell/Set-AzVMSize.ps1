$RGName = "placeholder"
$VMName = "placeholder"

Write-Output "1/5 Shutting Down VM..."
Stop-AzVM -Name $VMName -ResourceGroupName $RGName -Force -ErrorAction Stop


Write-Output "2/5 Getting VM..."
$VM = Get-AzVM -Name $VMName -ResourceGroupName $RGName -ErrorAction Stop


Write-Output "3/5 Setting VM to higher SKU..."
$VM.HardwareProfile.VmSize = 'Standard_E8as_v4'


Write-Output "4/5 Updating VM..."
Update-AzVM -VM $VM -ResourceGroupName $RGName -ErrorAction Stop


Write-Output "5/5 Restarting VM..."
Start-AzVM -Name $VMName -ResourceGroupName $RGName
