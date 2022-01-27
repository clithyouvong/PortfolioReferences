


# -------------------------
# 0. Variables
# -------------------------
#The Region you want to create the resources in
$RegionAzure = 'placeholder'

#The Resource group you want to create the resouces in
$ResourceGroupName = "placeholder"

#The Name of the App Service Plan
$AppServicePlanName = "placeholder"

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
# 3. App Service Plan
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

$AppServicePlan
