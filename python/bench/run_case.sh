#!/usr/bin/bash

set -euo pipefail

CASE="$1"; OUT="bench/$(date +%F)"; [ -n "$CASE" ] && OUT="${OUT}-${CASE}"
mkdir -p "$OUT"
bash bench/env_extractor.sh > "$OUT/environment.md"

# warmup

# bench

