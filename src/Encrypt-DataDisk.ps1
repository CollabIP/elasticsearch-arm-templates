<#
 # 

Encrypt-DataDisk.ps1

 #>

Param(
    $rgName = 'estemplate-poc-rg', #VM�s Resource Group name
    $vmName = 'ctesddata-3',  #VM name
    $KeyVaultName = 'es-poc-kv', # KeyVault name
    $keyEncryptionKeyName = 'ESpocKey', #Keyname. Must create in Azure in advance
    $location = 'eastus2', #Keyvault region,
    $volumeType = "OS"  # Select volume type to encrypt.  Options: All, OS, Data
)
$KeyVault = Get-AzureRmKeyVault -VaultName $KeyVaultName -ResourceGroupName $rgName;
$diskEncryptionKeyVaultUrl = $KeyVault.VaultUri;
$KeyVaultResourceId = $KeyVault.ResourceId;
$keyEncryptionKeyUrl = (Get-AzureKeyVaultKey -VaultName $KeyVaultName -Name $keyEncryptionKeyName).Key.kid;

Set-AzureRmVMDiskEncryptionExtension -ResourceGroupName $rgname -VMName $vmName -DiskEncryptionKeyVaultUrl $diskEncryptionKeyVaultUrl -DiskEncryptionKeyVaultId $KeyVaultResourceId -KeyEncryptionKeyUrl $keyEncryptionKeyUrl -KeyEncryptionKeyVaultId $KeyVaultResourceId -SkipVmBackup -VolumeType $volumeType 

Write-Host 'Check disk status' -ForegroundColor Green
Get-AzureRmVMDiskEncryptionStatus -ResourceGroupName $rgname -VMName $vmName