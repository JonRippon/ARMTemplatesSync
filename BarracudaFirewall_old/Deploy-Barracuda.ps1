<#
 .SYNOPSIS
    Deploys a template to Azure

 .DESCRIPTION
    Deploys an Azure Resource Manager template

 .PARAMETER subscriptionId
    The subscription id where the template will be deployed.

 .PARAMETER resourceGroupName
    The resource group where the template will be deployed. Can be the name of an existing or a new resource group.

 .PARAMETER resourceGroupLocation
    Optional, a resource group location. If specified, will try to create a new resource group in this location. If not specified, assumes resource group is existing.

 .PARAMETER deploymentName
    The deployment name.

 .PARAMETER templateFilePath
    Optional, path to the template file. Defaults to template.json.

 .PARAMETER parametersFilePath
    Optional, path to the parameters file. Defaults to parameters.json. If file is not found, will prompt for parameter values based on template.
#>

param(
[Parameter(Mandatory=$True)]
 [string]
 $subscriptionId = "f3692419-df7f-427d-87b3-d3c003784d75",

 [string]
 $deploymentName = "Barracuda Firewall",

 [string]
 $Location ="northeurope"

 [string]
 $BarracudaFWName ="azclafwl01"

 [string]
 $BarracudaFWNIC ="azclafwl0701"

 [string]
 $BarracudaFWsize =""

 [string]
 $resourceGroupFW = "rg-mgt-firewall",

 [string]
 $Location ="northeurope",

 [string]
 $resourceGroupFWStorage ="rg-mgt-firewall"

 [string]
 $resourceGroupMGTNetwork ="rg-mgt-network"

 [string]
 $resourceGroupmMGTObjectsNetwork="rg-mgt-accounts"

 [string]
 $fwpublicIP ="pip-mgt-fwl01"

 [string]
 $storageaccountname ="stoclamgrfwl01"

 [string]
 $availabilitysetname =""

 [string]
 $storageaccountname ="stoclamgrfwl01"

 [string]
 $availabilitysetresourcegroup=""

 [string]
 $availabilitysetlocation=""

)

<#
.SYNOPSIS
    Registers RPs
#>
Function RegisterRP {
    Param(

        [string]$ResourceProviderNamespace
    )

    Write-Host "Registering resource provider '$ResourceProviderNamespace'";
    Register-AzureRmResourceProvider -ProviderNamespace $ResourceProviderNamespace;
}

#******************************************************************************
# Script body
# Execution begins here
#******************************************************************************
$ErrorActionPreference = "Stop"

# sign in
Write-Host "Logging in...";
Login-AzureRmAccount;

# select subscription
Write-Host "Selecting subscription '$subscriptionId'";
Select-AzureRmSubscription -SubscriptionID $subscriptionId;

# Register RPs
$resourceProviders = @("microsoft.network");
if($resourceProviders.length) {
    Write-Host "Registering resource providers"
    foreach($resourceProvider in $resourceProviders) {
        RegisterRP($resourceProvider);
    }
}


#New Resource Group for storage account 
New-AzureRmResourceGroup -Name  $resourceGroupFWStorage -Location $resourceGroupFWLocation

#Storage Account for VM 
New-AzureRmStorageAccount -ResourceGroupName  $resourceGroupFWStorage -Name $storageaccountname -Type Standard_LRS -Location $Location

#New Resource Group for the Barracuda Firewall 
New-AzureRmResourceGroup -Name $resourceGroupFW -Location $Location

# Create Availability Set 
$vmAvSet = New-AzureRmAvailabilitySet -Name $availabilitysetname -ResourceGroupName $availabilitysetresourcegroup -Location $Location

#Store the virtual network in a variable:
$vnet = Get-AzureRmVirtualNetwork -ResourceGroupName $resourceGroupMGTNetwork -Name "vnet-mgt-network"

#Create a static Azure public IP:
$pip = New-AzureRmPublicIpAddress -ResourceGroupName $resourceGroupmMGTObjectsNetwork -Location $location -Name $fwpublicIP -DomainNameLabel DOMAIN_NAME -AllocationMethod Static

#Create the first network interfac
$nic = New-AzureRmNetworkInterface -ResourceGroupName  $resourceGroupFW  -Location $location -Name $BarracudaFWNIC -PublicIpAddressId $pip.Id -SubnetId  $vnet.Subnets[0].Id -EnableIPForwarding

$storageAccount = Get-AzureRmStorageAccount -Name STORAGE_ACCOUNT_NAME -ResourceGroupName STORAGE_RESOURCE_GROUP_NAME

$vm = New-AzureRmVMConfig -VMName $BarracudaFWName -VMSize $BarracudaFWsize -AvailabilitySetId $availabilitysetname.Id

$cred = New-Object pscredential 'placeholderusername', ('YOUR_ROOT_PASSWORD' | ConvertTo-SecureString -AsPlainText -Force)

$vm = Set-AzureRmVMOperatingSystem -VM $vm -Linux -ComputerName $BarracudaFWName -Credential $cred 

$vm = Add-AzureRmVMNetworkInterface -VM $vm -Id $nic.Id -Primary 

#Set the OS disk: Set the plan information and source image to use the latest Marketplace image. To use the PAYG image, set Skus to hourly. Otherwise, set Skus to byol
$vm.Plan = @{'name'= 'byol'; 'publisher'= 'barracudanetworks'; 'product' = 'barracuda-ng-firewall'}

$vm = Set-AzureRmVMSourceImage -VM $vm -PublisherName 'barracudanetworks' -Skus 'byol' -Offer 'barracuda-ng-firewall' -Version  'latest' 
$vm = Set-AzureRmVMOSDisk -VM $vm -Name $diskName -VhdUri URI_TO_OS_DISK -CreateOption fromImage 

$vm = Set-AzureRmVMOSDisk -VM $vm -Name NAME_OF_DISK -VhdUri DISK_URI -CreateOption fromImage -Linux

$vm = Add-AzureRmVMDataDisk -VM $vm -Name NAME_OF_DATA_DISK1 -DiskSizeInGB DATA_DISK_SIZE_IN_GB -CreateOption Empty -Lun 1 -VhdUri DATA_DISK1_URI
$vm = Add-AzureRmVMDataDisk -VM $vm -Name NAME_OF_DATA_DISK2 -DiskSizeInGB DATA_DISK_SIZE_IN_GB -CreateOption Empty -Lun 2 -VhdUri DATA_DISK2_URI
$vm = Add-AzureRmVMDataDisk -VM $vm -Name NAME_OF_DATA_DISK3 -DiskSizeInGB DATA_DISK_SIZE_IN_GB -CreateOption Empty -Lun 3 -VhdUri DATA_DISK3_URI

New-AzureRmVM -ResourceGroupName $resourceGroupFW -Location $location -VM $vm
