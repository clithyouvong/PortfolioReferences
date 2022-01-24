
# ------------------------------
# Variables
# ------------------------------
$SourceResourceGroupName = "placeholder"
$SourceServerName = "placeholder"
$SourceDatabaseName = "placeholder"
$DestinationResourceGroupName = "placeholder"
$DestinationServerName = "placeholder"
$DestinationDatabaseName = "placeholder"
$DestinationElasticPoolName = "placeholder"
$DestinationTags = @{
    created=(Get-Date -Format "yyyy-MM-dd"); 
    createdBy='Colby Lithyouvong';
    Desc='';
    Project='';
    Ticket=''
}

# ------------------------------
# Copy Database
# ------------------------------
Write-Warning "Now Copying Database: [$($SourceResourceGroupName)].[$($SourceServerName)].[$($SourceDatabaseName)] to [$($DestinationResourceGroupName)].[$($DestinationServerName)].[$($DestinationDatabaseName)]"
Write-Warning "This will take a few minutes. Depending on the Size of the Source DB, this out could take up to 2 hours..."
New-AzSqlDatabaseCopy `
    -ResourceGroupName $SourceResourceGroupName `
    -ServerName $SourceServerName `
    -DatabaseName $SourceDatabaseName `
    -CopyResourceGroupName $DestinationResourceGroupName `
    -CopyServerName $DestinationServerName `
    -CopyDatabaseName $DestinationDatabaseName `
    -ComputeGeneration Gen5 `
    -VCore 2 `
    -BackupStorageRedundancy Geo `
    -Tags $DestinationTags
  
  
# ------------------------------
# joining Database To Elastic Pool
# ------------------------------  
Write-Warning "Successfully copied Database: [$($SourceResourceGroupName)].[$($SourceServerName)].[$($SourceDatabaseName)] to [$($DestinationResourceGroupName)].[$($DestinationServerName)].[$($DestinationDatabaseName)]!!!"
Write-Warning "Now Joining the Database: [$($DestinationResourceGroupName)].[$($DestinationServerName)].[$($DestinationDatabaseName)], to Elastic Pool [$($DestinationElasticPoolName)]..."
Set-AzSqlDatabase `
    -ResourceGroupName $DestinationResourceGroupName `
    -ServerName $DestinationServerName `
    -DatabaseName $DestinationDatabaseName `
    -ElasticPoolName $DestinationElasticPoolName;

Write-Warning "Successfully joined Database: [$($DestinationResourceGroupName)].[$($DestinationServerName)].[$($DestinationDatabaseName)], to Elastic Pool [$($DestinationElasticPoolName)]!!!"
