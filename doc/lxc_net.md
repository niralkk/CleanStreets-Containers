# LXC networking setting

## Create network 

Create a network for smartcity interanl service ***smartcity0***

> Current service is under 10.82.200.1

```bash
lxc network create smartcity0 ipv4.address=10.82.200.1/24 ipv4.nat=true
```

## Attach network to the container

Attach smartcity0 network to the Kafaka, zookeeper
mongodb container

```bash
lxc network attach smartcity0 smarcity-mongodb eth0
lxc network attach smartcity0 smarcity-mq eth0
```
