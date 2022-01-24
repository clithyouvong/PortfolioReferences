$NSG = Get-AzNetworkSecurityGroup -ResourceGroupName placeholder -Name placeholder

foreach($rule in $NSG.SecurityRules){
    "Removing the rule: $($rule.Name)"
    Get-AzNetworkSecurityGroup -ResourceGroupName $NSG.ResourceGroupName -Name $NSG.Name |
    Remove-AzNetworkSecurityRuleConfig -Name $rule.Name | 
    Set-AzNetworkSecurityGroup | 
    Out-Null
    
}
