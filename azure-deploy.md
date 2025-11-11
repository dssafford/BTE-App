# Azure Deployment Guide

This guide covers deploying the BTE App to Azure using Azure Functions (backend) and Azure Static Web Apps (frontend).

## Prerequisites

1. Azure CLI installed and logged in: `az login`
2. Node.js 18+ installed
3. Python 3.11+ installed
4. Azure Functions Core Tools (optional for local testing): `npm install -g azure-functions-core-tools@4`

## Backend Deployment (Azure Functions)

### 1. Install Azure Dependencies

```bash
cd BTE_APP_backend
pip install -r requirements.txt -r requirements.azure.txt
```

### 2. Create Azure Resources

```bash
# Set variables
RESOURCE_GROUP="bte-app-rg"
LOCATION="eastus"
FUNCTION_APP_NAME="bte-api-functions"
STORAGE_ACCOUNT="bteappstorage$(date +%s)"

# Create resource group
az group create --name $RESOURCE_GROUP --location $LOCATION

# Create storage account
az storage account create \
  --name $STORAGE_ACCOUNT \
  --location $LOCATION \
  --resource-group $RESOURCE_GROUP \
  --sku Standard_LRS

# Create Function App (Python 3.11)
az functionapp create \
  --resource-group $RESOURCE_GROUP \
  --consumption-plan-location $LOCATION \
  --runtime python \
  --runtime-version 3.11 \
  --functions-version 4 \
  --name $FUNCTION_APP_NAME \
  --storage-account $STORAGE_ACCOUNT \
  --os-type Linux
```

### 3. Set Up Azure Key Vault (Optional - for production DB credentials)

```bash
KEY_VAULT_NAME="bte-keyvault-$(date +%s)"

# Create Key Vault
az keyvault create \
  --name $KEY_VAULT_NAME \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION

# Add database credentials as secrets
az keyvault secret set --vault-name $KEY_VAULT_NAME --name "db-username" --value "your_username"
az keyvault secret set --vault-name $KEY_VAULT_NAME --name "db-password" --value "your_password"
az keyvault secret set --vault-name $KEY_VAULT_NAME --name "db-host" --value "your_host"
az keyvault secret set --vault-name $KEY_VAULT_NAME --name "db-port" --value "3306"
az keyvault secret set --vault-name $KEY_VAULT_NAME --name "db-name" --value "your_dbname"

# Enable Managed Identity for Function App
az functionapp identity assign \
  --name $FUNCTION_APP_NAME \
  --resource-group $RESOURCE_GROUP

# Get the managed identity principal ID
PRINCIPAL_ID=$(az functionapp identity show \
  --name $FUNCTION_APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --query principalId -o tsv)

# Grant Function App access to Key Vault
az keyvault set-policy \
  --name $KEY_VAULT_NAME \
  --object-id $PRINCIPAL_ID \
  --secret-permissions get list
```

### 4. Configure Function App Settings

```bash
# For SQLite (development/testing)
az functionapp config appsettings set \
  --name $FUNCTION_APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --settings \
    CLOUD_PROVIDER=azure \
    USE_SQLITE=1 \
    USE_AZURE_KEYVAULT=0

# For MySQL with Azure Key Vault (production)
az functionapp config appsettings set \
  --name $FUNCTION_APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --settings \
    CLOUD_PROVIDER=azure \
    USE_SQLITE=0 \
    USE_AZURE_KEYVAULT=1 \
    AZURE_KEY_VAULT_NAME=$KEY_VAULT_NAME
```

### 5. Deploy Backend

```bash
cd BTE_APP_backend

# Deploy to Azure Functions
func azure functionapp publish $FUNCTION_APP_NAME

# Or using Azure CLI (zip deploy)
# First, create a deployment package
zip -r ../deploy.zip . -x "*.git*" "*.venv*" "*__pycache__*" "*.pytest_cache*"

az functionapp deployment source config-zip \
  --resource-group $RESOURCE_GROUP \
  --name $FUNCTION_APP_NAME \
  --src ../deploy.zip
```

### 6. Test Backend

