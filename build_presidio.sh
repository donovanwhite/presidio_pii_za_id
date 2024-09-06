
# Login into the Azure Container Registry
az acr login --name <your-acr-name>


# Build the Docker image
docker build --no-cache -t predisio_pii:<version> .
docker tag predisio_pii:<version> <your-acr-name>.azurecr.io/predisio_pii:<version>
docker push <your-acr-name>.azurecr.io/predisio_pii:<version>


#create a resource group and an app service plan
az group create --name <your-resource-group> --location <your-location>
az appservice plan create --name <your-app-service-plan> --resource-group <your-resource-group> --sku P2V2 --is-linux


#create an identity
az identity create --name <your-identity-name> --resource-group <your-resource-group>

#grant principal privileges to the ACR
principalId=$(az identity show --resource-group <your-resource-group> --name <your-identity-name> --query principalId --output tsv)
registryId=$(az acr show --resource-group <your-acr-resource-group> --name <your-acr-name> --query id --output tsv)
az role assignment create --assignee $principalId --scope $registryId --role "AcrPull"


#deploy the web app
az webapp create --resource-group <your-resource-group> --plan <your-app-service-plan> --name <your-web-app-name> --deployment-container-image-name <your-acr-name>.azurecr.io/predisio_pii:<version>

#update the web app with the new image version if required after any changes made
az webapp config container set --resource-group <your-resource-group> --name <your-web-app-name> --container-image-name <your-acr-name>.azurecr.io/predisio_pii:<version>


#test the web app
curl -X POST https://<your-web-app-name>.azurewebsites.net/analyze -H "Content-Type: application/json" -d '{}'
