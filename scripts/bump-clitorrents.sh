#!/usr/bin/env bash
set -euo pipefail

VERSION="${1:?Usage: bump-clitorrents.sh <version>}"
VERSION="${VERSION#v}"
FORMULA="Formula/clitorrents.rb"
URL="https://registry.npmjs.org/clitorrents/-/clitorrents-${VERSION}.tgz"

if [[ ! -f "$FORMULA" ]]; then
  echo "Formula not found: $FORMULA" >&2
  exit 1
fi

SHA256="$(curl -fsSL "$URL" | sha256sum | awk '{print $1}')"

perl -0pi -e "s|url \".*\"|url \"$URL\"|" "$FORMULA"
perl -0pi -e "s|sha256 \".*\"|sha256 \"$SHA256\"|" "$FORMULA"

echo "Updated $FORMULA to clitorrents@${VERSION}"
echo "  url:    $URL"
echo "  sha256: $SHA256"
