<#
  .SYNOPSIS
  Gets the Azure Consumption Usage Detail and output's it to a csv file

  .DESCRIPTION
  Gets the Azure Consumption Usage Detail and output's it to a csv file
  
  .Author
  Colby Lithyouvong

#>

$StartDate = "2021-01-01"
$EndDate = "2021-01-31"

function GetDateTimeNow(){
    return Get-Date -Format 'yyyyMMdd-hhmmss'
}

Get-AzConsumptionUsageDetail -EndDate $EndDate -StartDate $StartDate `
    | Where-Object {$_.ConsumedService -ne "Microsoft.Insights" -and $_.ConsumedService -ne "Microsoft.Storage"} `
    | Sort-Object InstanceId `
    | Select-Object @{name='InstanceId';expression= {$_.InstanceId -replace "/subscriptions/", ""}}, InstanceName, ConsumedService, Type, MeterDetails, PretaxCost `
    | Export-Csv -Path ".\Desktop\AzConsumptionUsageDetail-$(GetDateTimeNow).csv"
