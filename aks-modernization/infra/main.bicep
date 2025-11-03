
// PARÁMETROS: Entradas para nuestro despliegue.

param resourceNamePrefix string
param location string
param acrName string


// VARIABLES: Nombres construidos que usaremos en los recursos.

var vnetName = '${resourceNamePrefix}-vnet'
var aksClusterName = '${resourceNamePrefix}-aks'
var logAnalyticsWorkspaceName = '${resourceNamePrefix}-logs'


// MÓDULOS: Despliegue de los componentes de la infraestructura.

module virtualNetwork 'modules/vnet.bicep' = {
  name: 'virtualNetworkDeployment'
  params: {
    vnetName: vnetName
    location: location
  }
}

module containerRegistry 'modules/acr.bicep' = {
  name: 'containerRegistryDeployment'
  params: {
    acrName: acrName
    location: location
  }
}

module logAnalytics 'modules/loganalytics.bicep' = {
  name: 'logAnalyticsDeployment'
  params: {
    workspaceName: logAnalyticsWorkspaceName
    location: location
  }
}

module kubernetesCluster 'modules/aks.bicep' = {
  name: 'kubernetesClusterDeployment'
  params: {
    clusterName: aksClusterName
    location: location
    aksSubnetId: virtualNetwork.outputs.aksSubnetId
    logAnalyticsWorkspaceId: logAnalytics.outputs.workspaceId
  }
}


// RECURSO: Obtenemos una referencia al ACR para usarlo en el 'scope'.

resource acr 'Microsoft.ContainerRegistry/registries@2023-07-01' existing = {
  name: acrName
}


// ASIGNACIÓN DE ROL: Conexión final entre AKS y ACR.

resource assignAcrPullRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, acrName, aksClusterName, 'AcrPull')
  scope: acr
  properties: {
    // Usando el ID del rol 'AcrPull' de la suscripción.
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')
    principalId: kubernetesCluster.outputs.aksPrincipalId
    principalType: 'ServicePrincipal'
  }
}
