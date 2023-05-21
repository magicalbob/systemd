Build
=====

```
docker build -t local:systemd .
```

Run
===

```
docker run -ti \
       --tmpfs /tmp \
       --tmpfs /run \
       -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
       --privileged \
       --rm \
       local:systemd
```
