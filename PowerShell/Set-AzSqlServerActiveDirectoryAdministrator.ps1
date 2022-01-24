<#
 * Original Author(s): Colby Lithyouvong
 * Original Date (yyyy/mm): 2020 APR
 * Original Description: Sets SQL Server Azure Active Directory Administrator
 * Further Documentation:
 *    https://docs.microsoft.com/en-us/powershell/module/az.sql/set-azsqlserveractivedirectoryadministrator
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
Set-AzSqlServerActiveDirectoryAdministrator `
    -ResourceGroupName $ResourceGroup `
    -ServerName $DatabaseServerName `
    -DisplayName "user@domain.com"

Write-Output "Complete. Application will close in 5 Seconds..." 

Start-Sleep 5
