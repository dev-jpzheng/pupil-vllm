#!/usr/bin/bash

set -euo pipefail

OUT="bench/$(date +%F)"
if [ -n "${1:-}" ]; then
   OUT="${OUT}-${1}"
fi

mkdir -p "$OUT"

bash bench/env_extractor.sh > "$OUT/environment.md"

# warmup

# bench

