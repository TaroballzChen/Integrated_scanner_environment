FROM debian:10.10

VOLUME [ "/data" ]
WORKDIR /workdir

RUN apt update; \
    apt install wget curl -y; \
    wget https://golang.org/dl/go1.16.7.linux-amd64.tar.gz; \
    tar -C /usr/local/ -xzf go1.16.7.linux-amd64.tar.gz; \
    mkdir /workdir/go; \
    export PATH=$PATH:/usr/local/go/bin; \
    export GOPATH=/workdir/go;\
    export GO111MODULE=off;\
    apt install git build-essential ca-certificates -y; \
    go get github.com/zmap/zgrab2; \
    cd $GOPATH/src/github.com/zmap/zgrab2; \
    export GO111MODULE=on; \
    make; \
    cp cmd/zgrab2/zgrab2 /usr/bin; \
    cd /workdir; \
    rm -rf go*.tar.gz; \
    \
    apt install zmap nmap prips -y; \
    apt install python3-pip -y; \
    \
    # Download Taiwan all ip CIDR data
    wget http://www.ipdeny.com/ipblocks/data/countries/tw.zone -O /workdir/TW.CIDR; \
    for i in $(cat /workdir/TW.CIDR);do prips $i >> /workdir/tw.zone;done; \
    # node deploy to railyway.app for manage by ssh
    apt install ssh npm -y; \
    npm install -g wstunnel; \
    mkdir /run/sshd; \
    mkdir -p ~/.ssh; \
    echo 'wstunnel -s 0.0.0.0:80 &' >>/Run.sh; \
    echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCkVhN9UuCk+Lz+mrBA/B7rcTWVV8v0FPiNgGMdhDx3wVbToiIVNT2T4lgwve9w8SEjKtmw1OVqBMYp/JMOCax9sk914qeqUMEsto1dobhQ85XzSf0bh/q4P9fUiuSdtZ9G3t1zEgKOuos0lEuHWUFtnIPBBspTQ7Yd9JTF7tFtJ+6GBJG+ZTDG/1K3OwUJ5PTsNlOKX9d+Zn2di7PUQU0/MOtxvJoiITpRydpVc0HJS46Ld7w3GQxXKSgxUDeuqBmf844dkRtmQ2W543Oyy0PijB+dUj/SdFH/itv7Pwq7fCe1P3y8siiz2Ysy4tnPf5K61IQde5hKrrIvnPXpKbP5979E1cLVM4jGwQk7zXDI2QoNRq1xfwuoRstc+lC0xhY0DA1AMlzGsRUQm+fki5n5yU5V8ePnuw5QXBNpmPSyw9+RVK7bdguwF5+bakRN3xqIJjDj61n6W/ePJuI8R5FWTDmkiYnHP5PQlXELw0XY+RdzH/uQQe3ZzDB7ZhixZtM= taroballz@52-0A90441-81.local' >> ~/.ssh/authorized_keys; \
    echo '/usr/sbin/sshd -D' >>/Run.sh; \
    echo 'PermitRootLogin yes' >>  /etc/ssh/sshd_config; \
    echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config; \
    echo 'PubkeyAuthentication yes' >> /etc/ssh/sshd_config; \
    chmod 755 /Run.sh; 
EXPOSE 80
CMD  /Run.sh
