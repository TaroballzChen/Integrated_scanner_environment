#!/bin/bash

# make workdir
mkdir /data
mkdir /workdir

# ssh env
echo "PermitRootLogin yes" > /etc/ssh/sshd_config
echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
echo "ChallengeResponseAuthentication no" >> /etc/ssh/sshd_config
echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config
echo "UsePAM yes" >> /etc/ssh/sshd_config
echo "X11Forwarding yes" >> /etc/ssh/sshd_config
echo "PrintMotd no" >> /etc/ssh/sshd_config
echo 'AcceptEnv LANG LC_*' >> /etc/ssh/sshd_config
echo -e "Subsystem\tsftp\t/usr/lib/openssh/sftp-server" >> /etc/ssh/sshd_config
echo 'ClientAliveInterval 120' >> /etc/ssh/sshd_config

mkdir -p ~/.ssh
echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCkVhN9UuCk+Lz+mrBA/B7rcTWVV8v0FPiNgGMdhDx3wVbToiIVNT2T4lgwve9w8SEjKtmw1OVqBMYp/JMOCax9sk914qeqUMEsto1dobhQ85XzSf0bh/q4P9fUiuSdtZ9G3t1zEgKOuos0lEuHWUFtnIPBBspTQ7Yd9JTF7tFtJ+6GBJG+ZTDG/1K3OwUJ5PTsNlOKX9d+Zn2di7PUQU0/MOtxvJoiITpRydpVc0HJS46Ld7w3GQxXKSgxUDeuqBmf844dkRtmQ2W543Oyy0PijB+dUj/SdFH/itv7Pwq7fCe1P3y8siiz2Ysy4tnPf5K61IQde5hKrrIvnPXpKbP5979E1cLVM4jGwQk7zXDI2QoNRq1xfwuoRstc+lC0xhY0DA1AMlzGsRUQm+fki5n5yU5V8ePnuw5QXBNpmPSyw9+RVK7bdguwF5+bakRN3xqIJjDj61n6W/ePJuI8R5FWTDmkiYnHP5PQlXELw0XY+RdzH/uQQe3ZzDB7ZhixZtM= taroballz@52-0A90441-81.local' >> ~/.ssh/authorized_keys
systemctl restart ssh.service

# env build
apt update
apt install wget zmap nmap -y

# zgrab2 intsall
wget https://golang.org/dl/go1.16.7.linux-amd64.tar.gz
tar -C /usr/local/ -xzf go1.16.7.linux-amd64.tar.gz
mkdir /workdir/go
rm -rf go*.tar.gz
export PATH=$PATH:/usr/local/go/bin
export GOPATH=/workdir/go
export GO111MODULE=off
apt install git build-essential ca-certificates prips -y
go get github.com/zmap/zgrab2
cd $GOPATH/src/github.com/zmap/zgrab2
export GO111MODULE=on
make
cp cmd/zgrab2/zgrab2 /usr/bin
ln -s /usr/sbin/zmap /usr/bin/zmap
cd /workdir

# Download Taiwan all ip CIDR data
wget http://www.ipdeny.com/ipblocks/data/countries/tw.zone
