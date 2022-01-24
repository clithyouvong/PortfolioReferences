$WebApps = Get-AzWebApp | Select-Object ResourceGroup,Name

foreach($WebApp in $WebApps){
    $WebAppThis = Get-AzWebApp -Name $WebApp.Name -ResourceGroupName $WebApp.ResourceGroup
    $WebAppSiteConfig = $WebAppThis.SiteConfig;
    $WebAppMinTlsVersion = $WebAppSiteConfig.MinTlsVersion;
    
    if($WebAppMinTlsVersion -ne 1.2){
        "$($WebApp.ResourceGroup).$($WebApp.Name) - Minimum TLS Version: $($WebAppMinTlsVersion)";
    }

    if($WebAppThis.HttpsOnly -ne $true){
         "$($WebApp.ResourceGroup).$($WebApp.Name) - Https: $($WebAppThis.HttpsOnly)"
    }
    
    $WebAppSlots = Get-AzWebAppSlot -Name $WebApp.Name -ResourceGroupName $WebApp.ResourceGroup | Select-Object Name
    
    foreach ($WebAppSlot in $WebAppSlots){
        $WebAppSlotName = $WebAppSlot.Name -replace "$($WebApp.Name)/", ""
    
    
        $WebAppSlotThis = Get-AzWebAppSlot -Name $WebApp.Name -ResourceGroupName $WebApp.ResourceGroup -Slot $WebAppSlotName
        $WebAppSlotSiteConfig = $WebAppSlotThis.SiteConfig;
        $WebAppSlotMinTlsVersion = $WebAppSlotSiteConfig.MinTlsVersion;
    
        if($WebAppSlotMinTlsVersion -ne 1.2){
            "$($WebApp.ResourceGroup).$($WebApp.Name).$($WebAppSlotName) - Minimum TLS Version: $($WebAppSlotMinTlsVersion)";
        }

        if($WebAppSlotThis.HttpsOnly -ne $true){
             "$($WebApp.ResourceGroup).$($WebApp.Name).$($WebAppSlotName) - Https: $($WebAppSlotThis.HttpsOnly)"
        }
    }
}
