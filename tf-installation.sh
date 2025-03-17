#!/bin/bash

echo "🛠️  Starting Terraform installation..."

# Update system and install prerequisites
echo "🔄 Updating packages and installing prerequisites..."
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common wget curl

# Add the HashiCorp GPG key
echo "🔑 Adding HashiCorp GPG key..."
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor > hashicorp-archive-keyring.gpg
sudo install -o root -g root -m 644 hashicorp-archive-keyring.gpg /usr/share/keyrings/
rm hashicorp-archive-keyring.gpg

# Add the HashiCorp repository
echo "➕ Adding HashiCorp APT repository..."
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

# Update packages and install Terraform
echo "📦 Installing Terraform..."
sudo apt-get update
sudo apt-get install -y terraform

# Verify Terraform installation
echo "✅ Verifying Terraform installation..."
terraform -v

echo "🎉 Terraform installation completed successfully!"