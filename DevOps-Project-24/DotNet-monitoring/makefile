# Used by `image`, `push` & `deploy` targets, override as required
IMAGE_REG ?= docker.io
IMAGE_REPO ?= writetoritika/dotnet-monitoring
IMAGE_TAG ?= latest

# Used by `deploy` target, sets Azure webap defaults, override as required
AZURE_RES_GROUP ?= demoapps
AZURE_REGION ?= northeurope
AZURE_APP_NAME ?= dotnet-demoapp

# Used by `test-api` target
TEST_HOST ?= localhost:5000

# Don't change
SRC_DIR := src
TEST_DIR := tests

.PHONY: help lint lint-fix image push run deploy undeploy test test-report test-api clean .EXPORT_ALL_VARIABLES
.DEFAULT_GOAL := help

help: ## 💬 This help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

lint: ## 🔎 Lint & format, will not fix but sets exit code on error 
	@dotnet format --help > /dev/null 2> /dev/null || dotnet tool install --global dotnet-format
	dotnet format --verbosity diag ./src

image: ## 🔨 Build container image from Dockerfile 
	docker build . --file build/Dockerfile \
	--tag $(IMAGE_REG)/$(IMAGE_REPO):$(IMAGE_TAG)

push: ## 📤 Push container image to registry 
	docker push $(IMAGE_REG)/$(IMAGE_REPO):$(IMAGE_TAG)

run: ## 🏃‍ Run locally using Dotnet CLI
	dotnet watch --project $(SRC_DIR)/dotnet-demoapp.csproj

deploy: ## 🚀 Deploy to Azure Container App 
	az group create --resource-group $(AZURE_RES_GROUP) --location $(AZURE_REGION) -o table
	az deployment group create --template-file deploy/container-app.bicep \
		--resource-group $(AZURE_RES_GROUP) \
		--parameters appName=$(AZURE_APP_NAME) \
		--parameters image=$(IMAGE_REG)/$(IMAGE_REPO):$(IMAGE_TAG) -o table
	@sleep 1
	@echo "### 🚀 App deployed & available here: $(shell az deployment group show --resource-group $(AZURE_RES_GROUP) --name container-app --query "properties.outputs.appURL.value" -o tsv)/"

undeploy: ## 💀 Remove from Azure 
	@echo "### WARNING! Going to delete $(AZURE_RES_GROUP) 😲"
	az group delete -n $(AZURE_RES_GROUP) -o table --no-wait

test: ## 🎯 Unit tests with xUnit
	dotnet test tests/tests.csproj 

test-report: ## 🤡 Unit tests with xUnit & output report
	rm -rf $(TEST_DIR)/TestResults
	dotnet test $(TEST_DIR)/tests.csproj --test-adapter-path:. --logger:junit --logger:html

test-api: .EXPORT_ALL_VARIABLES ##🚦 Run integration API tests, server must be running!
	cd tests \
	&& npm install newman \
	&& ./node_modules/.bin/newman run ./postman_collection.json --env-var apphost=$(TEST_HOST)

clean: ## 🧹 Clean up project
	rm -rf $(TEST_DIR)/node_modules
	rm -rf $(TEST_DIR)/package*
	rm -rf $(TEST_DIR)/TestResults
	rm -rf $(TEST_DIR)/bin
	rm -rf $(TEST_DIR)/obj
	rm -rf $(SRC_DIR)/bin
	rm -rf $(SRC_DIR)/obj
