<#
.SYNOPSIS
    Creates an Azure Function app with all the fixings. 

.DESCRIPTION
    Creates an azure function app with it's dependencies such as the resource group, the storage account, the app insights, the app service plan, the function app with 2 slots (dev and qa) + backup policy + identity.

.PARAMETER RegionAzure
    The Region you want to create the resources in

.PARAMETER ResourceGroupName
    The Resource group you want to create the resouces in
    
.PARAMETER AppServicePlanName
    The Name of the App Service Plan
    
.PARAMETER AppName
    The Name of the App
    
.PARAMETER AppInsightsName
    The Name of App Insights
    
.PARAMETER StorageAccountName
    The StorageAccount Name used to manage Azure Functions
    
.PARAMETER TagHash
    The Tags that will be assigned to these resources upon creation
    
.PARAMETER Environments
    Environments to create

.EXAMPLE
    executes the procedure as written
    PS C:\> .\CreateAnAzureFunction.ps1 -RegionAzure "EastUS2" -$ResourceGroupName "SomeresourceGroup" -$AppServicePlanName "MyAppServicePlan" -$AppInsightsName "SomeInsightsName" -$StorageAccountName "somestorageaccountName"

.NOTES
    Author: Colby Lithyouvong
    Last Edit: 2021-12-06
    Version 1.0 - initial release

#>

param (
  [string]$RegionAzure = 'EastUs2'

  [string]$ResourceGroupName = "myfavoritegroup"

  [string]$AppServicePlanName = "$($ResourceGroupName)-AppServicePlan"

  [string]$AppName = "myFunctionApp-Functions2"

  [string]$AppInsightsName = "$($AppName)-Insights"

  [string]$StorageAccountName = "azfunc$(Get-Random -Minimum 1000 -Maximum 10000)"

  [hashtable]$TagHash = @{
      created=(Get-Date -Format "yyyy-MM-dd"); 
      createdBy='Colby Lithyouvong';
      Desc='';
      Project='';
      Ticket=''
  }

  [string[]]$Environments = @(
     "Dev",
     "QA"
  )
)


# -------------------------
# 1. PRE-SETUP
# -------------------------
$WarningPreference = 'SilentlyContinue'

function GetDateTimeNow(){
    return Get-Date -Format 'yyyy-MM-dd hh:mm:ss'
}


# -------------------------
# 2. Connect to Azure
# -------------------------
try{    
    Write-Output "$(GetDateTimeNow) AZURE CONNECT - Connecting..."
    $connection = Connect-AzAccount -ErrorAction Stop
}
catch{
    Write-output "$(GetDateTimeNow) AZURE CONNECT - $($_)"
}


