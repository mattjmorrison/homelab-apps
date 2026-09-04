#!/usr/bin/env bats

setup() {
  cd "$BATS_TEST_DIRNAME/.."
  RENDERED="$(helm template . )"
  export RENDERED
}

@test "renders k8s-homepage Application instead of homelab-homepage" {
  repo_url=$(echo "$RENDERED" | yq eval-all '
    select(.kind == "Application" and .metadata.name == "k8s-homepage") | .spec.source.repoURL
  ' -)
  namespace=$(echo "$RENDERED" | yq eval-all '
    select(.kind == "Application" and .metadata.name == "k8s-homepage") | .spec.destination.namespace
  ' -)
  old_name=$(echo "$RENDERED" | yq eval-all '
    select(.kind == "Application" and .metadata.name == "homelab-homepage") | .metadata.name
  ' -)

  [ "$repo_url" = "https://github.com/mattjmorrison-homelab/k8s-homepage" ]
  [ "$namespace" = "homepage" ]
  [ -z "$old_name" ]
}
