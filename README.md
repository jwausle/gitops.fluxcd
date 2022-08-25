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
4. Fluxcd UI - weaver is available https://localhost/ (admin:admin)


## Demo

```
git reset be7e1340c23d3a70462d0c16ca8ef37b7f5bed42
git push origin master
```

### 1) Install infrastructure

```
git rebase demo/1
git push origin master
```

* traefik installed
* weave installed

### 2) Enable services

```
git rebase demo/2
git push origin master
```

* namespace is created
* whoami pod is installed

```
# test
curl -k https://localhost/whoami/test
```

### 3) Enable service/whoami-helmrelease

```
git rebase demo/3
git push origin master
```

* helmchart is installed

```
curl -k https://localhost/whoami-helm2/test
```

### 4) Enable service/whoami-helmrelease-indirect-1

```
git rebase demo/4
git push origin master
```

* kustomization is not read
* because dependsOn (whoami-helmrelease-indirect-2)

### 5) Enable service/whoami-helmrelease-indirect-2

```
git rebase demo/5
git push origin master
```

* whoami-helmrelease-indirect-1 is installed
* whoami-helmrelease-indirect-2 is installed

```
curl -k https://localhost/whoami-helm3/test
curl -k https://localhost/whoami-helm4/test
```

### 6) Patch whoami-helmrelease-indirect-1 path `test`

```
git rebase demo/6
git push origin master
```

* replace the route path of `whoami-helmrelease-indirect-1`
* check IngressRoute `whoami-helmrelease-indirect-1` afterwards

```
curl -k https://localhost/test/test
curl -k https://localhost/whoami-helm3/test (fail)
```

### 7) Patch whoami-helmrelease path `test2`

```
git rebase demo/7
git push origin master
```

* replace the route path of `whoami-helmrelease`
* check IngressRoute `whoami-helmrelease` afterwards

```
curl -k https://localhost/test2/test
curl -k https://localhost/whoami-helm2/test (fail)
```
