
# =============================================
# Original Author(s):		Colby Lithyouvong
# Original Date (YYYY/MM):	2020 Oct
# Original Description:	    Restarts an Application on a Service Fabric
# Further Documentation:	
#    https://stackoverflow.com/questions/38700891/connecting-to-azure-service-fabric-cluster-from-azure-vm
#    https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-connect-to-secure-cluster#connect-to-a-cluster-using-powershell
# Notes:	
#    Requires ServiceFabric Module (Installed with Explorer)
#    		
#    WARNING: 
#    - You must install the Service Fabric Admin Certificate PFX on the server before proceeding
#    - As the Local Machine and as the Current User
# =============================================
$ServiceFabricEndpointWithPort = 'endpoint.region.cloudapp.azure.com:19000'
$ServiceFabricClusterCertificateThumbprint = 'thumbprint'
$ServiceFabricAdminCertificateThumbprint = 'thumbprint'
$ServiceFabricApplicationName = 'fabric:/appname'
$ServiceFabricApplicationServiceName = 'fabric:/appname/app'

Connect-ServiceFabricCluster `
    -ConnectionEndpoint $ServiceFabricEndpointWithPort `
    -KeepAliveIntervalInSec 10 `
    -X509Credential `
    -ServerCertThumbprint $ServiceFabricClusterCertificateThumbprint `
    -FindType FindByThumbprint `
    -FindValue $ServiceFabricAdminCertificateThumbprint


#Restart-ServiceFabricDeployedCodePackage -ApplicationName $ServiceFabricApplicationName -ServiceName $ServiceFabricApplicationServiceName
#Restart-ServiceFabricNode -NodeName somenodename

    
#$nodes = Get-ServiceFabricNode
#foreach($node in $nodes){
#    $result =  Get-ServiceFabricDeployedReplica `
#            -NodeName $node.NodeName `
#            -ApplicationName $ServiceFabricApplicationName `
#        | Where-Object ServiceName -eq $ServiceFabricApplicationServiceName
#
#    $result
#        
#    foreach($result in $results){
#        Write-Output "Node:$($node.NodeName) PartitionId:$($result.Partitionid) ReplicaInstanceId:$($result.ReplicaOrInstanceId)"
#        
#        #Restart-ServiceFabricReplica `
#        #    -NodeName $nodes[$i].NodeName `
#        #    -PartitionId $result.Partitionid `
#        #    -ReplicaOrInstanceId $result.ReplicaOrInstanceId
#        #
#        #    
#        #Restart-ServiceFabricDeployedCodePackage `
#        #    -NodeName $nodes[$i].NodeName `
#        #    -ApplicationName $ServiceFabricApplicationName `
#        #    -CodePackageName $result.CodePackageName `
#        #    -ServiceManifestName $result.ServiceManifestName `
#        #    -CommandCompletionMode Verify
#    }
#}
