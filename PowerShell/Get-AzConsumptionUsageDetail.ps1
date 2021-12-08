<#
.SYNOPSIS
    Gets the Azure Consumption Usage Detail and output's it to a csv file

.DESCRIPTION
    This uses Get-AzConsumptionUsageDetail, grabs only relevant information, and outputs it to a csv file on the desktop. this assumes to be run from local.

.PARAMETER StartDate
    the date to begin the scan for az consumption usage

.PARAMETER EndDate
    the date to end the scan for az consumption usage

.EXAMPLE
    The output finishes in a few minutes with an output on the local desktop
    PS C:\> .\Get-AzConsumptionUsageDetail.ps1 -StartDate "2021-01-01" -EndDate "2021-01-01"

.NOTES
    Author: Colby Lithyouvong
    Last Edit: 2021-12-06
    Version 1.0 - initial release

#>

param (
  [string] $StartDate = "2021-01-01",
  
  [string] $EndDate = "2021-01-31"
)


function GetDateTimeNow(){
    return Get-Date -Format 'yyyyMMdd-hhmmss'
}

Get-AzConsumptionUsageDetail -EndDate $EndDate -StartDate $StartDate `
    | Where-Object {$_.ConsumedService -ne "Microsoft.Insights" -and $_.ConsumedService -ne "Microsoft.Storage"} `
    | Sort-Object InstanceId `
    | Select-Object @{name='InstanceId';expression= {$_.InstanceId -replace "/subscriptions/", ""}}, InstanceName, ConsumedService, Type, MeterDetails, PretaxCost `
    | Export-Csv -Path ".\Desktop\AzConsumptionUsageDetail-$(GetDateTimeNow).csv"
