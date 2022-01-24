<#
 * Original Author(s): Colby Lithyouvong
 * Original Date (yyyy/mm): 2020 APR
 * Original Description: Adds Database Automatic Tuning
 * Further Documentation:
 *    https://docs.microsoft.com/en-us/powershell/module/az.sql/Set-AzSqlServerAdvisorAutoExecuteStatus
 *    https://docs.microsoft.com/en-us/powershell/module/az.sql/get-azsqlserveradvisor
 * Notes:
 *    - Requires Az PowerShell 3.7.0+ 
 #>
 
#Variables
$SubscriptionId = "placeholder"
$ResourceGroup = "placeholder"
$DatabaseServerName = "placeholder"


#Open Connect to Azure
Connect-AzAccount 
Select-AzSubscription -SubscriptionId $SubscriptionId

#Actions
Set-AzSqlServerAdvisorAutoExecuteStatus `
    -ResourceGroupName $ResourceGroup `
    -ServerName $DatabaseServerName `
    -AdvisorName "ForceLastGoodPlan" `
    -AutoExecuteStatus Enabled

Set-AzSqlServerAdvisorAutoExecuteStatus `
    -ResourceGroupName $ResourceGroup `
    -ServerName $DatabaseServerName `
    -AdvisorName "CreateIndex" `
    -AutoExecuteStatus Enabled

Set-AzSqlServerAdvisorAutoExecuteStatus `
    -ResourceGroupName $ResourceGroup `
    -ServerName $DatabaseServerName `
    -AdvisorName "DropIndex" `
    -AutoExecuteStatus Enabled

Write-Output "Complete. Application will close in 5 Seconds..." 

Start-Sleep 5
