#! /bin/bash
snap_apps="go kubectl kubectx terraform vault yq helm"
for app in $snap_apps;
do
    snap install $app --classic
done
snap install starship --classic --edge

  
OS="$(uname | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" 
KREW="krew-${OS}_${ARCH}" 
curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz"
tar zxvf "${KREW}.tar.gz"
./"${KREW}" install krew

wget https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/latest/openshift-client-linux.tar.gz
tar -xvf openshift-client-linux.tar.gz
cp oc /usr/local/bin/
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
KREW_PLUGINS="access-matrix allctx cert-manager creyaml ctx deprecations df-pv eksporter exec-cronjob grep konfig ns rabbitmq split-yaml starboard"
KREW_PLUGINS="${KREW_PLUGINS} support-bundle tree unused-volumes  view-cert view-serviceaccount-kubeconfig  view-secret  who-can whoami rolesum  resource-versions"
KREW_PLUGINS="${KREW_PLUGINS} outdated node-shell neat get-all mc ipick minio virt example"
dir_name=$(dirname "$0")
for plugin in ${KREW_PLUGINS} 
do
	kubectl krew install $plugin
done
home=/home/itamar/
mkdir $home

cp $dir_name/.bashrc  $home | true
mkdir $home/.config
dir_name=$(dirname "$0")
cp $dir_name/.config/starship.toml $home/.config

cd ..

git clone https://github.com/jonmosco/kube-ps1
cp kube-ps1/kube-ps1.sh /usr/local/etc/