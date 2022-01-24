<#
 * Original Author(s): Colby Lithyouvong
 * Original Date (yyyy/mm): 2020 APR
 * Original Description: Sets Database Retention Policy
 * Further Documentation:
 *    https://docs.microsoft.com/en-us/powershell/module/az.sql/set-azsqldatabasebackuplongtermretentionpolicy
 *    https://docs.microsoft.com/en-us/powershell/module/az.sql/set-azsqldatabasebackupshorttermretentionpolicy
 *    https://docs.microsoft.com/en-us/azure/sql-database/sql-database-long-term-backup-retention-configure#using-powershell
 * Notes:
 *    - Requires Az PowerShell 3.7.0+ 
 *    - Azure CLI: az sql db list --resource-group placeholder --server placeholder --query [*].[name] -o table
 #>
 
#Variables
$SubscriptionId = "placeholder"
$ResourceGroup = "placeholder"
$DatabaseServerName = "placeholder"

#az sql db list --resource-group placeholder --server placeholder --query [*].[name] -o table
$Databases = @(
    "placeholder",
    "placeholder"
)

#Open Connect to Azure
Connect-AzAccount 
Select-AzSubscription -SubscriptionId $SubscriptionId

#Actions
foreach ($i in $Databases)
{
    Set-AzSqlDatabaseBackupShortTermRetentionPolicy `
       -RetentionDays 14 `
       -ResourceGroupName $ResourceGroup `
       -ServerName $DatabaseServerName `
       -DatabaseName $i 

    Set-AzSqlDatabaseBackupLongTermRetentionPolicy `
       -WeeklyRetention "14" `
       -MonthlyRetention "P7M" `
       -YearlyRetention "P3Y" `
       -WeekOfYear 1 `
       -ServerName $DatabaseServerName `
       -DatabaseName $i `
       -ResourceGroupName $ResourceGroup         
}

Write-Output "Complete. Application will close in 5 Seconds..." 

Start-Sleep 5
