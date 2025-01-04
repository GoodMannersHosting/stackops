# Cleanup commands

I don't have a great place to put these in the main readme, so I'll slap some commands in here.

## Ceph Nuke

If you've really screwed up, you can run the following commands on each of your hosts to completely nuke ceph and re-start the install/bootstrapping process

```bash
rm -rf /etc/systemd/system/ceph*
killall -9 ceph-mon ceph-mgr ceph-mds
rm -rf /var/lib/ceph/mon/  /var/lib/ceph/mgr/  /var/lib/ceph/mds/
apt -y purge ceph-mon ceph-osd ceph-mgr ceph-mds
rm /etc/init.d/ceph
apt reinstall $(apt search ceph | grep installed | awk -F/ '{print $1}' | xargs);
dpkg-reconfigure ceph-base
dpkg-reconfigure ceph-mds
dpkg-reconfigure ceph-common
dpkg-reconfigure ceph-fuse
apt reinstall $(apt search ceph | grep installed | awk -F/ '{print $1}' | xargs);

# Clean Podman containers
podman stop `podman ps -aq`
podman rm `podman ps -aq`

# Remove Ceph LVM devices
for disk in $(lsblk | grep  ceph | cut -c7- | awk '{print $1}'); do
    dmsetup remove ${disk}
done

# Remove Ceph directory contents
rm -rf /etc/ceph/*
rm -rf /var/lib/ceph/*
```
