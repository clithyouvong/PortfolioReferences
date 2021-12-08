<#
.SYNOPSIS
    This script creates network security group rules based on a Storage Account Table that has firewall configurations defined

.DESCRIPTION
    Using the module StorageTable for CloudTable, this queries the table object, reads the firewall name context into an NSG rule

.PARAMETER ResourceGroupName
    the resource group name. this is used for both the storage account and the network security group

.PARAMETER StorageAccountName
    the storage account anme
    
.PARAMETER StorageTableName
    the storage account table name
    
.PARAMETER NetworkSecurityGroupName
    the network security group name

.EXAMPLE
    The example imports the firewall settings from the storage account table
    PS C:\> .\SetFirewallRules.ps1 -ResourceGroupName "someresourcegroup" -StorageAccountName "someStorageAccountName" -StorageTableName "someStorageTableName" -NetworkSecurityGroupName "someNSG"

.NOTES
    Author: Colby Lithyouvong
    Last Edit: 2021-12-06
    Version 1.0 - initial release

#>

param (
  [string]$ResourceGroupName,
  [string]$StorageAccountName,
  [string]$StorageTableName,
  [string]$NetworkSecurityGroupName
)

$StorageAccount = Get-AzStorageAccount -Name $StorageAccountName -ResourceGroupName $ResourceGroupName;
$StorageTable = Get-AzStorageTable -Name $StorageTableName -Context $StorageAccount.Context;
$StorageTableRows = Get-AzTableRow -Table $StorageTable.CloudTable | Sort-Object -Property Name

$NSG = Get-AzNetworkSecurityGroup -ResourceGroupName $ResourceGroupName -Name $NetworkSecurityGroupName

$NextAvailablePriority = 100
foreach($Row in $StorageTableRows){
    try {
    
        Write-Output "VM - Creating NSG Firewall Rule: $($Row.Name)"
        Add-AzNetworkSecurityRuleConfig `
            -NetworkSecurityGroup $NSG `
            -Name $Row.Name `
            -Description 'Default Access' `
            -Access Allow `
            -Protocol Tcp `
            -Direction Inbound `
            -Priority $NextAvailablePriority `
            -SourceAddressPrefix $Row.SourceAddressPrefix `
            -SourcePortRange * `
            -DestinationAddressPrefix * `
            -DestinationPortRange $Row.DestinationPortRange `
            -ErrorAction Stop `
        | Set-AzNetworkSecurityGroup `
        | Out-Null
    } catch {
        Write-Output "VM - NSG Firewall Rule - $($_)"
    }

    $NextAvailablePriority++
    
}
