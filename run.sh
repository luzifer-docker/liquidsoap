#!/usr/bin/dumb-init /bin/bash
set -euxo pipefail

eval $(opam config env)

exec liquidsoap "$@"
