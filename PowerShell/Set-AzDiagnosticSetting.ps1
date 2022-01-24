<#
 * Original Author(s): Colby Lithyouvong
 * Original Date (yyyy/mm): 2020 APR
 * Original Description: Sets Diagnostic Settings Policy
 * Further Documentation:
 *    https://docs.microsoft.com/en-us/powershell/module/az.monitor/set-azdiagnosticsetting
 * Notes:
 *    - Requires Az PowerShell 3.7.0+ 
 *    - Azure CLI: az sql db list --resource-group placeholder --server placeholder --query [*].[name] -o table
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
    Set-AzDiagnosticSetting `
       -ResourceId "/subscriptions/$($SubscriptionId)/resourceGroups/$($ResourceGroup)/providers/Microsoft.Sql/servers/$($DatabaseServerName)/databases/$($i)" `
       -Name "$($DatabaseServerName).$($i) Diagnostic Settings" `
       -StorageAccountId "/subscriptions/$($SubscriptionId)/resourceGroups/$($StorageAccountResourceGroup)/providers/Microsoft.Storage/storageAccounts/$($StorageAccountName)" `
       -Enabled $true `
       -Category SQLInsights,AutomaticTuning,QueryStoreRuntimeStatistics,QueryStoreWaitStatistics,Errors,DatabaseWaitStatistics,Timeouts,Blocks,Deadlocks `
       -MetricCategory Basic,InstanceAndAppAdvanced,WorkloadManagement `
       -RetentionEnabled $true `
       -WorkspaceId "/subscriptions/$($SubscriptionId)/resourceGroups/$($LogAnalyticsResourceGroup)/providers/Microsoft.OperationalInsights/workspaces/$($LogAnalyticsWorkspaces)" `
       -RetentionInDays $StorageAccountRetentionInDays   
}

Write-Output "Complete. Application will close in 5 Seconds..." 

Start-Sleep 5
