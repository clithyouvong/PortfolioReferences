<#
.SYNOPSIS
    Cleans up old alerts that resources cannot be found connected to

.DESCRIPTION
    when a resource is deleted an we created alerts for it, those need to be manually removed, 
    otherwise they just sit there. This script cleans that process up. 

.EXAMPLE
    The example below does blah
    PS C:\> Example

.NOTES
    Author: Colby Lithyouvong
    Last Edit: 2021-12-06
    Version 1.0 - initial release

#>

param (

)

$WarningPreference = 'SilentlyContinue'

$Alerts = Get-AzMetricAlertRuleV2

foreach ($Alert in $Alerts) {
    try {
        "Resource Check for Alert: $($Alert.Name)"
        Get-AzResource -ResourceId $Alert.TargetResourceId -ErrorAction Stop | Out-Null
    } catch {
        "Resource for Alert: $($Alert.Name) could not be found. Removing the Alert..."
        Remove-AzMetricAlertRuleV2 -InputObject $Alert
    }

}