```bash
# Get Function App URL
BACKEND_URL=$(az functionapp show \
  --name $FUNCTION_APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --query defaultHostName -o tsv)

# Test root endpoint
curl https://$BACKEND_URL/api

# Test behaviors endpoint
curl https://$BACKEND_URL/api/behaviors
```

## Frontend Deployment (Azure Static Web Apps)

### 1. Create Static Web App

```bash
STATIC_WEB_APP_NAME="bte-app-frontend"

az staticwebapp create \
  --name $STATIC_WEB_APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION
```

### 2. Configure Environment Variables

```bash
# Set the API URL to point to your Azure Function
az staticwebapp appsettings set \
  --name $STATIC_WEB_APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --setting-names NEXT_PUBLIC_API_URL=https://$BACKEND_URL/api
```

### 3. Deploy Frontend

```bash
cd BTE_APP_frontend

# Build the Next.js app
npm install
npm run build

# Get deployment token
DEPLOYMENT_TOKEN=$(az staticwebapp secrets list \
  --name $STATIC_WEB_APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --query properties.apiKey -o tsv)

# Deploy using SWA CLI
npx @azure/static-web-apps-cli deploy \
  --deployment-token $DEPLOYMENT_TOKEN \
  --app-location "." \
  --output-location "out"

# Alternative: Set up GitHub Actions for CI/CD
# Azure Static Web Apps can automatically deploy from GitHub
```

### 4. Get Frontend URL

```bash
az staticwebapp show \
  --name $STATIC_WEB_APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --query defaultHostname -o tsv
```

## Local Testing with Azure Configuration

### Backend

```bash
cd BTE_APP_backend

# Edit local.settings.json with your configuration
# Then start the function locally
func start
```

### Frontend

```bash
cd BTE_APP_frontend

# Create .env.local with Azure backend URL
echo "NEXT_PUBLIC_API_URL=http://localhost:7071/api" > .env.local

# Or point to deployed Azure Function
echo "NEXT_PUBLIC_API_URL=https://$BACKEND_URL/api" > .env.local

npm run dev
```

## Monitoring and Logs

### View Function Logs

```bash
# Stream logs
func azure functionapp logstream $FUNCTION_APP_NAME

# Or using Azure CLI
az webapp log tail \
  --name $FUNCTION_APP_NAME \
  --resource-group $RESOURCE_GROUP
```

### View Application Insights

```bash
# Get Application Insights key
az monitor app-insights component show \
  --app $FUNCTION_APP_NAME \
  --resource-group $RESOURCE_GROUP
```

## Environment Variables Summary

### Backend (Azure Functions)

| Variable | Value | Description |
|----------|-------|-------------|
| CLOUD_PROVIDER | azure | Identifies cloud platform |
| USE_SQLITE | 0 or 1 | Use SQLite (1) or MySQL (0) |
| USE_AZURE_KEYVAULT | 0 or 1 | Use Azure Key Vault for secrets |
| AZURE_KEY_VAULT_NAME | your-vault-name | Key Vault name (if using) |
| DB_USERNAME | username | Direct DB credentials (if not using Key Vault) |
| DB_PASSWORD | password | Direct DB credentials (if not using Key Vault) |
| DB_HOST | hostname | Database host |
| DB_PORT | 3306 | Database port |
| DB_NAME | dbname | Database name |

### Frontend (Static Web App)

| Variable | Value | Description |
|----------|-------|-------------|
| NEXT_PUBLIC_API_URL | https://your-function-app.azurewebsites.net/api | Backend API URL |

## Troubleshooting

### Function App Not Starting

Check logs:
```bash
az webapp log tail --name $FUNCTION_APP_NAME --resource-group $RESOURCE_GROUP
```

### Database Connection Issues

Verify Key Vault access:
```bash
az keyvault secret show --vault-name $KEY_VAULT_NAME --name db-username
```

### CORS Issues

Update CORS in main.py to include your Static Web App domain.

## Cost Management

- Function App: Pay-per-execution (Consumption plan)
- Static Web App: Free tier available
- Key Vault: Low cost for secret storage
- Azure Database for MySQL: Variable based on size

## Cleanup

To delete all resources:

```bash
az group delete --name $RESOURCE_GROUP --yes --no-wait
```
