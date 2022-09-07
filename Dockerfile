FROM centos:8

MAINTAINER Ian Ellis

ENV container docker
RUN yum -y update                                                               \
 && yum -y install systemd                                                      \
 && cd /lib/systemd/system/sysinit.target.wants/                                \ 
 && for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done   \
 && rm -f /lib/systemd/system/multi-user.target.wants/*                         \
 && rm -f /etc/systemd/system/*.wants/*                                         \
 && rm -f /lib/systemd/system/local-fs.target.wants/*                           \
 && rm -f /lib/systemd/system/sockets.target.wants/*udev*                       \
 && rm -f /lib/systemd/system/sockets.target.wants/*initctl*                    \
 && rm -f /lib/systemd/system/basic.target.wants/*                              \
 && rm -f /lib/systemd/system/anaconda.target.wants/*                           \
 && yum clean all                                                               \
 && yum install -y openssh-server sudo                                          \
 && systemctl enable sshd                                                       \
 && sed -i 's/%wheel.ALL=(ALL).ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers   \
 && rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm  \
 && yum install -y puppet-agent python-setuptools bzip2                         \
 && yum remove -y mariadb-libs nfs-utils libX11                                 \
 && yum autoremove -y                                                           \
 && easy_install pip                                                            \
 && pip install --upgrade awscli                                                \
 && /opt/puppetlabs/puppet/bin/gem install aws-sdk hiera-eyaml hiera-eyaml-kms --no-ri --no-rdoc \
 && curl -Lo /usr/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 \
 && chmod +x /usr/bin/jq                                                       \
 && yum clean all                                                               
RUN useradd -p vagrant vagrant
RUN usermod -a -G wheel vagrant
RUN yum install -y epel-release
RUN yum install -y figlet
RUN yum install -y initscripts
RUN yum install -y audit
RUN yum install -y cronie
RUN touch /etc/fstab
RUN mkdir ~vagrant/.ssh                                                         \
 && chmod 700 ~vagrant/.ssh                                                     \
 && echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ==" > ~vagrant/.ssh/authorized_keys       \
 && chown -R vagrant:vagrant ~vagrant/.ssh                                      \
 && sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config                       \
 && mv /bin/yum /bin/yum.real                                                   \
 && echo '#!/bin/bash' > /bin/yum                                               \
 && echo 'if [ "$1 $2" == "clean all" ]' >> /bin/yum                            \
 && echo 'then' >> /bin/yum                                                     \
 && echo '  echo "Dummy Clean All"' >> /bin/yum                                 \
 && echo 'else' >> /bin/yum                                                     \
 && echo '  /bin/yum.real $*' >> /bin/yum                                       \
 && echo 'fi' >> /bin/yum                                                       \
 && chmod +x /bin/yum

VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]
