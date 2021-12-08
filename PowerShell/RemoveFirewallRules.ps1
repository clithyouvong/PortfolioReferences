<#
.SYNOPSIS
    This script removes security rules from the Azure Network Security Group

.DESCRIPTION
    Uses the Get-AzNetworkSecurityGroup rule to retrieve the values and then removes it using the Remove-AzNetworkSecurityRuleConfig

.PARAMETER ResourceGroupName
    The name of the resource group being targeted

.PARAMETER NetworkSecurityGroupName
    The name of the network security group being targeted

.EXAMPLE
    The example removes all the firewall rules from the network security group
    PS C:\> .\RemoveFirewallRules.ps1 -ResourceGroupName "Some Resource Group Name" -NetworkSecurityGroupName "Some Network Security Group Name"

.NOTES
    Author: Colby Lithyouvong
    Last Edit: 2021-12-06
    Version 1.0 - initial release

#>

param {
  [string] $ResourceGroupName,
  [string] $NetworkSecurityGroupName
}

$NSG = Get-AzNetworkSecurityGroup -ResourceGroupName $ResourceGroupName -Name $NetworkSecurityGroupName

foreach($rule in $NSG.SecurityRules){
    "Removing the rule: $($rule.Name)"
    Get-AzNetworkSecurityGroup -ResourceGroupName $NSG.ResourceGroupName -Name $NSG.Name |
    Remove-AzNetworkSecurityRuleConfig -Name $rule.Name | 
    Set-AzNetworkSecurityGroup | 
    Out-Null
    
}
