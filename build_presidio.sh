# Login to ACR
az acr login --name <your-acr-name>

# Build and Push Docker Image
docker build --no-cache -t predisio_pii:<version> .
docker tag predisio_pii:<version> <your-acr-name>.azurecr.io/predisio_pii:<version>
docker push <your-acr-name>.azurecr.io/predisio_pii:<version>

# Create Resource Group and App Service Plan
az group create --name <your-resource-group> --location <your-location>
az appservice plan create --name <your-app-service-plan> --resource-group <your-resource-group> --sku P2V2 --is-linux

# Create Managed Identity
az identity create --name <your-identity-name> --resource-group <your-resource-group>

# Grant ACR Pull Permissions
principalId=$(az identity show --resource-group <your-resource-group> --name <your-identity-name> --query principalId --output tsv)
registryId=$(az acr show --resource-group <your-acr-resource-group> --name <your-acr-name> --query id --output tsv)
az role assignment create --assignee $principalId --scope $registryId --role "AcrPull"

# Create SQL Server and Database
az sql server create --name <your-sql-server-name> --resource-group <your-resource-group> --location <your-location> --admin-user <your-admin-user> --admin-password <your-admin-password>
az sql db create --resource-group <your-resource-group> --server <your-sql-server-name> --name <your-database-name> --service-objective S0

# Configure Firewall Rules
az sql server firewall-rule create --resource-group <your-resource-group> --server <your-sql-server-name> --name AllowYourIP --start-ip-address <your-ip-address> --end-ip-address <your-ip-address>

# Deploy Web App
az webapp create --resource-group <your-resource-group> --plan <your-app-service-plan> --name <your-web-app-name> --deployment-container-image-name <your-acr-name>.azurecr.io/predisio_pii:<version>

# Update Web App Configuration
az webapp config container set --resource-group <your-resource-group> --name <your-web-app-name> --container-image-name <your-acr-name>.azurecr.io/predisio_pii:<version>

# Test Endpoints
curl -X POST https://<your-web-app-name>.azurewebsites.net/analyze -H "Content-Type: application/json" -d '{}'
