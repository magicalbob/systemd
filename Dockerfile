FROM almalinux:10

RUN yum update -y \
 && yum install -y net-tools jq procps-ng podman podman-docker

CMD ["/usr/lib/systemd/systemd"]
