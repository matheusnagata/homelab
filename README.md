# 🏡 My Homelab

---

## ⚠️ IMPORTANT NOTICE: Lab Use Only ⚠️

**This repository and the configurations described within are intended for personal homelab, learning, and experimentation purposes ONLY. This setup is NOT designed, configured, or secured for production environments. Using these configurations in a production setting is strongly discouraged and is done at your own risk.**

---

## 🚀 Overview

Welcome to my personal homelab repository! This project details the setup and configuration of a VMware Workstation-based homelab environment to help those wanting to learn Kubernetes, SUSE Rancher, Longhorn and Terraform. I built this lab on OpenSUSE, with RKE2, SUSE Rancher, and leveraging Longhorn for highly available persistent storage.

This repository serves as a living document of my homelab, including infrastructure setup, Kubernetes configurations, Rancher management, and application deployments.

---

## ✨ Key Components

* **Operating System:** OpenSUSE Leap 15.6
* **Virtualization:** VMware Workstation (for the VMs running the nodes)
* **Kubernetes Distribution:** [RKE2 (Rancher Kubernetes Engine 2)](https://docs.rke2.io/)
    * A lightweight, secure, and fully conformant Kubernetes distribution from Rancher.
* **Kubernetes Management:** [Rancher](https://rancher.com/)
    * A centralized management platform for multi-cluster Kubernetes deployments, providing a powerful UI and integrated tools.
* **Persistent Storage:** [Longhorn](https://longhorn.io/)
    * A cloud-native distributed block storage system for Kubernetes, providing highly available and resilient storage for stateful applications.

---

## 🌐 Network & Homelab Topology

My homelab consists mainly of 5 virtual machines, each running OpenSUSE Leap 15.6. Three of these nodes (VMs) are configured as a unified RKE2 cluster, serving both control plane and worker roles.

* `OpenSUSE-Leap-15.6` (Template VM)
* `lab-gateway` (VM created to allow a "carry-on" lab no matter the network you may be connected to, leveraging the use of virtual networks in VMware Workstation.)
* `lab-rancher01` (Control Plane + Worker)
* `lab-rancher02` (Worker)
* `lab-rancher03` (Worker)

---

## 🛠️ Setup Guide

This section outlines the steps to replicate the homelab's setup.

### 1. VMware Workstation Base Network Setup

Using the Virtual Network Editor in VMware Workstation (Edit > Virtual Network Editor), remember to enable "Change Settings" in the bottom-right corner so you can edit. Create a new network to use as the base for your "carry-on" Home Lab for example: 

* **Network:** Lab-VMnet (VMnet5)
* **VMnet Type:** Host-only
* **Make sure the following are enabled:** 
    * Connect a host virtual adapter to this network
    * Use local DHCP service to distribute IP address to VMs
* **Subnet IP:** `172.16.2.0`
* **Subnet Mask:** `255.255.255.0` (or `/24`)
* **DHCP Settings:**
    * Starting IP address: `172.16.2.11`
    * Ending IP address: `172.16.2.254`
    * Broadcast Address: `172.16.2.255`
* **Usable IP Address Range:** `172.16.2.1` to `172.16.2.254`

Make sure you have a NAT Type network created as well (this is normally created by default in VMware Workstation) you will need this to setup the VM that will serve as a gateway for the other VMs in the lab.

### 2. Create the Template VM:

For this lab we I'll be using the following configurations:
* **OS:** OpenSUSE Leap 15.6
* **CPU:** 2vCPUs
* **RAM:** 4GB
* **Disk:** 20GB
* **Network Adapter:** NAT

After installing the OS, make sure to update the OS and reboot if needed to apply updates:
```bash
# Refresh repositories:
sudo zypper refresh
# Check for and apply updates:
sudo zypper update
# To restart:
init 6
# To shutdown:
init 0
``` 

After everything is updated and ready, shutdown the VM so we can start using this VM as a template for the other VMs we will create.

**Optional:** In VMware Workstation to use the template feature you must have a snapshot created. So go ahead and create a snapshot in case you need to revert any changes in the future. After the snapshot is created, to enable mark the VM as a template, right-click the VM > Settings... > Option (tab) > Advanced > Toggle the "Enable Template mode (to be used for cloning)" > Click on OK button to save the settings.

### 3. Creating the Gateway/DNS Server VM:



## 🚧 Under Construction 🚧

**Please note that this `README.md` document is still under active development and may be updated frequently.**
