<#
 * Original Author(s): Colby Lithyouvong
 * Original Date (yyyy/mm): 2020 APR
 * Original Description: Adds Database Auditing Settings
 * Further Documentation:
 *    https://docs.microsoft.com/en-us/powershell/module/az.sql/set-azsqlserveraudit
 * Notes:
 *    - Requires Az PowerShell 3.7.0+ 
 #>
 
#Variables
$SubscriptionId = "placeholder"
$ResourceGroup = "placeholder"
$DatabaseServerName = "placeholder"

$StorageAccountResourceGroup = "placeholder"
$StorageAccountName = "placeholder"
$StorageAccountRetentionInDays = 14

$LogAnalyticsResourceGroup = "placeholder"
$LogAnalyticsWorkspaces = "placeholder"


#Open Connect to Azure
Connect-AzAccount
Select-AzSubscription -SubscriptionId $SubscriptionId 

#Actions
Set-AzSqlServerAudit `
    -BlobStorageTargetState Enabled `
    -StorageAccountResourceId "/subscriptions/$($SubscriptionId)/resourceGroups/$($StorageAccountResourceGroup)/providers/Microsoft.Storage/storageAccounts/$($StorageAccountName)" `
    -StorageKeyType "Primary" `
    -RetentionInDays $StorageAccountRetentionInDays `
    -LogAnalyticsTargetState Enabled `
    -WorkspaceResourceId "/subscriptions/$($SubscriptionId)/resourceGroups/$($LogAnalyticsResourceGroup)/providers/Microsoft.OperationalInsights/workspaces/$($LogAnalyticsWorkspaces)" `
    -ResourceGroupName $ResourceGroup `
    -ServerName $DatabaseServerName `
    -Confirm    

Write-Output "Complete. Application will close in 5 Seconds..." 

Start-Sleep 5
