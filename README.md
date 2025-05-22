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
* `lab-gateway` (VM created to allow me to have a "carry-on" lab no matter the network I'm connected to on my laptop, leveraging the use of virtual networks in VMware Workstation.)
* `lab-rancher01` (Control Plane + Worker)
* `lab-rancher02` (Worker)
* `lab-rancher03` (Worker)

---

## 🛠️ Setup Guide

This section outlines the high-level steps to replicate or understand the homelab's initial setup.

### 1. Virtual Machine Provisioning

* **Create Template VM:** Provision a VM in VMware Workstation.
    * **OS:** OpenSUSE Leap 15.6
    * **Resources:** (Example, adjust as needed)
        * CPU: 2 vCPUs
        * RAM: 4GB
        * Disk: 50GB

## 🚧 Under Construction 🚧

**Please note that this `README.md` document is still under active development and may be updated frequently.**
