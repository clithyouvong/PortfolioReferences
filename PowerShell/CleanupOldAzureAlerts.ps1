$WarningPreference = 'SilentlyContinue'

$Alerts = Get-AzMetricAlertRuleV2

function DoUnknownRuleCleanup(){
    foreach ($Alert in $Alerts) {
        try {
            "Resource Check for Alert: $($Alert.Name)"
            Get-AzResource -ResourceId $Alert.TargetResourceId -ErrorAction Stop | Out-Null
        } catch {
            "Resource for Alert: $($Alert.Name) could not be found. Removing the Alert..."
            Remove-AzMetricAlertRuleV2 -InputObject $Alert
        }
    
    }
}

DoUnknownRuleCleanup
