CLUSTER_NAME=${1:-./fluxcd/clusters/localhost}
BRANCH=${BRANCH:-$(git rev-parse --abbrev-ref HEAD)}

if [[ "${CLUSTER_NAME}" == */localhost  ]] && [[ "${KUBECONFIG}" != *.k3s/kubeconfig.yaml ]]; then
   echo "export KUBECONFIG=$(pwd)/.k3s/kubeconfig.yaml to install at localhost "
   exit 1
fi

# Install fluxcd resources to namespace flux-system
flux install

# Setup git repository `cluster-deployment` as fluxcd source
flux create source git flux-system \
  --git-implementation=libgit2 \
  --url=https://dev.azure.com/mysaveid/mysaveid-deployment/_git/mysaveid-deployment \
  --branch=${BRANCH} \
  --username=flux-system \
  --password=d4ef27gg2ubn35pq5x4paajg6ihktu5jsebidbh6uclabgiqbmeq \
  --interval=1m

# Setup cluster configuration by name under `./fluxcd/clusters/`
flux create kustomization flux-system \
  --source=flux-system \
  --path="${CLUSTER_NAME}" \
  --prune=true \
  --interval=3m
