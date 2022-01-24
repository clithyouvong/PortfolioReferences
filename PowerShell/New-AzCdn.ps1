<#
 * Original Author(s): Colby Lithyouvong
 * Original Date (yyyy/mm): 2020 APR
 * Original Description: Creates a New CDN Endpoint
 * Further Documentation:
 *    https://docs.microsoft.com/en-us/powershell/module/az.cdn/New-AzCdnEndpoint?view=azps-3.7.0
 *    https://docs.microsoft.com/en-us/azure/cdn/cdn-manage-powershell
 * Notes:
 *    - Requires Az PowerShell 3.7.0+ 
 #>

#Azure subscription ID; probably shouldn't change
$SubscriptionId = "placeholder"

#Name of the CDN Profile; probably shouldn't change
$CDNProfileName = "placeholder"

#Name of the CDN Profile Resource group; probably shouldn't change
$CDNProfileResourceGroup = "placeholder"

#The endpoint name you want to give out of {endpointname}.azureedge.net
#To prevent collision with extraneous endpoints outside of the company;
#   it's recommended to append 'epfr' at the beginning.
#   ?[epfr][a-zA-Z]+[-0-9a-ZA-Z]+^
#Note - some calls to this endpoint may resolve to become 'case-sensitive';
#   possibly consider using lowercase characters only.
$CDNEndpointName = "placeholder"

#Add Tags Here
$tags = @{
    "created"="2020-04-14";
    "createdby"="Colby Lithyouvong";
    "project"="";
    "ticket"="";
    "desc"="";
}

#The name of the resource you want to associate with
$OriginName = "placeholder"

#The URL endpoint of the resource you want to associate with
$OriginHostName = "placeholder.blob.core.windows.net"

#The Directory within the resource you want to associate with where the endpoint will start it's root at; 
#If you want it to encapsulate the entire resource, don't include this in the commandlet;
#Not included in the commandlet by default;
$OriginPath = ""

#By default, these mime content types are included;
#turning on compression reduces size and improve performance.
#to exclude this feature, set the flag to $false
$ContentTypesToCompress = @(
    "text/plain",
    "text/html",
    "text/css",
    "text/javascript",
    "application/x-javascript",
    "application/javascript",
    "application/json",
    "application/xml"
)

#Settings for Diagnostics; probably shouldn't change...
$StorageAccountResourceGroup = "placeholder"
$StorageAccountName = "placeholder"
$StorageAccountRetentionInDays = 14
$LogAnalyticsResourceGroup = "placeholder"
$LogAnalyticsWorkspaces = "placeholder"

#Open Connect to Azure
Connect-AzAccount 
Select-AzSubscription -SubscriptionId $SubscriptionId

#Actions
New-AzCdnEndpoint -ProfileName $CDNProfileName `
                  -ResourceGroupName $CDNProfileResourceGroup `
                  -Location "East US 2" `
                  -EndpointName $CDNEndpointName `
                  -OriginName $OriginName `
                  -OriginHostName $OriginHostName `
                  -ContentTypesToCompress $ContentTypesToCompress `
                  -IsCompressionEnabled $true `
                  -IsHttpAllowed $false `
                  -IsHttpsAllowed $true `
                  -HttpPort 80 `
                  -HttpsPort 443 `
                  -OptimizationType "GeneralWebDelivery" `
                  -Tag $tags

Set-AzDiagnosticSetting `
    -ResourceId "/subscriptions/$($SubscriptionId)/resourcegroups/$($CDNProfileResourceGroup)/providers/Microsoft.Cdn/profiles/$($CDNProfileName)/endpoints/$($CDNEndpointName)" `
    -Name "CDN.Endpoint.$($CDNEndpointName) Diagnostic Settings" `
    -StorageAccountId "/subscriptions/$($SubscriptionId)/resourceGroups/$($StorageAccountResourceGroup)/providers/Microsoft.Storage/storageAccounts/$($StorageAccountName)" `
    -Enabled $true `
    -Category CoreAnalytics `
    -RetentionEnabled $true `
    -WorkspaceId "/subscriptions/$($SubscriptionId)/resourceGroups/$($LogAnalyticsResourceGroup)/providers/Microsoft.OperationalInsights/workspaces/$($LogAnalyticsWorkspaces)" `
    -RetentionInDays $StorageAccountRetentionInDays 

Write-Output "Complete. Application will close in 5 Seconds..." 

Start-Sleep 5
