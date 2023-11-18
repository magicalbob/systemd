FROM almalinux:9

RUN yum update -y \
 && yum install -y net-tools jq

CMD ["/usr/lib/systemd/systemd"]
