$KeyVault = Get-AzKeyVault -ResourceGroupName placeholder -VaultName placeholder
$KeyVault2 = Get-AzKeyVault -ResourceGroupName placeholder -VaultName placeholder

$Secrets = Get-AzKeyVaultSecret -VaultName $KeyVault.VaultName
foreach($Secret in $Secrets){    
    $SecretAsString = Get-AzKeyVaultSecret -VaultName $KeyVault.VaultName -Name $Secret.Name -AsPlainText;
    $SecretAsSecureString = ConvertTo-SecureString $SecretAsString -AsPlainText -Force;

    Set-AzKeyVaultSecret -VaultName $KeyVault2.VaultName -Name $Secret.Name -SecretValue $SecretAsSecureString;
}
