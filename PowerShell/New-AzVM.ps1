# ***********************************************
# Original Author(s):		Colby Lithyouvong
# Original Date (YYYY/MM):	2021.07.20
# Original Description:		Creating a Virtual Machine
# Further Documentation:	https://docs.microsoft.com/en-us/powershell/module/az.compute/new-azvm?view=azps-6.2.1#examples
# Notes:					N/A
# ***********************************************

# -------------------------
# 0. Variables
# -------------------------
$Region = "East US 2"
$Tags = @{
    created=(Get-Date -Format "yyyy-MM-dd"); 
    createdBy='Colby Lithyouvong';
    Desc='';
    Project='';
    Ticket=''
}

$RGName = "test-colby-rg"

$VMName = "test-colby-vm"
$VMSize = "Standard_E16as_v4"
$VMComputerName = "test-colby-vm"

$VNETName = "test-colby-vm-vnet"
$VNETSubnetName = "test-colby-vm-subnet"
$IPName = "test-colby-vm-ip"
$NICName = "test-colby-vm-nic"
$NICConfigIPName = "test-colby-vm-nic-config-ip"
$NSGName = "test-colby-vm-nsg"
$WorkspaceName = "test-colby-vm-analytics"

$passwordminLength = 16 ## characters
$passwordmaxLength = 32 ## characters
$passwordlength = Get-Random -Minimum $passwordminLength -Maximum $passwordmaxLength
$passwordnonAlphaChars = 5
$passwordActual = [System.Web.Security.Membership]::GeneratePassword($passwordlength, $passwordnonAlphaChars)
$passwordSecured = ConvertTo-SecureString $passwordActual -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential ("admin", $passwordSecured)
Write-Output "The secured password is: $($passwordActual), please save this in a secured place..."


