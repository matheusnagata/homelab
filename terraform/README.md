# Terraform

---

## ⚠️ IMPORTANT NOTICE: Lab Use Only ⚠️

**This repository and the configurations described within are intended for personal homelab, learning, and experimentation purposes ONLY. This setup is NOT designed, configured, or secured for production environments. Using these configurations in a production setting is strongly discouraged and is done at your own risk.**

---

## 🚀 Overview

This folder contains all Terraform configurations and setup guides I'm experimenting with.

---

## 🔗 Reference Links:
https://registry.terraform.io/providers/elsudano/vmworkstation/latest/docs
https://github.com/elsudano/terraform-provider-vmworkstation

---

## 🛠️ Setup Guide

### 1. Configure VMware Workstation REST API:
```powershell
cd "C:\Program Files (x86)\VMware\VMware Workstation"
vmrest.exe --config
```
### 2. Start VMware Workstation REST API
```powershell
cd "C:\Program Files (x86)\VMware\VMware Workstation"
vmrest.exe
```
### 3. Test the API (Optional but Recommended): Open a web browser and go to `http://localhost:8697` (or `https` if you've configured SSL, which is more complex to set up initially).

### 4. Open your Command Prompt/Terminal and navigate to your `my_vmws_terraform` directory:
```powershell	
cd C:\Users\Username\Terraform\my_vmws_terraform
```
### 5. Initialize Terraform:
```powershell	
terraform init
```
### 6. Plan Your Infrastructure Changes:
```powershell		
terraform plan
```
### 7. Apply the Infrastructure Changes:
```powershell		
terraform apply
```

## 🚧 Under Construction 🚧

**Please note that this `README.md` document is still under active development and may be updated frequently.**