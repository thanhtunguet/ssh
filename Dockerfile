FROM debian:11-slim

RUN apt-get update && apt-get install openssh-server curl wget htop telnet dnsutils net-tools nano vim -y

WORKDIR /usr/local/bin/

COPY docker-entrypoint.sh ./
RUN  chmod a+x docker-entrypoint.sh

RUN  echo "GatewayPorts yes" >> /etc/ssh/sshd_config

CMD ["/usr/local/bin/docker-entrypoint.sh"]