# -------------------------
# 1. PRE-SETUP, DON'T TOUCH
$VNETPeerings = Get-AzVirtualNetworkPeering `
    -ResourceGroupName Bastion `
    -VirtualNetworkName Bastion-VNET `
    | Select-Object { $_.RemoteVirtualNetworkAddressSpace.AddressPrefixes }

$list = New-Object Collections.Generic.List[string]
foreach($obj in $VNETPeerings){
    $list.Add($obj.' $_.RemoteVirtualNetworkAddressSpace.AddressPrefixes ');
}

$IPRange = 10;
$PrivateIPAddress = "10.$($IPRange).0.0/16"
$DoesContainPrivateIPRange = $false;

do{
    $DoesContainPrivateIPRange = $list.Contains($PrivateIPAddress);

    if($DoesContainPrivateIPRange){
        $IPRange++;
        $PrivateIPAddress = "10.$($IPRange).0.0/16"
    }
}while($DoesContainPrivateIPRange);
$VNETAddressPrefix = $PrivateIPAddress
Write-output "The address Prefix is: $($VNETAddressPrefix)"


function GetDateTimeNow(){
    return Get-Date -Format 'yyyy-MM-dd hh:mm:ss'
}

function Get-VMExtension {
    <#
    .SYNOPSIS
    Return the VM extension of specified ExtensionType
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)][string]$VMName,
        [Parameter(mandatory = $true)][string]$vmResourceGroupName,
        [Parameter(mandatory = $true)][string]$ExtensionType
    )

    $vm = Get-AzVM -Name $VMName -ResourceGroupName $vmResourceGroupName -DisplayHint Expand
    $extensions = $vm.Extensions

    foreach ($extension in $extensions) {
        if ($ExtensionType -eq $extension.VirtualMachineExtensionType) {
            Write-Verbose("$VMName : Extension: $ExtensionType found on VM")
            $extension
            return
        }
    }
    Write-Verbose("$VMName : Extension: $ExtensionType not found on VM")
}

function Install-VMExtension {
    <#
    .SYNOPSIS
    Install VM Extension, handling if already installed
    #>
    [CmdletBinding(SupportsShouldProcess = $true)]
    param
    (
        [Parameter(Mandatory = $true)][string]$VMName,
        [Parameter(mandatory = $true)][string]$VMLocation,
        [Parameter(mandatory = $true)][string]$VMResourceGroupName,
        [Parameter(mandatory = $true)][string]$ExtensionType,
        [Parameter(mandatory = $true)][string]$ExtensionName,
        [Parameter(mandatory = $true)][string]$ExtensionPublisher,
        [Parameter(mandatory = $true)][string]$ExtensionVersion,
        [Parameter(mandatory = $false)][hashtable]$PublicSettings,
        [Parameter(mandatory = $false)][hashtable]$ProtectedSettings,
        [Parameter(mandatory = $false)][boolean]$ReInstall
    )
    # Use supplied name unless already deployed, use same name
    $extensionName = $ExtensionName

    $extension = Get-VMExtension -VMName $VMName -VMResourceGroup $VMResourceGroupName -ExtensionType $ExtensionType
    if ($extension) {
        $extensionName = $extension.Name

        # of has Settings - it is LogAnalytics extension
        if ($extension.Settings) {
            if ($extension.Settings.ToString().Contains($PublicSettings.workspaceId)) {
                Write-Output("$VMName : Extension $ExtensionType already configured for this workspace. Provisioning State: " + $extension.ProvisioningState + " " + $extension.Settings)
            }
            else {
                if ($ReInstall -ne $true) {
                    Write-Warning("$VMName : Extension $ExtensionType already configured for a different workspace. Run with -ReInstall to move to new workspace. Provisioning State: " + $extension.ProvisioningState + " " + $extension.Settings)
                }
            }
        }
        else {
            Write-Output("$VMName : $ExtensionType extension with name " + $extension.Name + " already installed. Provisioning State: " + $extension.ProvisioningState + " " + $extension.Settings)
        }
    }

    if ($PSCmdlet.ShouldProcess($VMName, "install extension $ExtensionType") -and ($ReInstall -eq $true -or !$extension)) {

        $parameters = @{
            ResourceGroupName  = $VMResourceGroupName
            VMName             = $VMName
            Location           = $VMLocation
            Publisher          = $ExtensionPublisher
            ExtensionType      = $ExtensionType
            ExtensionName      = $extensionName
            TypeHandlerVersion = $ExtensionVersion
        }

        if ($PublicSettings -and $ProtectedSettings) {
            $parameters.Add("Settings", $PublicSettings)
            $parameters.Add("ProtectedSettings", $ProtectedSettings)
        }

        if ($ExtensionType -eq "OmsAgentForLinux") {
            Write-Output("$VMName : ExtensionType: $ExtensionType does not support updating workspace. Uninstalling and Re-Installing")
            $removeResult = Remove-AzVMExtension -ResourceGroupName $VMResourceGroupName -VMName $VMName -Name $extensionName -Force

            if ($removeResult -and $removeResult.IsSuccessStatusCode) {
                Write-Output("$VMName : Successfully removed $ExtensionType")
            }
            else {
                Write-Warning("$VMName : Failed to remove $ExtensionType (for $ExtensionType need to remove and re-install if changing workspace with -ReInstall)")
            }
        }

        Write-Output("$VMName : Deploying $ExtensionType with name $extensionName")
        $result = Set-AzVMExtension @parameters

        if ($result -and $result.IsSuccessStatusCode) {
            Write-Output("$VMName : Successfully deployed $ExtensionType")
        }
        else {
            Write-Warning("$VMName : Failed to deploy $ExtensionType")
        }
    }
}

$WarningPreference = 'SilentlyContinue'



# -------------------------
# 2. RG
Write-Output "$(GetDateTimeNow) RG - Retrieving [$($RGName)]..."
$RG = Get-AzResourceGroup -Name $RGName -ErrorAction SilentlyContinue
if($RG -eq $null){
    Write-Output "$(GetDateTimeNow) RG - Not Found, Creating [$($RGName)]..."
    $RG = New-AzResourceGroup -Location $Region -Name $RGName -Tag $Tags -ErrorAction Stop
}
 

# -------------------------
# 2. VNET
Write-Output "$(GetDateTimeNow) VNET - Retrieving [$($VNETName)]..."
$VNET = Get-AzVirtualNetwork -Name $VNETName -ResourceGroupName $RGName -ErrorAction SilentlyContinue
if($VNET -eq $null){
    Write-Output "$(GetDateTimeNow) VNET - Not Found, Creating [$($VNETName)]..."
    $VNET = New-AzVirtualNetwork `
        -ResourceGroupName $RGName `
        -Name $VNETName `
        -Location $Region `
        -AddressPrefix $VNETAddressPrefix `
        -Tag $Tags -Force `
        -ErrorAction Stop

    $VNET = Get-AzVirtualNetwork `
        -ResourceGroupName $RGName `
        -Name $VNETName

        
    $VNETBastion = Get-AzVirtualNetwork -Name Bastion-Vnet -ResourceGroupName Bastion
    $VNETPeeringName = "Bastion-Peering-$($VNETName)"
    Remove-AzVirtualNetworkPeering -Name $VNETPeeringName -ResourceGroupName Bastion -VirtualNetworkName Bastion-Vnet -Force -ErrorAction SilentlyContinue
    Write-Output "$(GetDateTimeNow) VNET - Enabling Bastion[$($VNETPeeringName)]..."
    Add-AzVirtualNetworkPeering -Name $VNETPeeringName -RemoteVirtualNetworkId $VNETBastion.Id -VirtualNetwork $VNET -ErrorAction Stop | out-null
    Add-AzVirtualNetworkPeering -Name $VNETPeeringName -RemoteVirtualNetworkId $VNET.Id -VirtualNetwork $VNETBastion -ErrorAction Stop | out-null
}



# -------------------------
# 3. VNET Subnet
Write-Output "$(GetDateTimeNow) Subnet - Retrieving [$($VNETSubnetName)]..."
$VNETSubnet = Get-AzVirtualNetworkSubnetConfig -VirtualNetwork $VNET -Name $VNETSubnetName -ErrorAction SilentlyContinue
if($VNETSubnet -eq $null){
    Write-Output "$(GetDateTimeNow) Subnet - Not Found, Creating [$($VNETSubnetName)]..."
    Add-AzVirtualNetworkSubnetConfig `
        -AddressPrefix $VNETAddressPrefix `
        -VirtualNetwork $VNET `
        -Name $VNETSubnetName `
        -ErrorAction Stop `
        | Set-AzVirtualNetwork `
        | Out-Null

    $VNETSubnet = Get-AzVirtualNetworkSubnetConfig `
        -VirtualNetwork $VNET `
        -Name $VNETSubnetName
}



# -------------------------
# 4. Public IP Address
Write-Output "$(GetDateTimeNow) IP - Retrieving [$($IPName)]..."
$IP = Get-AzPublicIpAddress -Name $IPName -ResourceGroupName $RGName -ErrorAction SilentlyContinue
if ($IP -eq $null) {
    Write-Output "$(GetDateTimeNow) IP - Not Found, Creating [$($IPName)]..."
    $IP = New-AzPublicIpAddress `
        -AllocationMethod Static `
        -ResourceGroupName $RGName `
        -DomainNameLabel $IPName.ToLower() `
        -Force `
        -IpAddressVersion IPv4 `
        -Location $Region `
        -Name $IPName.ToLower() `
        -Sku Standard `
        -Tag $Tags `
        -Tier Regional `
        -ErrorAction Stop

    $IP = Get-AzPublicIpAddress -Name $IPName.ToLower() -ResourceGroupName $RGName
}




