# ProjectIAC

ProjectIAC is an Infrastructure as Code (IaC) project that automates the process of setting up and deploying infrastructure in Azure using Terraform and GitHub Actions.

## Files in the Project

### mainTerra.tf

This is a Terraform configuration file located in the `InfrastructureAsCode` directory. It describes the resources that need to be created in Azure. This could include resources like virtual machines, databases, networking components, and more. Terraform uses this file to create, update, and delete resources in a way that matches the desired state described in the file.

### deployTerra.yml

This is a GitHub Actions workflow file located in the `.github/workflows` directory. It defines a set of actions that should be performed when certain events occur in the GitHub repository. In this case, the workflow is designed to deploy your infrastructure in Azure using Terraform. The workflow is triggered manually (`workflow_dispatch`), and it includes steps to log into Azure, set up Terraform, initialize Terraform, create a Terraform plan, and apply the Terraform plan.

### devcontainer.json

This is a configuration file for Visual Studio Code's Dev Containers, located in the `.devcontainer` directory. It specifies the Docker image to use for the development environment and any extensions that should be installed in the environment. In this case, it's set up to use the universal image from Microsoft and install the GitHub Copilot and GitHub Actions extensions.

## Prerequisites

- Azure account
- GitHub account
- Terraform installed
- Visual Studio Code with Dev Containers extension installed

## Usage

1. Clone the repository.
2. Open the project in Visual Studio Code.
3. Rebuild the Dev Container to ensure all extensions are installed.
4. Update the `mainTerra.tf` file with your desired infrastructure.
5. Run the GitHub Actions workflow to deploy your infrastructure.

## Contributing

Contributions are welcome. Please open an issue or submit a pull request.