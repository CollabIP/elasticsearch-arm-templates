<#
 # 

Encrypt-DataDisk.ps1

 #>

Param(
    $rgName = 'estemplate-poc-rg3', #VMs Resource Group name
    $vmName = 'ctedeu2d01esd04',  #VM name
    $KeyVaultName = 'es-dev-kv', # KeyVault name
    $keyEncryptionKeyName = 'disk-key', #Keyname. Must create in Azure in advance
    $location = 'eastus2', #Keyvault region,
    $volumeType = "All"  # Select volume type to encrypt.  Options: All, OS, Data
)
$KeyVault = Get-AzureRmKeyVault -VaultName $KeyVaultName -ResourceGroupName $rgName;
$diskEncryptionKeyVaultUrl = $KeyVault.VaultUri;
$KeyVaultResourceId = $KeyVault.ResourceId;
$keyEncryptionKeyUrl = (Get-AzureKeyVaultKey -VaultName $KeyVaultName -Name $keyEncryptionKeyName).Key.kid;

Write-Host "Get start time" -ForegroundColor Green
Get-Date
Set-AzureRmVMDiskEncryptionExtension -ResourceGroupName $rgname -VMName $vmName -DiskEncryptionKeyVaultUrl $diskEncryptionKeyVaultUrl -DiskEncryptionKeyVaultId $KeyVaultResourceId -KeyEncryptionKeyUrl $keyEncryptionKeyUrl -KeyEncryptionKeyVaultId $KeyVaultResourceId -SkipVmBackup -VolumeType $volumeType -Verbose

Write-Host 'Check disk status' -ForegroundColor Green
Get-AzureRmVMDiskEncryptionStatus -ResourceGroupName $rgname -VMName $vmName