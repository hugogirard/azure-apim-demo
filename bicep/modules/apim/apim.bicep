param location string
param suffix string
param apimSubnetId string

@secure()
param publisherEmail string
@secure()
param publisherName string

resource pip 'Microsoft.Network/publicIPAddresses@2020-07-01' = {
  name: 'pip-apim-${suffix}'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'  
    dnsSettings: {
      domainNameLabel: 'apim-${suffix}'
      fqdn: 'apim-${suffix}.azure-api.net'
    }  
  }
}

resource apim 'Microsoft.ApiManagement/service@2021-01-01-preview' = {
  name: 'api-gt-${suffix}'
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  sku:{
    capacity: 0
    name: 'Consumption'
  }
  properties:{        
    publisherEmail: publisherEmail
    publisherName: publisherName    
  }
}

// resource apim 'Microsoft.ApiManagement/service@2021-01-01-preview' = {
//   name: 'apim-${suffix}'
//   location: location
//   identity: {
//     type: 'SystemAssigned'
//   }
//   sku:{
//     capacity: 1
//     name: sku
//   }
//   properties:{    
//     virtualNetworkType: 'External'
//     publisherEmail: publisherEmail
//     publisherName: publisherName
//     virtualNetworkConfiguration: {
//       subnetResourceId: apimSubnetId
//     }
//     publicIpAddressId: pip.id
//   }
// }

output apimIdentityId string = apim.identity.principalId
output apimName string = apim.name
