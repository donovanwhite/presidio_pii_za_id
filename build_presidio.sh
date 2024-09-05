
# Login into the Azure Container Registry
az acr login --name ""

# Build the Docker image
docker build --no-cache -t predisio_pii .
docker tag predisio_pii [].azurecr.io/predisio_pii
docker push [].azurecr.io/predisio_pii

#create a resource group and an app service plan
az group create --name presidio-rg --location southafricanorth
az appservice plan create --name piiAppService --resource-group presidio-rg --sku P2V2 --is-linux

#create an identity
az identity create --name presidioId --resource-group presidio-rg

#grant principal privileges to the ACR
principalId=$(az identity show --resource-group presidio-rg --name presidioId --query principalId --output tsv)
registryId=$(az acr show --resource-group synapse-ws-rg --name acrdevzan1 --query id --output tsv)
az role assignment create --assignee $principalId --scope $registryId --role "AcrPull"

#deploy the web app
az webapp create --resource-group presidio-rg --plan piiAppService --name presidioPII --deployment-container-image-name [].azurecr.io/predisio_pii

#update the web app with the new image version
az webapp config container set --resource-group presidio-rg --name presidioPII --container-image-name [].azurecr.io/predisio_pii

#test the web app
curl -X POST https://presidiopii.azurewebsites.net/analyze -H "Content-Type: application/json" -d '{"text": ""}'
curl -X POST https://presidiopii.azurewebsites.net/analyze -H "Content-Type: application/json" -d '{"text": ""}'
