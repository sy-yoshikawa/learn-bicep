@description('Location for all resources.')
param location string

var storageAccountName = 'bootdiags${uniqueString(resourceGroup().id)}'

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'Storage'
}

output storageUri string = storageAccount.properties.primaryEndpoints.blob
