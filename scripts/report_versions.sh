#!/usr/bin/env bash
set -euo pipefail

echo "Nextflow: $(nextflow -version | head -n 1 | sed 's/^[[:space:]]*//')"
if command -v conda >/dev/null 2>&1; then
  echo "Conda: $(conda --version)"
else
  echo "Conda: not found"
fi
echo "OS: $(uname -s)"
echo "Architecture: $(uname -m)"
