#!/bin/bash
# Should be start from project root (~pwd)
rm -rf $(pwd)/.k3s
mkdir $(pwd)/.k3s
rm -rf $(pwd)/.k3s-pv
mkdir $(pwd)/.k3s-pv

# Handle SIG_INT
function breakup() { docker stop k3s; }
trap breakup INT

sudo docker run \
  -d \
  --rm \
  --name k3s \
  --tmpfs /run \
  --tmpfs /var/run \
  -p 6443:6443 \
  -p 443:443 \
  -p 80:80 \
  -e K3S_TOKEN=supersecret \
  -e K3S_KUBECONFIG_OUTPUT=/output/kubeconfig.yaml \
  -e K3S_KUBECONFIG_MODE=666 \
  -v $(pwd)/.k3s:/output \
  -v $(pwd)/.k3s-pv:/var/lib/rancher/k3s/storage \
  --privileged "rancher/k3s:v1.22.5-k3s2" \
  server --cluster-init --disable=traefik

sleep 1

echo ""
echo "export KUBECONFIG=$(pwd)/.k3s/kubeconfig.yaml"

if [[ $* =~ --attach ]]; then
  docker logs -f k3s
fi
