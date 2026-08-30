#!/usr/bin/env bats

setup() {
  cd "$BATS_TEST_DIRNAME/.."
  RENDERED="$(helm template . )"
  export RENDERED
}

@test "adopts k8s-zot Application while homelab-zot entry still renders" {
  repo_url=$(echo "$RENDERED" | yq eval-all '
    select(.kind == "Application" and .metadata.name == "k8s-zot") | .spec.source.repoURL
  ' -)
  old_name=$(echo "$RENDERED" | yq eval-all '
    select(.kind == "Application" and .metadata.name == "homelab-zot") | .metadata.name
  ' -)

  [ "$repo_url" = "https://github.com/mattjmorrison-homelab/k8s-zot" ]
  [ "$old_name" = "homelab-zot" ]
}
