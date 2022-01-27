
# -------------------------
# 0. Variables
# -------------------------
#The Region you want to create the resources in
$RegionAzure = 'placeholder'

#The Resource group you want to create the resouces in
$ResourceGroupName = "placeholder"

#The StorageAccount Name used to manage Azure Functions
$StorageAccountName = "placeholder"

#The Name of the App Service Plan
$AppServicePlanName = "placeholder"

#The Name of the App
$AppName = "placeholder"

#The Name of App Insights
$AppInsightsName = "$($AppName)-Insights"

#Environments to create
$Environments = @(
   "Dev",
   "QA"
)

#The Tags that will be assigned to these resources upon creation
$TagHash = @{
    created=(Get-Date -Format "yyyy-MM-dd"); 
    createdBy='Colby Lithyouvong';
    Desc='';
    Project='';
    Ticket=''
}

# -------------------------
# 1. PRE-SETUP
# -------------------------
$WarningPreference = 'SilentlyContinue'

function GetDateTimeNow(){
    return Get-Date -Format 'yyyy-MM-dd hh:mm:ss'
}

function CreateAppInsights {    
    <#
        .SYNOPSIS
        Creates an App Insights resource and attaches it to the suggested resources

        .DESCRIPTION
        Creates an App Insights resource and attaches it to the suggested resources
        
        .PARAMETER ResourceGroup
        The ResourceGroup Object

        .PARAMETER TagHash
        Hash Table of Tags

        .PARAMETER ApplicationInsightsName
        Name of Application Insights

        .PARAMETER ResourceType
        The ResourceManager Type that is being URL referenced.
        For Apps, ResourceType = "Microsoft.Web/sites/siteextensions"
        For App Slots, ResourceType = "Microsoft.Web/sites/slots/siteextensions"

        .PARAMETER ResourceName
        The name of the resource to enable the app insights extension on,
        For Apps, $($AppWeb.Name)/Microsoft.ApplicationInsights.AzureWebSites, Where $AppWeb.Name is $ResourceName
        For App Slots, $($AppWebSlot.Name)/Microsoft.ApplicationInsights.AzureWebSites, Where $AppWebSlot.Name is $ResourceName

        .PARAMETER AppSettings
        SiteConfig AppSettings Object.
        For Apps, $AppWeb.SiteConfig.AppSettings
        For App Slots, $AppWebSlots.SiteConfig.AppSettings

        .PARAMETER AppName
        The Name of the Web App being targeted.

        .PARAMETER Environment
        The Slot name of the Web App being targeted. (Optional)

        .INPUTS
        See List of Parameters Above.

        .OUTPUTS
        None. Just write to console
    #>
    param(
        [Parameter(Mandatory = $true)]
        $ResourceGroup,
        
        [Parameter(Mandatory = $true)]
        $TagHash,

        [Parameter(Mandatory = $true)]
        $RegionAzure,

        [Parameter(Mandatory = $true)]
        [string]$ApplicationInsightsName,


        [Parameter(Mandatory = $true)]
        [string]$ResourceType = "Microsoft.Web/sites/slots/siteextensions",

        [Parameter(Mandatory = $true)]
        [string]$ResourceName,

        [Parameter(Mandatory = $true)]
        $AppSettings,

        [Parameter(Mandatory = $true)]
        [string]$AppName,

        [Parameter(Mandatory = $false)]
        [string]$environment = ""

     )

    Begin {
        # Executes once before first item in pipeline is processed
    }

    Process {
        try {
            try {
                Write-Output "$(GetDateTimeNow) APP - Insights - Retrieving..."
                $ApplicationInsights = Get-AzApplicationInsights `
                    -Name $ApplicationInsightsName `
                    -ResourceGroupName $ResourceGroup.ResourceGroupName `
                    -ErrorAction Stop
            } catch {
                Write-Output "$(GetDateTimeNow) APP - Insights - Creating..."
                $ApplicationInsights = New-AzApplicationInsights `
                    -Location $RegionAzure `
                    -Name $ApplicationInsightsName `
                    -ResourceGroupName $ResourceGroup.ResourceGroupName `
                    -Kind web `
                    -Tag $TagHash `
                    -ErrorAction Stop
            }

             
            # -------------------------------------------------
            if($environment -eq ""){
                Write-Output "$($ApplicationInsightsName) - Enabling Extension"
                New-AzResource `
                    -ResourceType $ResourceType `
                    -ResourceGroupName $ResourceGroup.ResourceGroupName `
                    -Name "$($ResourceName)/Microsoft.ApplicationInsights.AzureWebSites" `
                    -ApiVersion "2018-02-01" `
                    -Force | 
                    Out-Null
            }
        
            # -------------------------------------------------
            Write-Output "$($ApplicationInsightsName) - Setting Configuration"
            $AppWebSettings = @{ }
            foreach ($setting in $AppSettings) {
              $AppWebSettings[$setting.Name] = $setting.Value
            }
            $AppWebSettings['APPINSIGHTS_INSTRUMENTATIONKEY'] = "$($ApplicationInsights.InstrumentationKey)" 
            $AppWebSettings['ApplicationInsightsAgent_EXTENSION_VERSION'] = "~2"
            $AppWebSettings['XDT_MicrosoftApplicationInsights_Mode'] = "recommended"
            $AppWebSettings['APPINSIGHTS_PROFILERFEATURE_VERSION'] = "1.0.0"
            $AppWebSettings['DiagnosticServices_EXTENSION_VERSION'] = "~3"
            $AppWebSettings['APPINSIGHTS_SNAPSHOTFEATURE_VERSION'] = "1.0.0"
            $AppWebSettings['SnapshotDebugger_EXTENSION_VERSION'] = "disabled"
            $AppWebSettings['InstrumentationEngine_EXTENSION_VERSION'] = "disabled"
            $AppWebSettings['XDT_MicrosoftApplicationInsights_BaseExtensions'] = "disabled"
        

            Write-Output "$($ApplicationInsightsName) - Setting Web Settings"
            if($environment -eq ""){
                Set-AzWebApp `
                    -Name $AppWeb.Name `
                    -ResourceGroupName $ResourceGroup.ResourceGroupName `
                    -AppSettings $AppWebSettings | 
                    Out-Null
            }
            else{
                Set-AzWebAppSlot `
                    -Name $AppWeb.Name `
                    -ResourceGroupName $ResourceGroup.ResourceGroupName `
                    -Slot $environment `
                    -AppSettings $AppWebSettings | 
                    Out-Null
            }
        } catch {
            Write-Output "APP - Insights - App Insights could not be created/Assigned. It may not be supported in the region you've selected"
            return;
        }       
    }
    End {
        # Executes once after last pipeline object is processed
    }
}
      


# -------------------------
# 2. Resource Group 
# -------------------------
try{
    Write-Output "$(GetDateTimeNow) RESOURCE GROUP - Retrieving..."
    $ResourceGroup = Get-AzResourceGroup `
                        -Name $ResourceGroupName `
                        -ErrorAction Stop
}
catch {
    Write-Output "$(GetDateTimeNow) RESOURCE GROUP - Not Found. Creating new..."
    $ResourceGroup = New-AzResourceGroup `
                        -Name $ResourceGroupName `
                        -Location $RegionAzure `
                        -Tag $TagHash
}


# -------------------------
# 3. Storage Account
# -------------------------
try {
    Write-Output "$(GetDateTimeNow) STORAGE ACCOUNT - Retrieving..."
    $StorageAccount = Get-AzStorageAccount `
                        -Name $StorageAccountName `
                        -ResourceGroupName $ResourceGroupName `
                        -ErrorAction Stop
} catch {
    Write-Output "$(GetDateTimeNow) STORAGE ACCOUNT - Not Found. Creating New..."    
    New-AzStorageAccount `
        -ResourceGroupName $ResourceGroupName `
        -Name $StorageAccountName `
        -SkuName 'Standard_GRS' `
        -Location $RegionAzure `
        -Kind 'StorageV2' `
        -AccessTier 'Hot' `
        -Tag $TagHash `
        -EnableHttpsTrafficOnly $true `
        -AssignIdentity |
    Enable-AzStorageDeleteRetentionPolicy -RetentionDays 7 |
    Out-Null
    
    Write-Output "$(GetDateTimeNow) STORAGE ACCOUNT - Retrieving..."
    $StorageAccount = Get-AzStorageAccount `
                        -Name $StorageAccountName `
                        -ResourceGroupName $ResourceGroupName

                        
    Write-Output "$(GetDateTimeNow) STORAGE ACCOUNT - Creating Web App Backup Container..."
    New-AzStorageContainer `
        -Name "$($AppName.ToLower())-web-backups" `
        -Context $StorageAccount.Context |
        Out-Null

    
}


# -------------------------
# 4. App Service Plan
# -------------------------
try {
    Write-Output "$(GetDateTimeNow) APP - SERVICE - Retrieving..."
    $AppServicePlan = Get-AzAppServicePlan `
                        -ResourceGroupName $ResourceGroup.ResourceGroupName `
                        -Name $AppServicePlanName 

    if($AppServicePlan -eq $null){
        throw
    }
} catch {
    Write-Output "$(GetDateTimeNow) APP - SERVICE - Creating..."
    $AppServicePlan = New-AzAppServicePlan `
        -ResourceGroupName $ResourceGroup.ResourceGroupName `
        -Name $AppServicePlanName `
        -Location $RegionAzure `
        -Tag $TagHash `
        -Tier 'Standard' `
        -WorkerSize 'Small'
}


# -------------------------
# 5. App Service
# -------------------------
try {
    Write-Output "$(GetDateTimeNow) APP - WEB - Retrieving..."
    $AppWeb = Get-AzWebApp `
        -ResourceGroupName $ResourceGroup.ResourceGroupName `
        -Name $AppName `
        -ErrorAction Stop
        
    if($AppWeb -eq $null){
        throw
    }
}
catch {
    Write-Output "$(GetDateTimeNow) APP - WEB - Creating..."
    $AppWeb = New-AzWebApp `
        -ResourceGroupName $ResourceGroup.ResourceGroupName `
        -AppServicePlan $AppServicePlan.Name `
        -Name $AppName `
        -Location $RegionAzure

             
     
    # -------------------------------------------------
    Write-Output "$(GetDateTimeNow) APP - WEB - Assigning App Insights"
    CreateAppInsights `
        -ResourceGroup $ResourceGroup `
        -RegionAzure $RegionAzure `
        -TagHash $TagHash `
        -ApplicationInsightsName $AppInsightsName `
        -ResourceType "Microsoft.Web/sites/siteextensions" `
        -ResourceName $AppWeb.Name `
        -AppSettings $AppWeb.SiteConfig.AppSettings `
        -AppName $AppWeb.Name
     
     
    # -------------------------------------------------
    Write-Output "$(GetDateTimeNow) APP - WEB - Setting Web Settings"
    Set-AzWebApp `
        -Name $AppWeb.Name `
        -ResourceGroupName $ResourceGroup.ResourceGroupName `
        -AlwaysOn $true `
        -AssignIdentity $true `
        -DetailedErrorLoggingEnabled $true `
        -FtpsState FtpsOnly `
        -HttpLoggingEnabled $true `
        -HttpsOnly $true `
        -ManagedPipelineMode Integrated `
        -MinTlsVersion 1.2 `
        -RequestTracingEnabled $true `
        -Use32BitWorkerProcess $false `
        -WebSocketsEnabled $true | 
        Out-Null

        
    # -------------------------------------------------
    Write-Output "$(GetDateTimeNow) APP - WEB - Updating Web Stack.."
    New-AzResource `
        -PropertyObject @{"CURRENT_STACK" =  "dotnet"} `
        -ResourceGroupName $ResourceGroup.ResourceGroupName `
        -ResourceType Microsoft.Web/sites/config `
        -ResourceName "$($AppWeb.Name)/metadata" `
        -ApiVersion 2018-02-01 `
        -Force | 
        Out-Null
 
    # -------------------------------------------------
    Write-Output "$(GetDateTimeNow) APP - WEB - Updating HTTP Version.."
    Set-AzResource `
        -PropertyObject @{ "http20Enabled" = $true } `
        -ResourceGroupName $ResourceGroup.ResourceGroupName `
        -ResourceType Microsoft.Web/sites/config `
        -ResourceName "$($AppWeb.Name)/web" `
        -ApiVersion 2016-08-01  `
        -Force | 
        Out-Null
        
    # -------------------------------------------------
    Write-Output "$(GetDateTimeNow) APP - WEB - Updating Cors.."
    Set-AzResource `
        -PropertyObject @{ "cors" = @{allowedOrigins =  @("*")} } `
        -ResourceGroupName $ResourceGroup.ResourceGroupName `
        -ResourceType Microsoft.Web/sites/config `
        -ResourceName "$($AppWeb.Name)/web" `
        -ApiVersion 2015-08-01  `
        -Force | 
        Out-Null
        
    # -------------------------------------------------
    Write-Output "$(GetDateTimeNow) APP - WEB - Updating Tags..."
    Update-AzTag `
        -ResourceId $AppWeb.Id `
        -Operation Merge `
        -Tag $TagHash | 
        Out-Null

    # -------------------------------------------------
    Write-Output "$(GetDateTimeNow) APP - WEB - Updating Logging.."
    $AppWebLogSettings = Get-AzResource `
        -ResourceGroupName $ResourceGroup.ResourceGroupName `
        -ResourceType Microsoft.Web/sites/config `
        -ResourceName "$($AppWeb.Name)/logs" `
        -ApiVersion 2016-08-01  

    $AppWebLogSettings.Properties.applicationLogs.fileSystem.level = "Error"
    $AppWebLogSettings.Properties.applicationLogs.azureBlobStorage.level = "Error" 
    $AppWebLogSettings.Properties.applicationLogs.azureBlobStorage.sasUrl = "https://$($StorageAccount.StorageAccountName).blob.core.windows.net/$($AppWeb.Name)-applicationlogs"
    $AppWebLogSettings.Properties.applicationLogs.azureBlobStorage.retentionInDays = 14
    $AppWebLogSettings.Properties.httpLogs.fileSystem.enabled = $true
    $AppWebLogSettings.Properties.httpLogs.fileSystem.retentionInMb = 40
    $AppWebLogSettings.Properties.httpLogs.fileSystem.retentionInDays = 14

    Set-AzResource `
        -PropertyObject $AppWebLogSettings.Properties `
        -ResourceGroupName $ResourceGroup.ResourceGroupName `
        -ResourceType Microsoft.Web/sites/config `
        -ResourceName "$($AppWeb.Name)/logs" `
        -ApiVersion 2016-08-01  `
        -Force |
        Out-Null

    
    # -------------------------------------------------
    Write-Output "$(GetDateTimeNow) APP - WEB - Updating Backup Configuration..."
    $SaSUrl = New-AzStorageContainerSASToken `
                    -Name "$($AppName.ToLower())-web-backups" `
                    -Permission rwdl `
                    -Context $StorageAccount.Context `
                    -ExpiryTime (Get-Date).AddYears(100) `
                    -FullUri

    #Notice: 
    #    -StartTime "$(Get-Date -Format "yyyy-MM-dd")T04:00:00Z" `
    #    04 represents the -4 UTC time zone different. give or take. as long as it's around midnight.
    Edit-AzWebAppBackupConfiguration `
        -ResourceGroupName $ResourceGroup.ResourceGroupName `
        -Name $AppWeb.Name `
        -StorageAccountUrl $SaSUrl `
        -FrequencyInterval 1 `
        -FrequencyUnit Day `
        -KeepAtLeastOneBackup `
        -StartTime "$(Get-Date -Format "yyyy-MM-dd")T04:00:00Z" `
        -RetentionPeriodInDays 7 |
        Out-Null

    $EnvironmentCounter = 0
    foreach($environment in $Environments){        
        $EnvironmentCounter++
        if($EnvironmentCounter -ge 5 -and $AppServicePlanTier -eq "Standard"){
            Write-Output "$(GetDateTimeNow) Slot Limit has exceeded the Standard Tier allotment"
            continue
        }
        elseif ($EnvironmentCounter -ge 20 -and ($AppServicePlanTier -eq "Premium" -or $AppServicePlanTier -eq "PremiumV2")){
            Write-Output "$(GetDateTimeNow) Slot Limit has exceeded the Standard Tier allotment"
            continue            
        }

        Write-Output "$(GetDateTimeNow) APP - WEB - SLOT $($environment) - Creating Resource..."
        $AppwebSlot = New-AzWebAppSlot `
            -ResourceGroupName $ResourceGroup.ResourceGroupName `
            -Name $AppWeb.Name `
            -AppServicePlan $AppServicePlan.Name `
            -Slot $environment
            

        Write-Output "$(GetDateTimeNow) APP - WEB - SLOT $($environment) - Assigning App Insights"
        $ApplicationInsightsName = "$($AppName)-$($environment)-Insights"
        CreateAppInsights `
            -ResourceGroup $ResourceGroup `
            -RegionAzure $RegionAzure `
            -TagHash $TagHash `
            -ApplicationInsightsName $ApplicationInsightsName `
            -ResourceType "Microsoft.Web/sites/slots/siteextensions" `
            -ResourceName $AppWebSlot.Name `
            -AppSettings $AppWebSlot.SiteConfig.AppSettings `
            -AppName $AppWeb.Name `
            -environment $environment

        Write-Output "$(GetDateTimeNow) APP - WEB - SLOT $($environment) - Setting Web Settings"
        Set-AzWebAppSlot `
            -Name $AppWeb.Name `
            -ResourceGroupName $ResourceGroup.ResourceGroupName `
            -Slot $environment `
            -AssignIdentity $true `
            -HttpsOnly $true | 
            Out-Null

    
        Write-Output "$(GetDateTimeNow) APP - WEB - SLOT $($environment) - Updating Tags..."
        Update-AzTag `
            -ResourceId $AppwebSlot.Id `
            -Operation Merge `
            -Tag $TagHash | 
            Out-Null


        Write-Output "$(GetDateTimeNow) APP - WEB - SLOT $($environment) - Updating Backup Configuration..."
        $SaSUrl = New-AzStorageContainerSASToken `
                        -Name "$($AppName.ToLower())-web-backups" `
                        -Permission rwdl `
                        -Context $StorageAccount.Context `
                        -ExpiryTime (Get-Date).AddYears(100) `
                        -FullUri

        #Notice: 
        #    -StartTime "$(Get-Date -Format "yyyy-MM-dd")T04:00:00Z" `
        #    04 represents the -4 UTC time zone different. give or take. as long as it's around midnight.
        Edit-AzWebAppBackupConfiguration `
            -ResourceGroupName $ResourceGroup.ResourceGroupName `
            -Name $AppWebSlot.Name `
            -StorageAccountUrl $SaSUrl `
            -FrequencyInterval 1 `
            -FrequencyUnit Day `
            -KeepAtLeastOneBackup `
            -StartTime "$(Get-Date -Format "yyyy-MM-dd")T04:00:00Z" `
            -RetentionPeriodInDays 7 | 
            Out-Null
    }
    
}
