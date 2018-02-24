#!/bin/bash
echo "::Premptively add swift to path::"              
echo "export PATH=/opt/swift/usr/bin:\"${PATH}\"" >> /home/ubuntu/.bashrc

echo "::apt-get update::"
apt-get -y update

echo "::apt-get upgrade::"
# https://askubuntu.com/questions/146921/how-do-i-apt-get-y-dist-upgrade-without-a-grub-config-prompt
DEBIAN_FRONTEND=noninteractive apt-get -y -o DPkg::options::="--force-confdef" -o DPkg::options::="--force-confold"  install grub-pc
apt-get -y upgrade

echo "::Install Packages::"
# https://bugs.swift.org/browse/SR-2743
apt-get -y install clang libicu-dev libpython2.7 libcurl3

echo "::Download + Install Swift::"
wget -qO- https://swift.org/builds/swift-4.0.3-release/ubuntu1604/swift-4.0.3-RELEASE/swift-4.0.3-RELEASE-ubuntu16.04.tar.gz | tar xvz
mv swift-4.0.3-RELEASE-ubuntu16.04 /opt/swift              
# https://bugs.swift.org/browse/SR-2783
chmod -R a+r /opt/swift/usr/lib/swift/CoreFoundation
