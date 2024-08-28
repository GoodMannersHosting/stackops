#!/bin/bash
openstack flavor create g.tiny \
    --id g.tiny \
    --ram 1024 \
    --disk 10 \
    --vcpus 1

openstack flavor create g.small \
    --id g.small \
    --ram 2048 \
    --disk 10 \
    --vcpus 1

openstack flavor create g.medium \
    --id g.medium \
    --ram 4096 \
    --disk 20 \
    --vcpus 2

openstack flavor create g.large \
    --id g.large \
    --ram 8192 \
    --disk 32 \
    --vcpus 2

openstack flavor create g.xlarge \
    --id g.2large \
    --ram 16384 \
    --disk 60 \
    --vcpus 4

openstack flavor create c.large \
    --id c.large \
    --ram 8192 \
    --disk 32 \
    --vcpus 4

openstack flavor create c.xlarge \
    --id c.2large \
    --ram 16384 \
    --disk 60 \
    --vcpus 8

openstack flavor create m.large \
    --id m.large \
    --ram 20480 \
    --disk 32 \
    --vcpus 4

openstack flavor create m.xlarge \
    --id m.2large \
    --ram 32768 \
    --disk 60 \
    --vcpus 8
