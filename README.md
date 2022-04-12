# GitOps with fluxcd/v2

> require docker, flux `brew install fluxcd/tap/flux` [link](https://fluxcd.io/docs/installation/)

## Getting started

> Fork `jwausle/gitops.fluxcd.git`

```
export GITHUB_USER=<your-github-user:~jwausle>
export GITHUB_TOKEN=<your-github-token-rw:~3B1KvFxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx>

# Start local cluster
bash scripts/run-cluster-local.sh

# Setup this repo under flux control
bash scripts/run-cluster-local.sh
```

1. Run a k3s cluster as docker container
2. Install flux application and connect this github repo
 * Generate ssh key and upload them to github
 * Connect `fluxcd/clusters/localhost`
 * Flux deploy the connected configuration
3. Loadbalancer/Traefik is installed
4. Fluxcd UI - weaver is available https://admin:admin@localhost/


## Demo

### Enable services

* namespace is created
* whoami pod is installed

```
curl -k https://localhost/whoami/test
```

### Enable service/whoami-helmrelease

* helmchart is installed

```
curl -k https://localhost/whoami-helm2/test
```

### Enable service/whoami-helmrelease-indirect-1

* kustomization is not read
* because dependsOn (whoami-helmrelease-indirect-2)

### Enable service/whoami-helmrelease-indirect-2

* whoami-helmrelease-indirect-1 is installed
* whoami-helmrelease-indirect-2 is installed

```
curl -k https://localhost/whoami-helm3/test
curl -k https://localhost/whoami-helm4/test
```
