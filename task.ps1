$location = "uksouth"
$resourceGroupName = "mate-resources"
$networkSecurityGroupName = "defaultnsg"
$virtualNetworkName = "vnet"
$subnetName = "default"
$sshKeyName = "linuxboxsshkey"
$vmBaseName = "matebox"
$vmImage = "Ubuntu2204"
$vmSize = "Standard_B1s"
$availabilitySetName = "mateavalset"

# Ідeмпотентне створення availability set
$avSet = Get-AzAvailabilitySet -ResourceGroupName $resourceGroupName -Name $availabilitySetName -ErrorAction SilentlyContinue
if (-not $avSet) {
    Write-Host "Creating availability set $availabilitySetName ..."
    New-AzAvailabilitySet `
      -ResourceGroupName $resourceGroupName `
      -Location $location `
      -Name $availabilitySetName `
      -PlatformFaultDomainCount 2 `
      -PlatformUpdateDomainCount 4 `
      -Sku Aligned
} else {
    Write-Host "Availability set $availabilitySetName already exists."
}

# Створюємо дві VM з посиланням на існуючі ресурси, без публічних IP
for ($i=1; $i -le 2; $i++) {
    $vmName = "$vmBaseName$i"
    Write-Host "Creating VM $vmName ..."
    New-AzVm `
      -ResourceGroupName $resourceGroupName `
      -Name $vmName `
      -Location $location `
      -Image $vmImage `
      -Size $vmSize `
      -SubnetName $subnetName `
      -VirtualNetworkName $virtualNetworkName `
      -SecurityGroupName $networkSecurityGroupName `
      -SshKeyName $sshKeyName `
      -AvailabilitySetName $availabilitySetName `
      -PublicIpAddress $null
}
