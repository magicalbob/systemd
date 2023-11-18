Build
=====

```
docker build -t local:systemd .
```

Run
===

```
    docker run -d \             
       --privileged \
       --rm \
       --name systemd \
       local:systemd
```
