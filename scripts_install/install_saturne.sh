#!/usr/bin/env bash
set -ex

#SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
SCRIPT_DIR=.
. ${SCRIPT_DIR}/credits_service_account.conf
sh ${SCRIPT_DIR}/add_service_account.sh

export DEBIAN_FRONTEND=noninteractive 
export DEBCONF_NONINTERACTIVE_SEEN=true
echo "tzdata tzdata/Areas select Europe" > /root/prefs 
echo "tzdata tzdata/Zones/Europe select Paris" >> /root/prefs
debconf-set-selections  /root/prefs 

if [ $(( $(date "+%s") -  $(date -r /var/cache/apt "+%s"))) -gt 28800 ]; then apt-get -y update; else echo "apt-get useless"; fi    
apt-get -y install g++ gfortran 
apt-get -y install zlib1g-dev libudev-dev	
#apt-get -y install python3-pyqt5 pyqt5-dev pyqt5-dev-tools qtbase5-dev qtcreator qt5-qmake
apt-get -y install pip
pip install pyqt5
apt-get -y install python3-pyqt5
apt-get clean && rm -rf /var/lib/apt/*

saturne_ver=7.0.5 
mkdir -p /LOCAL/code_saturne/${saturne_ver}
mkdir -p /LOCAL/code_saturne/TAR
cp ${SCRIPT_DIR}/install_saturne_by_app_user.sh /LOCAL/code_saturne/
chgrp -R $app_group /LOCAL  
chmod -R g+rwxs /LOCAL
ls -l /LOCAL/code_saturne/
cd /LOCAL/code_saturne/TAR
sed -i 's@PATH="@PATH="/LOCAL/code_saturne/7.0.5/code_saturne-7.0.5/arch/Linux_x86_64/bin:@g' /etc/environment
echo "saturne_ver=7.0.5" >>/etc/environment
su - $app_user -c "/LOCAL/code_saturne/install_saturne_by_app_user.sh"
chown -R root:root  /LOCAL
chmod -R o+rx /LOCAL
ls /LOCAL/code_saturne/7.0.5

exit 0
  
