# Kolla Ansible

- [Kolla Ansible's Documentation](https://docs.openstack.org/kolla-ansible/2024.1/index.html)
- [Quickstart Guide](https://docs.openstack.org/kolla-ansible/2024.1/user/quickstart.html)

## Commands to run

```bash
sudo apt install git python3-dev libffi-dev gcc libssl-dev
sudo apt install python3-venv

python3 -m venv /opt/kolla-venv
source /opt/kolla-venv/bin/activate

pip install -U pip
pip install 'ansible-core>=2.15,<2.16.99'
pip install git+https://opendev.org/openstack/kolla-ansible@stable/2024.2

sudo mkdir -p /etc/kolla
sudo chown ${USER}:${USER} /etc/kolla

wget -O /etc/kolla/globals.yml https://raw.githubusercontent.com/GoodMannersHosting/stackops/main/kolla/globals.yml
wget -O /etc/kolla/multinode   https://raw.githubusercontent.com/GoodMannersHosting/stackops/main/kolla/multinode

kolla-ansible install-deps
kolla-genpwd

# Preparation
kolla-ansible -i ./multinode bootstrap-servers
kolla-ansible -i ./multinode prechecks

# Installation
kolla-ansible -i ./multinode deploy
```
