#!/usr/bin/env bash
# Build an installable .plasmoid file (a zip with metadata.json at its root).
set -euo pipefail
cd "$(dirname "$0")"

VERSION=$(sed -n 's/.*"Version": *"\([^"]*\)".*/\1/p' package/metadata.json)
OUT="macos-battery-${VERSION}.plasmoid"

rm -f "$OUT"
(cd package && zip -r -X "../$OUT" . -x '*.DS_Store' >/dev/null)
echo "Built $OUT"
