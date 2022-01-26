# -------------------------
# 0. Variables
# -------------------------
#Resource Group Name
$ResourceGroupName = "Test-ResourceGroup"

#Resource Location
$RegionAzure = 'East US 2'

#Event Grid Name
$EventGridTopicName = "TestEventGridName"

#Tag Stuff
$TagCreated = '2020-07-13'
$TagCreateBy = 'Colby Lithyouvong'
$TagDesc = $SystemRegion
$TagProject = ''
$TagTicket = ''
$TagHash = @{
    created=$TagCreated; 
    createdBy=$TagCreateBy;
    Desc=$TagDesc;
    Project=$TagProject;
    Ticket=$TagTicket
}



# -------------------------
# 2. Resource Group 
# -------------------------
try{
    Write-Output 'RESOURCE GROUP - Retrieving...'
    $ResourceGroup = Get-AzResourceGroup `
                        -Name $ResourceGroupName `
                        -ErrorAction Stop
}
catch {
    Write-Output 'RESOURCE GROUP - Not Found. Creating new...'
    $ResourceGroup = New-AzResourceGroup `
                        -Name $ResourceGroupName `
                        -Location $RegionAzure `
                        -Tag $TagHash
}

# -------------------------
# 6. Event Grid
# -------------------------
try{
    $EventGridTopic = Get-AzEventGridTopic `
        -ResourceGroupName $ResourceGroup.ResourceGroupName `
        -Name $EventGridTopicName `
        -ErrorAction Stop
}catch {
    $EventGridTopic = New-AzEventGridTopic  `
        -ResourceGroupName $ResourceGroup.ResourceGroupName `
        -Name $EventGridTopicName `
        -Location $RegionAzure `
        -InputSchema 'EventGridSchema' `
        -Tag $TagHash
}

$EventGridTopic
