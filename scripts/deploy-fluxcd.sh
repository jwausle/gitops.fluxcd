CLUSTER_NAME=${1:-./fluxcd/clusters/localhost}
BRANCH=${BRANCH:-$(git rev-parse --abbrev-ref HEAD)}
GITHUB_USER=${GITHUB_USER:-jwausle}
GITHUB_TOKEN=${GITHUB_TOKEN:-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}

if [[ "${CLUSTER_NAME}" == */localhost  ]] && [[ "${KUBECONFIG}" != *.k3s/kubeconfig.yaml ]]; then
   echo "export KUBECONFIG=$(pwd)/.k3s/kubeconfig.yaml to install at localhost "
   exit 1
fi

# Install fluxcd resources to namespace flux-system
flux install

# Connect flux with the gitrepo (upload ssh key and push flux-system components)
flux bootstrap github \
  --owner=jwausle \
  --repository=gitops.fluxcd \
  --private=false \
  --personal=true \
  --branch=${BRANCH} \
  --interval=1m \
  --path=fluxcd/clusters/base

# Setup cluster configuration by name under `./fluxcd/clusters/`
flux create kustomization flux-system \
  --source=flux-system \
  --path="${CLUSTER_NAME}" \
  --prune=true \
  --interval=3m
