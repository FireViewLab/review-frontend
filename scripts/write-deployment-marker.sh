#!/usr/bin/env bash
set -euo pipefail

deployment_sha="${GITHUB_SHA:-${VERCEL_GIT_COMMIT_SHA:-$(git rev-parse HEAD)}}"
if [[ ! "$deployment_sha" =~ ^[0-9a-fA-F]{40}$ ]]; then
  echo 'Invalid deployment commit SHA' >&2
  exit 1
fi
mkdir -p build/web
printf '{"commitSha":"%s"}\n' "$deployment_sha" > build/web/deployment.json
