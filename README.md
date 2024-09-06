# presidio_pii_za_id
This repository contains the code artifacts developed for the Presidio project. The project focuses on enhancing data privacy and protection by leveraging advanced techniques in data anonymization and de-identification. Key features include:

Docker Build: A custom Docker build to deploy the API.
Custom API: An API designed to identify and anonymize credit card and South African ID numbers.
Custom Class for ZA ID Numbers: A specialized class to increase the accuracy of anonymizing South African ID numbers.
Azure SQL Database Integration: Utilizes an Azure SQL database with an INSERT trigger that invokes a REST endpoint to anonymize data before insertion.

The deployment process includes building a Docker image, pushing it to Azure Container Registry (ACR), and deploying it to Azure App Service. Below are the key steps involved:

1. Azure Container Registry (ACR) Setup
Login to ACR: Authenticate to the Azure Container Registry using the az acr login command.
Build and Push Docker Image: Build the Docker image with the application, tag it, and push it to ACR.
2. Azure Resource Setup
Create Resource Group and App Service Plan: Use the az group create and az appservice plan create commands to set up the necessary Azure resources.
Create Managed Identity: Create a managed identity to handle permissions for pulling images from ACR.
3. Permissions and Role Assignments
Grant ACR Pull Permissions: Assign the “AcrPull” role to the managed identity to allow it to pull images from ACR.
4. Deploy Web Application
Create Web App: Deploy the web application using the az webapp create command, specifying the Docker image from ACR.
Update Web App Configuration: Update the web app configuration to use the latest Docker image version.
5. Testing the Deployment
Test Endpoints: Use curl commands to test the web application’s endpoints and ensure it correctly detects and anonymizes PII.
