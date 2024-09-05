
# Login into the Azure Container Registry
az acr login --name acrdevzan1

# Build the Docker image
docker build --no-cache -t predisio_pii:v1.1.22 .
docker tag predisio_pii:v1.1.22 acrdevzan1.azurecr.io/predisio_pii:v1.1.22
docker push acrdevzan1.azurecr.io/predisio_pii:v1.1.22

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
az webapp create --resource-group presidio-rg --plan piiAppService --name presidioPII --deployment-container-image-name acrdevzan1.azurecr.io/predisio_pii:v1.1.22

#update the web app with the new image version
az webapp config container set --resource-group presidio-rg --name presidioPII --container-image-name acrdevzan1.azurecr.io/predisio_pii:v1.1.22

#test the web app
curl -X POST https://presidiopii.azurewebsites.net/analyze -H "Content-Type: application/json" -d '{"text": "On the 16 April 2005 Standard bank and the Shinglane family, ID nrs  9401182516089, 8304255068060 and 6302085006082 entered into a vehicle finance agreement for a 2001 Volkswagen Polo GP 1.1 Comfortline. The deal was concluded through Shengen Cars dealership in Boksburg. The 5195237431854142 vehicle ownership history report obtained shows that Standard bank and the customer were never registered as title holder and owner by the dealership. ABSA is registered as the owner. Standard bank did not receive the Natis document for this deal. IECM number 2001-145625750 refers."}'
curl -X POST https://presidiopii.azurewebsites.net/analyze -H "Content-Type: application/json" -d '{"text": "John Doe ID is 8206305215084 and card num is 5244860023437181"}'
