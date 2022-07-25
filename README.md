# Infrastructure deployment to Azure using DevOps tools

## Infraestructure to deploy

![image-20220725134042568](https://i.postimg.cc/pT7Kbbwr/imagen.png)

## What is used

*Main tools*

| Tool/Service | Use                                                          |      Version       |
| :----------: | ------------------------------------------------------------ | :----------------: |
|    Azure     | As a cloud provider where we are going to deploy infraestructure | azure-cli (latest) |
|  Terraform   | IaC tool to make the deploy to Azure                         |       latest       |
|   Ansible    | Automating configuration and application deployment in VMs   |        2.9         |
|  Kubernetes  | Orchestration software for deploying, managing, and scaling containers |       latest       |

*Kubernetes Config*

|      Service       |              Managed by              |
| :----------------: | :----------------------------------: |
|      Runtime       |                CRI-O                 |
|   Network plugin   | CNI (Container Networking Interface) |
|        SDN         |            Calico (Canal)            |
|    SDN (Local)     |       Calico (Project tigera)        |
| Ingress Controller |           HAProxy Ingress            |



## Aplication deployed

|   Aplication   |       Website path       |                      PV mount                      | Kubernetes Namespace |
| :------------: | :----------------------: | :------------------------------------------------: | :------------------: |
| Simple Website | nos.by:<80:nodeport>/app | from NFS server `/mnt/nfs` -> to `/var/www/public` |       app-web        |

*Aplication's server deployed in Kubernetes containers*

| Image                                                        | SO        | Server |
| ------------------------------------------------------------ | --------- | ------ |
| [nos22/debian10-apache](https://hub.docker.com/r/nos22/debian10-apache) | Debian 10 | Apache |



## What to use as a local host

I recommend using a Linux system as a host but if you are using Windows, you can use the "unofficial" [CentOS Stream 8 WSL](https://github.com/mishamosher/CentOS-WSL) or any other Linux WSL distro and adapt the process when needed. 



## How to deploy

1. Installing tools

	> If you are using other versions of Linux you will have to adapt the process to your system

	**Azure Cli**

	```shell
	# Microsoft keys repository
	sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
	# Check updates
	sudo dnf update
	# Add repo needed for RHEL8 & CentOs Stream 8
	sudo dnf install https://packages.microsoft.com/config/rhel/8/packages-microsoft-prod.rpm -y 
	# Installing Azure
	sudo dnf install azure-cli -y 
	```

	**Terraform**

	```sh
	# Install yum utils
	sudo yum install yum-utils -y
	# Add Hashicorp Repository
	sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
	# Install Terraform
	sudo yum install terraform -y
	```

	**Ansible**

	```sh
	# Install Ansible via pip at version 2.9.27
	python3 -m pip install ansible==2.9.27
	```

	

2. Generating SSH local pair

	It is necessary to generate them now because when creating the VMs with Terraform we must indicate the public key from which the connections can be made. And above all so that, later, Ansible can make the connections to the deployed VMs and make the relevant configurations.

	```sh
	ssh-keygen -m PEM -t rsa -b 4096 # SSH pair with RSA encryption and 4096 bit length
	```

	

3. Get Image to be deployed in VMs

	We will use **CentOS Stream 8 image**

	```shell
	# Download image
	az vm image list -f centos-8-stream-free -p cognosys --all --output table 
	# Visualice Terms of Use
	az vm image terms show --urn cognosys:centos-8-stream-free:centos-8-stream-free:22.03.28 
	# Accept Terms of Use
	az vm image terms accept --urn cognosys:centos-8-stream-free:centos-8-stream-free:22.03.28  
	```

	

4. Connect Terraform to Azure Cli

	```shell
	# Logging Azure from local host
	az login 
	
	# See subscription used in account
	az account list 
	```

	

5. Infraestructure deploy with Terraform

	> Be sure you are in `/terraform` before running commands

	```shell
	# Initialice the deployment
	terraform init
	# You can run a plan just to make sure there is no problem in code
	terraform plan
	# Execute the deployment to Azure
	terraform apply
	# In case you need to destroy it
	terraform destroy
	```

6. Set automate configuration using Ansible

	> Be sure you are in `/ansible` before running commands

	- Automation of inventory file "hosts" is not set yet, so you need to manually indicate IPs for manage nodes every time you do a new deploy to Azure (as IPs are set dynamically)

		```shell
		# To see public IP and private IP set by Azure 
		terraform output vm_private_ip
		terraform output vm_public_ip
		```

	- Now change those in `/ansible/hosts` `ini` file to get it like this:

		```ini
		[master]
		20.254.91.164 domain_name=kubmaster private_ip=10.0.2.22
		
		[workers]
		51.142.101.112 domain_name=kubworker private_ip=10.0.2.23
		
		[nfs]
		51.142.102.135 domain_name=nfsserver private_ip=10.0.2.30
		```

	- Its the time to run Ansible

		```yaml
		# playbook.yml runs every step in order
		ansible-playbook -i hosts playbook.yml
		```

7. Now you can access your deployed VMs via SSH

	```shell
	ssh azureadmin@{private_ip}
	```

	And see if Kubernetes is working correctly

	```shell
	kubectl get nodes
	kubectl get pods -A
	```

	There is also a website application deployed in namespace **app-work** that you can check using:

	```shell
	# To get Nodeport associate to port 80 in the Ingress Controller
	kubectl get svc -A 
	# Check via curl (private ip and nodeport needed)
	curl -I -H 'Host: nos.by' 'http://<master_private_ip>:<80:nodeport>/app'
	# Check via web browser (nodeport needed)
	nos.by:<80:nodeport>/app
	```

	



## Annotations

- Make sure that variables like "Azure location" are set as your preference before running Terraform.
- Timezone change in `/ansible/roles/common/vars/main.yml` is set to "Europe/Madrid", change it to your desire before running Ansible.
- You can also deploy this project locally. To do that be sure that you change hosts in `/ansible/hosts` and care that in `/ansible/roles/master/tasks/main.yml` you need to change the task 'SDN' to `sdn-local.yml`

