sudo podman network create \
    -d=macvlan \
    --ipam-driver=none \
    -o=parent=enp2s0 \
    hostnet

sudo /usr/bin/podman run \
    --name matchbox --rm -d \
    --cap-add NET_BIND_SERVICE \
    --env TZ=America/New_York \
    --net hostnet \
    --ip 172.20.0.2 \
    --volume /opt/matchbox20:/var/lib/matchbox:Z \
    --port 80:80 \
    quay.io/poseidon/matchbox:v0.11.0@sha256:06bcdae85335fd00e8277b007b55cfb49d96a0114628c0f70db2b92b079d246a \
    -address=0.0.0.0:80 \
    -log-level=debug

sudo /usr/bin/podman run \
    --name matchbox --rm \
    --cap-add NET_BIND_SERVICE \
    --env TZ=America/New_York \
    --net hostnet \
    --ip 172.20.0.2 \
    --volume ./matchbox/config:/opt/matchbox20:Z \
    quay.io/poseidon/matchbox:v0.11.0@sha256:06bcdae85335fd00e8277b007b55cfb49d96a0114628c0f70db2b92b079d246a \
    -address=0.0.0.0:80 -log-level=debug