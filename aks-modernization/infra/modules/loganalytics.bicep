// Define el nombre para el Log Analytics Workspace
param workspaceName string

// Define la ubicación
param location string

// Creación del recurso Log Analytics Workspace
resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: workspaceName
  location: location
  properties: {
    sku: {
      name: 'PerGB2018' // SKU estándar y de pago por uso
    }
    retentionInDays: 30 // Retenemos los logs por 30 días (el mínimo y más barato)
  }
}

// Exponemos el ID del recurso para que otros módulos lo puedan usar
output workspaceId string = logAnalytics.id
