@description('Username for the Virtual Machine.')
param adminUsername string

@description('Password for the Virtual Machine.')
@minLength(12)
@secure()
param adminPassword string

@description('Unique DNS Name for the Public IP used to access the Virtual Machine.')
param dnsLabelPrefix string = toLower('${vmName}-${uniqueString(resourceGroup().id, vmName)}')

@description('Name for the Public IP used to access the Virtual Machine.')
param publicIpName string = 'myPublicIP'

param OSVersion string = '2022-datacenter-azure-edition'

param vmSize string = 'Standard_B2s'

@description('Location for all resources.')
param location string = resourceGroup().location

@description('Name of the virtual machine.')
param vmName string = 'simple-vm'

var nicName = 'myVMNic'
var addressPrefix = '10.0.0.0/16'
var subnetName = 'Subnet'
var subnetPrefix = '10.0.0.0/24'
var virtualNetworkName = 'MyVNET'

module storageAccount 'storage.bicep' = {
  name: 'storageAccount-deploy'
  params: {
    location: location
  }
}

module networkSecurityGroup 'nsg.bicep' = {
  name: 'networkSecurityGroup-deploy'
  params: {
    location: location
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-05-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetPrefix
          networkSecurityGroup: {
            id: networkSecurityGroup.outputs.networkSecurityGroupid
          }
        }
      }
    ]
  }
}


module nic 'nic.bicep' = {
  name: 'nic-deploy'
  params: {
    dnsLabelPrefix: dnsLabelPrefix
    location: location
    nicName: nicName
    publicIpName: publicIpName
    subnetid: resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworkName, subnetName)
  }
  dependsOn: [
    virtualNetwork
  ]
}

module vm 'vm.bicep' = {
  name: 'vm-deploy'
  params: {
    adminPassword: adminPassword
    adminUsername: adminUsername
    location: location
    nicid: nic.outputs.nicid
    Storageuri: storageAccount.outputs.storageUri
    vmName: vmName
    OSVersion: OSVersion
    vmSize: vmSize
  }
}

output hostname string = nic.outputs.publicipAddress
