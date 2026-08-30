#!/usr/bin/env bats

setup() {
  cd "$BATS_TEST_DIRNAME/.."
  RENDERED="$(helm template . )"
  export RENDERED
}

@test "renders k8s-argocd Application instead of homelab-argocd" {
  repo_url=$(echo "$RENDERED" | yq eval-all '
    select(.kind == "Application" and .metadata.name == "k8s-argocd") | .spec.source.repoURL
  ' -)
  namespace=$(echo "$RENDERED" | yq eval-all '
    select(.kind == "Application" and .metadata.name == "k8s-argocd") | .spec.destination.namespace
  ' -)
  old_name=$(echo "$RENDERED" | yq eval-all '
    select(.kind == "Application" and .metadata.name == "homelab-argocd") | .metadata.name
  ' -)

  [ "$repo_url" = "https://github.com/mattjmorrison-homelab/k8s-argocd" ]
  [ "$namespace" = "argocd" ]
  [ -z "$old_name" ]
}
