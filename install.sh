#! /bin/bash

echo MY HOME DIR:$HOME

snap_apps="go kubectl kubectx terraform vault yq helm"
for app in $snap_apps;
do
    sudo snap install $app --classic
done
sudo snap install starship --classic --edge
KREW_PLUGINS="access-matrix allctx cert-manager creyaml ctx deprecations df-pv eksporter exec-cronjob grep konfig ns rabbitmq split-yaml starboard"
KREW_PLUGINS="${KREW_PLUGINS} support-bundle tree unused-volumes  view-cert view-serviceaccount-kubeconfig  view-secret  who-can whoami rolesum  resource-versions"
KREW_PLUGINS="${KREW_PLUGINS} outdated node-shell neat get-all mc ipick minio virt example"

(
  set -x; cd "$(mktemp -d)" &&
  OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
  KREW="krew-${OS}_${ARCH}" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
  sudo -H -u itamar bash -c "tar zxvf ${KREW}.tar.gz" &&
  sudo -H -u itamar bash -c "./${KREW} install krew"
)
for plugin in ${KREW_PLUGINS} 
do
	sudo -H -u itamar bash -c "kubectl krew install $plugin"
done

wget https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/latest/openshift-client-linux.tar.gz
tar -xvf openshift-client-linux.tar.gz
sudo cp oc /usr/local/bin/

export PATH="${KREW_ROOT:-/.krew}/bin:$PATH"
dir_name=$(dirname "$0")

home=/home/itamar/
# mkdir $home

sudo cp $dir_name/.bashrc  $home | true
sudo mkdir $home/.config
dir_name=$(dirname "$0")
sudo cp $dir_name/.config/starship.toml $home/.config

cd ..

git clone https://github.com/jonmosco/kube-ps1
sudo cp kube-ps1/kube-ps1.sh /usr/local/etc/