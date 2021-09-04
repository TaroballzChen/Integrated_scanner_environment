FROM debian:10.10

VOLUME [ "/data" ]
WORKDIR /workdir

RUN apt update; \
    apt install wget -y; \
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
    apt install zmap nmap -y; \
    apt install python3-pip -y; \
    \
    # Download Taiwan all ip CIDR data
    wget http://www.ipdeny.com/ipblocks/data/countries/tw.zone; \
    # node deploy to railyway.app for manage by ssh
    apt install ssh wget npm -y; \
    npm install -g wstunnel; \
    mkdir /run/sshd; \
    echo 'wstunnel -s 0.0.0.0:80 &' >>/1.sh; \
    echo '/usr/sbin/sshd -D' >>/1.sh; \
    echo 'PermitRootLogin yes' >>  /etc/ssh/sshd_config; \
    echo root:taroballz|chpasswd; \
    chmod 755 /1.sh; 
EXPOSE 80
CMD  /1.sh