# -------------------------
# 3. Resource Group 
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
# 4. Storage Account
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
        -Name "$($AppName.ToLower())-functions-backups" `
        -Context $StorageAccount.Context |
        Out-Null

    
}

# -------------------------
# 5. Application Insights
# -------------------------
try {
    Write-Output "$(GetDateTimeNow) APP - Insights - Retrieving..."
    $ApplicationInsights = Get-AzApplicationInsights `
        -Name $AppInsightsName `
        -ResourceGroupName $ResourceGroupName `
        -ErrorAction Stop
} catch {
    Write-Output "$(GetDateTimeNow) APP - Insights - Creating..."
    $ApplicationInsights = New-AzApplicationInsights `
        -Location $RegionAzure `
        -Name $AppInsightsName `
        -ResourceGroupName $ResourceGroupName `
        -Kind web `
        -Tag $TagHash
}

# -------------------------
# 6. App Service Plan
# -------------------------
try {
    Write-Output "$(GetDateTimeNow) APP - Service - Retrieving..."
    $AppServicePlan = Get-AzAppServicePlan `
                        -ResourceGroupName $ResourceGroupName `
                        -Name $AppServicePlanName 

    if($AppServicePlan -eq $null){
        throw
    }
} catch {
    Write-Output "$(GetDateTimeNow) APP - Service - Creating..."
    $AppServicePlan = New-AzAppServicePlan `
        -ResourceGroupName $ResourceGroupName `
        -Name $AppServicePlanName `
        -Location $RegionAzure `
        -Tag $TagHash `
        -Tier 'Standard' `
        -WorkerSize 'Small'
}


# -------------------------
# 7. Functions
# -------------------------
try {
    Write-Output "$(GetDateTimeNow) APP - Functions - Retrieving..."
    $AppFunc = Get-AzFunctionApp `
        -Name $AppName `
        -ResourceGroupName $ResourceGroupName `
        -ErrorAction Stop

    if($AppFunc -eq $null){
        throw
    }
} catch {
    Write-Output "$(GetDateTimeNow) APP - Functions - Creating..."
    $AppFunc = New-AzFunctionApp `
        -Name $AppName `
        -PlanName $AppServicePlanName `
        -ResourceGroupName $ResourceGroupName `
        -StorageAccountName $StorageAccountName `
        -ApplicationInsightsName $AppInsightsName `
        -ApplicationInsightsKey $ApplicationInsights.InstrumentationKey `
        -Tag $TagHash `
        -Runtime DotNet `
        -RuntimeVersion 3 `
        -IdentityType SystemAssigned `
        -OSType Windows `
        -FunctionsVersion 3 
        
    # -------------------------------------------------
    Write-Output "$(GetDateTimeNow) APP - Functions - Setting Web Settings"
    Set-AzWebApp `
        -Name $AppName `
        -ResourceGroupName $ResourceGroupName `
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
    Write-Output "$(GetDateTimeNow) APP - Functions - Updating Backup Configuration..."
    $SaSUrl = New-AzStorageContainerSASToken `
                    -Name "$($AppName.ToLower())-functions-backups" `
                    -Permission rwdl `
                    -Context $StorageAccount.Context `
                    -ExpiryTime (Get-Date).AddYears(100) `
                    -FullUri

    #Notice: 
    #    -StartTime "$(Get-Date -Format "yyyy-MM-dd")T04:00:00Z" `
    #    04 represents the -4 UTC time zone different. give or take. as long as it's around midnight.
    Edit-AzWebAppBackupConfiguration `
        -ResourceGroupName $ResourceGroupName `
        -Name $AppName `
        -StorageAccountUrl $SaSUrl `
        -FrequencyInterval 1 `
        -FrequencyUnit Day `
        -KeepAtLeastOneBackup `
        -StartTime "$(Get-Date -Format "yyyy-MM-dd")T04:00:00Z" `
        -RetentionPeriodInDays 7 |
        Out-Null
        
    # -------------------------------------------------
    foreach($environment in $Environments){
        
        Write-Output "$(GetDateTimeNow) APP - Functions - SLOT $($environment) - Creating Resource..."
        $AppFuncSlot = New-AzWebAppSlot `
            -ResourceGroupName $ResourceGroupName `
            -Name $AppName `
            -AppServicePlan $AppServicePlanName `
            -Slot $environment

            
        Write-Output "$(GetDateTimeNow) APP - Functions - SLOT $($environment) - Setting Web Settings"
        Set-AzWebAppSlot `
            -Name $AppName `
            -ResourceGroupName $ResourceGroupName `
            -Slot $environment `
            -AssignIdentity $true `
            -HttpsOnly $true | 
            Out-Null

    
        Write-Output "$(GetDateTimeNow) APP - Functions - SLOT $($environment) - Updating Tags..."
        Update-AzTag `
            -ResourceId $AppFuncSlot.Id `
            -Operation Merge `
            -Tag $TagHash | 
            Out-Null


        Write-Output "$(GetDateTimeNow) APP - Functions - SLOT $($environment) - Updating Backup Configuration..."
        $SaSUrl = New-AzStorageContainerSASToken `
                        -Name "$($AppName.ToLower())-functions-backups" `
                        -Permission rwdl `
                        -Context $StorageAccount.Context `
                        -ExpiryTime (Get-Date).AddYears(100) `
                        -FullUri

        #Notice: 
        #    -StartTime "$(Get-Date -Format "yyyy-MM-dd")T04:00:00Z" `
        #    04 represents the -4 UTC time zone different. give or take. as long as it's around midnight.
        Edit-AzWebAppBackupConfiguration `
            -ResourceGroupName $ResourceGroupName `
            -Name $AppFuncSlot.Name `
            -StorageAccountUrl $SaSUrl `
            -FrequencyInterval 1 `
            -FrequencyUnit Day `
            -KeepAtLeastOneBackup `
            -StartTime "$(Get-Date -Format "yyyy-MM-dd")T04:00:00Z" `
            -RetentionPeriodInDays 7 | 
            Out-Null
    }
}
