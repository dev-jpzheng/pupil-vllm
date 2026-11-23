#!/usr/bin/bash

# bench/env_extractor.sh — Minimal benchmark environment (markdown)
# Usage: ./bench/env_extractor.sh > environment.md

set -euo pipefail

row() { printf -- '- **%s**: %s\n' "$1" "${2:-N/A}"; }
q()   { local v; v=$(eval "$1" 2>/dev/null | head -n 1) || true; printf '%s' "${v:-N/A}"; }

echo "# Benchmark Environment"
echo

row "Date / host" "$(date '+%F %T %Z') on $(hostname)"
row "OS" "$(q "awk -F'\"' '/^PRETTY_NAME=/{print \$2}' /etc/os-release") (kernel $(q 'uname -r'))"
row "CPU" "$(q "grep -m1 'model name' /proc/cpuinfo | cut -d: -f2 | sed 's/^ //'")"
row "CPU cores" "$(q "lscpu | awk '/^Core\\(s\\) per socket/{c=\$NF}/^Socket\\(s\\)/{s=\$NF}END{print c*s}'") physical / $(q 'nproc') threads"
row "Memory" "$(q "free -h | awk '/^Mem:/{print \$2 \" total, \" \$7 \" avail\"}'")"
row "GPU" "$(q "nvidia-smi --query-gpu=name --format=csv,noheader | paste -sd' + ' -")"
row "GPU memory (total/used)" "$(q "nvidia-smi --query-gpu=memory.total,memory.used --format=csv,noheader | paste -sd' / ' -")"
row "Driver / CUDA" "$(q "nvidia-smi --query-gpu=driver_version --format=csv,noheader | head -1") / $(q "nvcc --version | grep -oP 'release \K[0-9.]+'")"
row "SM clocks (current/max)" "$(q "nvidia-smi --query-gpu=clocks.sm,clocks.max.sm --format=csv,noheader | paste -sd' / ' -")"
row "Other compute processes" "$(q "nvidia-smi --query-compute-apps=pid --format=csv,noheader | paste -sd',' -" | sed 's/^N\/A$/none/')"
row "Python / PyTorch" "$(q "python3 -c 'import sys;print(sys.version.split()[0])'") / $(q "python3 -c 'import torch;print(torch.__version__)'")"
