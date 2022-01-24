    <#
        .SYNOPSIS
        Performs a manual upgrade to the Service Fabric Cluster

        .DESCRIPTION
        Performs a manual upgrade to the Service Fabric Cluster

        .PARAMETER Name
        UpgradeScript.ps1

        .PARAMETER Extension
        ps1

        .INPUTS
        None. This is a manual process

        .OUTPUTS
        None. This is a manual process

        .EXAMPLE
        PS> Get-ServiceFabricClusterUpgrade

        .LINK
        https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-cluster-upgrade
        https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-cluster-upgrade-windows-server#enable-auto-upgrade-of-the-service-fabric-version-of-your-cluster
        https://docs.microsoft.com/en-us/powershell/module/servicefabric/start-servicefabricclusterupgrade?view=azureservicefabricps
    #>

<#
# ----------------------------------------
# Step 1: Connect to BOX using certs
# EXECUTE FIRST TO CONNECT THE SESSION TO THE CLUSTER
# ----------------------------------------
$ServiceFabricEndpointWithPort = "endpoint.region.cloudapp.azure.com:19000"
$ServiceFabricClusterCertificateThumbprint = 'placeholder'
$ServiceFabricAdminCertificateThumbprint = 'placeholder'

Connect-ServiceFabricCluster `
    -ConnectionEndpoint $ServiceFabricEndpointWithPort `
    -KeepAliveIntervalInSec 10 `
    -X509Credential `
    -ServerCertThumbprint $ServiceFabricClusterCertificateThumbprint `
    -FindType FindByThumbprint `
    -FindValue $ServiceFabricAdminCertificateThumbprint
# --------------------------------------------------------------------------------
#>




<#
# ----------------------------------------
# Step 2: Find the latest version and download it
#     EXECUTE THE FOLLOWING 2 sections AT THE SAME TIME
#     COPY THE LINK AND GO GRAB THE FILE; PLACE IT IN THE SAME FOLDER AS THIS SCRIPT
# ----------------------------------------

# ---------
# Step 2A: Get Target Version of current cluster
# ---------
$TargetCodeVersion = (Get-ServiceFabricClusterUpgrade).TargetCodeVersion;

# ---------
# Step 2B: Get Upgradable version
# ---------
$upgradeversions = Get-ServiceFabricRuntimeUpgradeVersion -BaseVersion $TargetCodeVersion
$LatestUpgradableVersion = ($upgradeversions | Select-object Version | Sort-Object -Property Version -Descending)[0].Version
$LatestUpgradableCodePath = ($upgradeversions | Where-Object {$_.Version -eq $LatestUpgradableVersion})[0].TargetPackageLocation

$LatestUpgradableVersion
$LatestUpgradableCodePath
# --------------------------------------------------------------------------------
#>




# ----------------------------------------
# Step 4: Copy Code Path
#    ONCE THE FILE IS IN THE SAME PATH AS THIS SCRIPT; (YOU MAY NEED TO RESTART THIS IDE)
#    REPLACE THE -CodePackagePath AS SHOWN BELOW,...
# ----------------------------------------
# Copy-ServiceFabricClusterPackage -Code -CodePackagePath .\MicrosoftAzureServiceFabric.8.0.521.9590.cab -ImageStoreConnectionString "fabric:ImageStore"
# --------------------------------------------------------------------------------



# ----------------------------------------
# Step 5: Register Service Fabric Cluster Version
#    REPLACE THE -CodePackagePath AS SHOWN BELOW,...
# ----------------------------------------
# Register-ServiceFabricClusterPackage -Code -CodePackagePath MicrosoftAzureServiceFabric.8.0.521.9590.cab
# --------------------------------------------------------------------------------



# ----------------------------------------
# Step 6: Start Service Fabric Cluster Upgrade
#    REPLACE THE -CodePackagePath AS SHOWN BELOW,...
# ----------------------------------------
# Start-ServiceFabricClusterUpgrade -Code -CodePackageVersion 8.0.521.9590 -Monitored -Confirm -FailureAction Rollback
# --------------------------------------------------------------------------------

Get-ServiceFabricClusterUpgrade

#Get-ServiceFabricRegisteredClusterCodeVersion

#Start-ServiceFabricClusterUpgrade -Code -CodePackageVersion 8.0.521.9590 -Monitored -FailureAction Rollback
