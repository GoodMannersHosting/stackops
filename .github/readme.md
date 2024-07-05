# OpenStack @ Home

First and foremost, I'd like to thank @coolguy1771 who made the entire deployment possible.

> [!CAUTION]
> This project and repo is an emormous WIP and is not complete!!

## Introduction

This repository contains the necessary prerequisites and steps to deploy an OpenStack environment in my (@danmanners) homelab. We chose to use Ubuntu MaaS for host provisioning and OpenStack Ansible-Kolla for the OpenStack deployment.

## Ceph Preperation

```bash
# Modify the sshd_config on all of the OpenStack hosts to enable root SSH
sudo vim /etc/ssh/sshd_config

# Uncomment the following line
#PermitRootLogin prohibit-password

# Next, make sure you run `sudo systemctl restart sshd` to apply the changes.
```

## Ceph Configuration

```bash
# Set the version of Ceph to install
CEPH_RELEASE=18.2.2

# Pull the cephadm binary and make it executable
curl --silent --remote-name \
--location https://download.ceph.com/rpm-${CEPH_RELEASE}/el9/noarch/cephadm
chmod +x cephadm

# Add the Ceph Reef repository and install the cephadm package
sudo ./cephadm add-repo --release reef
sudo ./cephadm install ceph

# Bootstrap the first ceph node where you are running these commands
sudo cephadm bootstrap --mon-ip 172.20.32.17 # Replace this IP with yours if different
```

Once cephadm is installed, grab the `/etc/ceph/ceph.conf` file from the first Ceph node. This will be used to configure the Ceph backend for OpenStack config files.

Additionally, you'll need to add the `/etc/ceph/ceph.pub` key to the `~/.ssh/authorized_keys` file on each of the OpenStack ceph nodes. This will allow the OpenStack nodes to communicate with the Ceph nodes.

> [!WARNING]
> If you don't do this, cephadm will not be able to communicate with the Ceph nodes and commands will fail.

```bash
# Add the second and third nodes
sudo ceph orch host add wise-oryx-1922 172.20.32.15 --labels _admin
sudo ceph orch host add wired-gnat-r1518 172.20.32.16 --labels _admin

# Add all of the OSDs to the ceph cluster
sudo ceph orch daemon add osd active-viper-r1314:/dev/nvme0n1,/dev/nvme1n1
sudo ceph orch daemon add osd wired-gnat-r1518:/dev/nvme0n1,/dev/nvme2n1
sudo ceph orch daemon add osd wise-oryx-1922:/dev/nvme0n1,/dev/nvme1n1,/dev/nvme2n1,/dev/nvme3n1

# Create the necessary pools for Ceph for OpenStack
sudo ceph osd pool create volumes
sudo ceph osd pool create images
sudo ceph osd pool create backups
sudo ceph osd pool create vms

# Create the necessary RBDs for Ceph for OpenStack
sudo rbd pool init volumes
sudo rbd pool init images
sudo rbd pool init backups
sudo rbd pool init vms

# Create the necessary Ceph users for OpenStack
## Glance
sudo ceph auth get-or-create client.glance \
mon 'profile rbd' \
osd 'profile rbd pool=images' \
mgr 'profile rbd pool=images'

## Cinder and Nova
sudo ceph auth get-or-create client.cinder \
mon 'profile rbd' \
osd 'profile rbd pool=volumes, profile rbd pool=vms, profile rbd-read-only pool=images' \
mgr 'profile rbd pool=volumes, profile rbd pool=vms'

## Cinder Backups
sudo ceph auth get-or-create client.cinder-backup \
mon 'profile rbd' \
osd 'profile rbd pool=backups' \
mgr 'profile rbd pool=backups'

# Finally, Tune the memory settings so ceph cannot consume all host memory
sudo ceph config set mgr mgr/cephadm/autotune_memory_target_ratio 0.25
sudo ceph config set osd osd_memory_target_autotune true
```

We'll need to copy/paste all of the above commands into the terminal of the first Ceph node. This will bootstrap the Ceph cluster and prepare it for the OpenStack deployment.

Once you can see the keys generated through the `auth get-or-create` commands, make sure you copy them to the appropriate configuration files in the OpenStack deployment.

```bash
/etc/kolla/config/
├── cinder
│   ├── ceph.conf
│   ├── cinder-backup
│   │   └── ceph.client.cinder-backup.keyring # This file should be cinder-backup creds
│   └── cinder-volume
│       └── ceph.client.cinder.keyring # This file should be cinder creds
├── glance
│   ├── ceph.client.glance.keyring # This file should be glance creds
│   └── ceph.conf
├── neutron
│   └── openvswitch_agent.ini
├── nova
│   ├── ceph.client.cinder.keyring # This file should be cinder creds
│   ├── ceph.client.nova.keyring # This file should be cinder creds
│   └── ceph.conf
└── octavia
    ├── client.cert-and-key.pem
    ├── client_ca.cert.pem
    ├── server_ca.cert.pem
    └── server_ca.key.pem
```

## OpenStack Bootstrapping

Please note: we're running all Ansible commands for OpenStack provisioning on an Ubuntu 24.04 MaaS host, but YMMV!

> [!NOTE]
> TODO: Add the `kolla-ansible` setup instructions on the MaaS host

```bash
# Run Pre-Checks
kolla-ansible -i ./multinode prechecks

# Bootstrap all of the servers
kolla-ansible -i ./multinode bootstrap-servers
```
