// Define el nombre de la red virtual que se creará
param vnetName string

// Define la ubicación (región de Azure) donde se creará la red
param location string

// Define el nombre de la subred para los nodos de AKS
param aksSubnetName string = 'aks-subnet'

// Creación del recurso de la Red Virtual (VNet)
resource vnet 'Microsoft.Network/virtualNetworks@2023-05-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16' // Rango de IPs principal para toda la red
      ]
    }
    subnets: [
      {
        name: aksSubnetName
        properties: {
          addressPrefix: '10.0.0.0/24' // Rango de IPs específico para los nodos de AKS
        }
      }
    ]
  }
}

// 'output' expone información del recurso creado para que otros módulos puedan usarla.
// Exponemos el ID de la subred, que el clúster de AKS necesitará.
output aksSubnetId string = vnet.properties.subnets[0].id
