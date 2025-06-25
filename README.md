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

#### Install and Configure Bind

Using the Template VM created, generated a full clone with the configuration below:
* **VM Name:** Lab-Gateway
* **CPU:** 2vCPUs
* **RAM:** 4GB
* **Disk:** 20GB
* **Network Adapter:** NAT
* **Network Adapter 2:** Custom (Lab-VMnet)
**Observation:** In this VM 2 Network Adapters were added, one with the NAT already used in our template and a new one that will be the gateway for all other VMs in this lab.

After booting the VM configure the networks as follows: 

* **Network:** NAT
* **Device Name:** eth0
    * Configured with dhcp
    * Started automatically at boot
* **Network:** Lab-VMnet (VMnet5)
* **Device Name:** eth1
    * Configured with address 172.16.2.2/24 (gateway)
    * Started automatically when attached 

* **Hostname/DNS:**
    * **Static Hostname:** gateway
    * **Name Server 1:** 172.16.2.2
    * **Name Server 2:** 8.8.8.8
    * **Name Server 3:** 8.8.4.4
    * **Domain Search:** lab.local


After configuring the networks as above. Let's proceed with installing Bind:

```bash
sudo zypper install bind bind-utils
```

Bind files created:

```bash
# File: /etc/named.conf
# Lab Environment:

listen-on port 53 { 127.0.0.1; 172.16.2.2; }; 
listen-on-v6 port 53 { ::1; };
allow-query { localhost; 172.16.2.0/24; };

zone "lab.local" in {
        type master;
        file "db.lab.local";
};

zone "2.16.172.in-addr.arpa" in {
        type master;
        file "db.2.16.172.in-addr.arpa";
};
```

```bash
# File: /var/lib/named/db.2.16.172.in-addr.arpa

$TTL 604800  ; Records are valid for 1 week
@       IN      SOA     lab.local. root.lab.local. (
                2024112601  ; Serial
                604800      ; Refresh (1 week)
                86400       ; Retry (1 day)
                2419200     ; Expire (4 weeks)
                604800      ; Negative Cache TTL
);

                IN      NS      lab.local.

; PTR records for your lab machines
2       IN      PTR     gateway.lab.local.
11      IN      PTR     rancher01.lab.local.
12      IN      PTR     rancher02.lab.local.
13      IN      PTR     rancher03.lab.local.

```

```bash
# File: /var/lib/named/db.lab.local

$TTL 604800
@       IN      SOA     lab.local. root.lab.local. (
                                        2024112601      ; Serial
                                        604800          ; Refresh
                                        86400           ; Retry
                                        2419200         ; Expire
                                        604800          ; Negative Cache TTL
)
@       IN      NS      lab.local.
@       IN      A       172.16.2.2

gateway         IN      A       172.16.2.2
rancher01       IN      A       172.16.2.11
rancher02       IN      A       172.16.2.12
rancher03       IN      A       172.16.2.13

```

```bash
# Apply and Test Configuration

systemctl restart named
nslookup 172.16.2.2
ping gateway.lab.local

# Enable service to start on boot: 
yast # Navigate to: System > Services Manager > named (Start Mode > On Boot) > Save
```

#### Routing

Create a startup script service file:

```bash
vim /etc/systemd/system/startup_script.service
```

```bash
# /etc/systemd/system/startup_script.service

[Unit]
Description=Run my boot script

[Service]
Type=oneshot
ExecStart=/bin/sh -c "/etc/systemd/system/startup_script.sh"

[Install]
WantedBy=multi-user.target
```

Create a startup script file:

```bash
vim /etc/systemd/system/startup_script.sh
```

```bash
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -A FORWARD -i eth0 -o eth1 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT
```

Change file permissions:

```bash
chmod 777 /etc/systemd/system/startup_script.service
chmod 777 /etc/systemd/system/startup_script.sh
```

Start and enable new service on boot:

```bash
systemctl start startup_script.service
systemctl status startup_script.service
systemctl enable startup_script.service
```

#### Firewall

```bash
# Stop the firewall software:
sudo systemctl disable --now firewalld

# Get updates, install NFS and apply:
sudo zypper install -y nfs-client cryptsetup open-iscsi

# Enable iSCSI for Longhorn:
sudo systemctl enable --now iscsid.service

# Update the system:
sudo zypper update -y

# Clean-up:
sudo zypper clean --all
```

### 4. RKE2 and Rancher

#### Network Configurations for RKE2 and Rancher VMs:

Using the Template VM created, generate a full clone with 3 VMs with the configurations below:
* **VM Names:** 
    * **Lab-Rancher01:** Control Plane + Worker
    * **Lab-Rancher02:** Worker
    * **Lab-Rancher03:** Worker
