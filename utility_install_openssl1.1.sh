#!/bin/sh
cd /usr/src/
sudo wget https://www.openssl.org/source/openssl-1.1.1g.tar.gz -O openssl-1.1.1g.tar.gz
sudo tar -zxf openssl-1.1.1g.tar.gz
cd openssl-1.1.1g/
sudo ./config
sudo make
sudo make test
sudo make install
sudo mv /usr/bin/openssl.old /root/.
echo "/usr/local/ssl/lib" >> /etc/ld.so.conf.d/openssl-1.1.1g
sudo ldconfig -v | grep ssl # should return something
sudo mv /usr/bin/c_rehash /usr/bin/c_rehash.backup
sudo mv /usr/bin/openssl /usr/bin/openssl.backup
echo 'PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/local/ssl/bin"' > /etc/environment
source /etc/environment # don't sudo this one
echo $PATH # should have an ssl entry at end
/usr/local/bin/openssl version # should be your 1.1.1g version
