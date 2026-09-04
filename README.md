# homelab-apps

ArgoCD App of Apps for the homelab k3s cluster.

Contains one ArgoCD `Application` manifest per deployed service. ArgoCD watches this repo and automatically syncs any service listed here. To add a new service, create a `homelab-<service>` repo with its manifests and add an Application pointing at it here.

## Tests

```
make check
```

Runs the bats suite in `tests/` against `helm template` output — no cluster required.

---

[Homelab Docs](https://github.com/mattjmorrison/homelab/blob/main/docs/INDEX.md)
