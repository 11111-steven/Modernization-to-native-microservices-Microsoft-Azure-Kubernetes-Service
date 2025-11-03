// Define el nombre para el clúster de AKS
param clusterName string

// Define la ubicación
param location string

// Recibe el ID de la subred que creamos en el módulo vnet.bicep
param aksSubnetId string

// Nuevo parámetro para recibir el ID del Log Analytics Workspace
param logAnalyticsWorkspaceId string

// Creación del recurso Clúster de Kubernetes (AKS)
resource aksCluster 'Microsoft.ContainerService/managedClusters@2023-09-01' = {
  name: clusterName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dnsPrefix: clusterName
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: 1
        vmSize: 'Standard_B2s'
        osType: 'Linux'
        mode: 'System'
        vnetSubnetID: aksSubnetId
      }
    ]
    networkProfile: {
      networkPlugin: 'azure'
      serviceCidr: '10.1.0.0/16'
      dnsServiceIP: '10.1.0.10'
    }
    // Habilitamos el monitoreo con Azure Monitor for Containers
    addonProfiles: {
      omsagent: {
        enabled: true
        config: {
          // Usamos el ID del workspace que nos pasan como parámetro
          logAnalyticsWorkspaceResourceID: logAnalyticsWorkspaceId
        }
      }
    }
  }
}

// Exponemos el Principal ID de la identidad del clúster.
// Lo necesitamos para asignarle roles.
output aksPrincipalId string = aksCluster.identity.principalId