# -------------------------
# 5. NSG
Write-Output "$(GetDateTimeNow) NSG - Retrieving [$($NSGName)]..."
$NSG = Get-AzNetworkSecurityGroup -Name $NSGName -ResourceGroupName $RGName -ErrorAction SilentlyContinue
if ($NSG -eq $null) {
    Write-Output "$(GetDateTimeNow) NSG - Not Found, Creating [$($NSGName)]..."
    $NSG = New-AzNetworkSecurityGroup `
        -Location $Region `
        -Name $NSGName `
        -ResourceGroupName $RGName `
        -Tag $Tags `
        -ErrorAction Stop

    $NSG = Get-AzNetworkSecurityGroup -Name $NSGName -ResourceGroupName $RGName
}

# -------------------------
# 6. NIC
Write-Output "$(GetDateTimeNow) NIC - Retrieving [$($NICName)]..."
$NIC = Get-AzNetworkInterface -Name $NICName -ResourceGroupName $RGName -ErrorAction SilentlyContinue
if ($NIC -eq $null) {    
    Write-Output "$(GetDateTimeNow) NIC - Not Found, Creating [$($NICName)]..."
    $NICVNET = Get-AzVirtualNetwork -Name $VNETName -ResourceGroupName $RGName
    $NICSUBNET = Get-AzVirtualNetworkSubnetConfig -Name $VNETSubnetName -VirtualNetwork $NICVNET
    $NICIP = Get-AzPublicIPAddress -Name $IPName -ResourceGroupName $RGName
    $NICIPConfig = New-AzNetworkInterfaceIpConfig -Name "$($NICName)-IPConfig" -Subnet $NICSUBNET -PublicIpAddress $NICIP -Primary 
    $NIC = New-AzNetworkInterface -Name $NICName -ResourceGroupName $RGName -Location $Region -IpConfiguration $NICIPConfig
    $NIC.NetworkSecurityGroup = $NSG
    $NIC.Tag = $Tags
    Set-AzNetworkInterface -NetworkInterface $NIC | Out-Null
}




# -------------------------
# 6. VM
Write-Output "$(GetDateTimeNow) VM - Retrieving [$($VMName)]..."
$VM = Get-AzVM -Name $VMName -ResourceGroupName $RGName -ErrorAction SilentlyContinue
if ($VM -eq $null) {
    Write-Output "$(GetDateTimeNow) VM - Not Found"
    Write-Output "$(GetDateTimeNow) VM - 1-7 Creating Config..."
    $VM = New-AzVMConfig `
        -VMName $VMName `
        -VMSize $VMSize `
        -LicenseType Windows_Server `
        -Priority Regular `
        -Tags $Tags `
        -Zone 3 `
        -ErrorAction Stop
        
    Write-Output "$(GetDateTimeNow) VM - 2-7 Creating OS..."
    $VM = Set-AzVMOperatingSystem `
        -ComputerName $VMComputerName `
        -Credential $Cred `
        -VM $VM `
        -Windows `
        -ProvisionVMAgent `
        -TimeZone "Eastern Standard Time" `
        -ErrorAction Stop
        
    Write-Output "$(GetDateTimeNow) VM - 3-7 Adding NIC..."
    $VM = Add-AzVMNetworkInterface -Id $NIC.Id -VM $VM -ErrorAction Stop
    
    # https://docs.microsoft.com/en-us/powershell/module/az.compute/set-azvmsourceimage?view=azps-6.2.1
    # To obtain an image offer, use the Get-AzVMImageOffer cmdlet.
    # To obtain a publisher, use the Get-AzVMImagePublisher cmdlet.
    # Specifies a version of a VMImage. To use the latest version, specify a value of latest instead of a particular version.
    Write-Output "$(GetDateTimeNow) VM - 4-7 Setting Source Image..."
    $VM = Set-AzVMSourceImage `
        -Offer WindowsServer `
        -PublisherName MicrosoftWindowsServer `
        -Skus 2019-datacenter-with-containers-g2 `
        -Version latest `
        -VM $VM `
        -ErrorAction Stop
        
    Write-Output "$(GetDateTimeNow) VM - 5-7 Creating VM..."
    New-AzVM `
        -Location $Region `
        -ResourceGroupName $RGName `
        -VM $VM `
        -Tag $Tags `
        -Zone 3 `
        -ErrorAction Stop | Out-Null

    $VM = Get-AzVM -Name $VMName -ResourceGroupName $RGName        
     
     
    Write-Output "$(GetDateTimeNow) VM - 6-7 Enabling System Identity..."
    Update-AzVM `
        -IdentityType SystemAssigned `
        -ResourceGroupName $RGName `
        -VM $VM `
        -Tag $Tags `
        -ErrorAction Stop | Out-Null
        

    Write-Output "$(GetDateTimeNow) VM - 7-7 Enabling Insights..."
    $Workspace = Get-AzOperationalInsightsWorkspace -Name $WorkspaceName -ResourceGroupName $RGName -ErrorAction SilentlyContinue
    if ($Workspace -eq $null) {
        $Workspace = New-AzOperationalInsightsWorkspace `
            -Location $Region `
            -Name $WorkspaceName `
            -ResourceGroupName $RGName `
            -RetentionInDays 30 `
            -Sku Standard `
            -Tag $Tags `
            -ErrorAction Stop
    }
    
    $WorkspacePrimarySharedKeys = Get-AzOperationalInsightsWorkspaceSharedKeys `
        -ResourceGroupName $Workspace.ResourceGroupName `
        -Name $Workspace.Name `
        -ErrorAction Stop
        
    Install-VMExtension `
        -VMName $VMName `
        -VMLocation $Region `
        -VMResourceGroupName $RGName `
        -ExtensionType "MicrosoftMonitoringAgent" `
        -ExtensionName "MMAExtension" `
        -ExtensionPublisher "Microsoft.EnterpriseCloud.Monitoring" `
        -ExtensionVersion "1.0" `
        -PublicSettings @{"workspaceId" = $Workspace.CustomerId; "stopOnMultipleConnections" = "true"} `
        -ProtectedSettings @{"workspaceKey" = $WorkspacePrimarySharedKeys.PrimarySharedKey} `
        -ErrorAction Stop

    Install-VMExtension `
        -VMName $VMName `
        -VMLocation $Region `
        -VMResourceGroupName $RGName `
        -ExtensionType "DependencyAgentWindows" `
        -ExtensionName "DAExtension" `
        -ExtensionPublisher "Microsoft.Azure.Monitoring.DependencyAgent" `
        -ExtensionVersion "9.5" `
        -ErrorAction Stop
}