* **CPU:** 4vCPUs
* **RAM:** 8GB
* **Disk:** 60GB
* **Network Adapter:** Custom (Lab-VMnet)
**Observation:** In all 3 VM we will change the network used for the Network Adapters to our internal network (Lab-VMnet) and increase the Disk from 20GB to 60GB (later on steps to expand the disk will be provided).

After booting the VMs configure the networks as follows: 

* **Network:** Lab-VMnet (VMnet5)
* **Device Name:** eth0
    * Configured with address: 
        * 172.16.2.11/24 (rancher01)
        * 172.16.2.12/24 (rancher02)
        * 172.16.2.13/24 (rancher03)
    * Started automatically at boot 

* **Hostname/DNS:**
    * **Static Hostname:** 
        * rancher01
        * rancher02
        * rancher03
    * **Name Server 1:** 172.16.2.2
    * **Name Server 2:** 8.8.8.8
    * **Name Server 3:** 8.8.4.4
    * **Domain Search:** lab.local

* **Routing:**
    * Default Route: Enabled
    * Gateway: 172.16.2.2
    * Device: eth0

#### Installing RKE2

##### Run on rancher01 (Server Install):

```bash
# Install RKE2 Server:
curl -sfL https://get.rke2.io | INSTALL_RKE2_TYPE=server sh -
# To install a specific version: curl -sfL https://get.rke2.io | INSTALL_RKE2_CHANNEL=v2.11 INSTALL_RKE2_TYPE=server sh -
export PATH=$PATH:/opt/rke2/bin

# Predefine the token by create config file directory:
mkdir -p /etc/rancher/rke2/ 
echo "token: HomeLabPasswordToken" > /etc/rancher/rke2/config.yaml

# Start and Enable RKE2 Service on reboots: 
systemctl enable --now rke2-server.service
```

```bash
# Validate RKE2 is Running:
systemctl status rke2-server
```

```bash
# Create a symbolic link for kubectl:
ln -s $(find /var/lib/rancher/rke2/data/ -name kubectl) /usr/local/bin/kubectl

# Persistently configure the current user's shell to find the RKE2 Kubernetes configuration and its kubectl executable:
echo "export KUBECONFIG=/etc/rancher/rke2/rke2.yaml PATH=$PATH:/usr/local/bin/:/var/lib/rancher/rke2/bin/" >> ~/.bashrc
source ~/.bashrc

# Check node status:
kubectl get node
```

##### Run on rancher02 and rancher03 (Agent Install):

```bash
# Export the rancher01 IP:
export RANCHER1_IP=172.16.2.11   # change acording to your environment

# Install RKE2 (agent type):
curl -sfL https://get.rke2.io | INSTALL_RKE2_TYPE=agent sh -  
export PATH=$PATH:/opt/rke2/bin

# Create config file directory:
mkdir -p /etc/rancher/rke2/ 

# Change the IP address to your rancher01:
cat << EOF >> /etc/rancher/rke2/config.yaml
server: https://$RANCHER1_IP:9345
token: HomeLabPasswordToken
EOF

# Start and Enable RKE2 Service on reboots: 
systemctl enable --now rke2-agent.service
```

```bash
# Check nodes on rancher01, they must all be on "Ready" state:
watch kubectl get nodes
```

#### Installing Rancher

##### Run on rancher01:

```bash
# Add helm:
curl -#L https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Add helm charts:
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest --force-update
helm repo add jetstack https://charts.jetstack.io --force-update

# Validate added helm charts:
helm repo list

# To get a complete list of possible options in a values file, run:
helm inspect values rancher-prime/rancher > values.yaml
```

```bash
# Rancher needs jetstack/cert-manager to create the self signed TLS certificates. Install jetstack via helm:
helm upgrade -i cert-manager jetstack/cert-manager -n cert-manager --create-namespace --set crds.enabled=true

# Install Rancher via helm:
# Change the IP address to your rancher01:
export RANCHER1_IP=172.16.2.11
helm upgrade -i rancher rancher-latest/rancher --create-namespace --namespace cattle-system --set hostname=rancher.$RANCHER1_IP.sslip.io --set bootstrapPassword=bootStrapAllTheThings --set replicas=1

# This is a way to provide a status on the Rancher Deployment:
kubectl -n cattle-system rollout status deploy/rancher

# Validate installs:
helm list -A
kubectl get pod -A

# Get Bootstrap password:
kubectl get secret --namespace cattle-system bootstrap-secret -o go-template='{{.data.bootstrapPassword|base64decode}}{{ "\n" }}'
```

```bash
# In case of errors to check logs:
kubectl logs -n POD_NAME

# Useful commands:
kubectl get ingress -A # List all ingress resources across all namespaces.
watch kubectl get pods -n cattle-system # Continuously displays the status of all pods within the cattle-system namespace.
```

## 🚧 Under Construction 🚧

**Please note that this `README.md` document is still under active development and may be updated frequently.**
