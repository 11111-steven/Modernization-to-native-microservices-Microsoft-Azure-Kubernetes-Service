// Define el nombre único global para el Azure Container Registry (ACR)
param acrName string

// Define la ubicación (debe ser la misma que la del resto de recursos)
param location string

// Creación del recurso ACR
resource acr 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: acrName
  location: location
  // SKU 'Basic' es el más económico y suficiente para este proyecto
  sku: {
    name: 'Basic'
  }
  properties: {
    // Habilitamos el usuario administrador. Facilita el inicio de sesión desde la CLI local,
    adminUserEnabled: true
  }
}

// Exponemos el ID del ACR. El clúster de AKS lo necesita para obtener permisos de extracción.
output acrId string = acr.id
