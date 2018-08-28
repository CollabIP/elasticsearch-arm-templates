<#
Create-VMfromSnapshot.ps1

#>
# Parameters section
param(
    #Provide the subscription Id
    [parameter(Mandatory=$true)]
    [string]$subscriptionId = '98696c29-2ed1-4a19-9a9b-e8957224bd14',

    #Provide the name of your resource group
    [parameter(Mandatory=$true)]
    [string]$resourceGroupName ='estemplate-poc-rg',

    #Provide the name of the snapshot that will be used to create OS disk
    [parameter(Mandatory=$true)]
    [string]$snapshotName = '',

    #Provide the name of the OS disk that will be created using the snapshot
    [parameter(Mandatory=$true)]
    [string]$osDiskName = '',

    #Provide the name of an existing virtual network where virtual machine will be created
    [parameter(Mandatory=$true)]
    [string]$virtualNetworkName = '',

    #Provide the name of the virtual machine
    [parameter(Mandatory=$true)]
    [string]$virtualMachineName = '',

    #Provide the size of the virtual machine
    #e.g. Standard_DS3
    #Get all the vm sizes in a region using below script:
    #e.g. Get-AzureRmVMSize -Location westus
    [parameter(Mandatory=$true)]
    [string]$virtualMachineSize = 'Standard_DS1_v2'
)

#Set the context to the subscription Id where Managed Disk will be created
Select-AzureRmSubscription -SubscriptionId $SubscriptionId

$snapshot = Get-AzureRmSnapshot -ResourceGroupName $resourceGroupName -SnapshotName $snapshotName

$diskConfig = New-AzureRmDiskConfig -Location $snapshot.Location -SourceResourceId $snapshot.Id -CreateOption Copy
 
$disk = New-AzureRmDisk -Disk $diskConfig -ResourceGroupName $resourceGroupName -DiskName $osDiskName

#Initialize virtual machine configuration
$VirtualMachine = New-AzureRmVMConfig -VMName $virtualMachineName -VMSize $virtualMachineSize

#Use the Managed Disk Resource Id to attach it to the virtual machine. Please change the OS type to linux if OS disk has linux OS
$VirtualMachine = Set-AzureRmVMOSDisk -VM $VirtualMachine -ManagedDiskId $disk.Id -CreateOption Attach -Linux

#Create a public IP for the VM
$publicIp = New-AzureRmPublicIpAddress -Name ($VirtualMachineName.ToLower()+'_ip') -ResourceGroupName $resourceGroupName -Location $snapshot.Location -AllocationMethod Dynamic

#Get the virtual network where virtual machine will be hosted
$vnet = Get-AzureRmVirtualNetwork -Name $virtualNetworkName -ResourceGroupName $resourceGroupName

# Create NIC in the first subnet of the virtual network
$nic = New-AzureRmNetworkInterface -Name ($VirtualMachineName.ToLower()+'_nic') -ResourceGroupName $resourceGroupName -Location $snapshot.Location -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $publicIp.Id

$VirtualMachine = Add-AzureRmVMNetworkInterface -VM $VirtualMachine -Id $nic.Id

#Create the virtual machine with Managed Disk
New-AzureRmVM -VM $VirtualMachine -ResourceGroupName $resourceGroupName -Location $snapshot.Location