#! /bin/bash
snap_apps="go kubectl kubectx terraform vault yq helm starship"
sudo apt install git
for app in $snap_apps;
do
    echo "sudo snap install $app --classic"
done
# mkdir configs
cd ..
git clone https://github.com/jonmosco/kube-ps1
cp kube-ps1/kube-ps1.sh /usr/local/etc/