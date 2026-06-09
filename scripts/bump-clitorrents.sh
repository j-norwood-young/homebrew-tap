#!/usr/bin/env bash
set -euo pipefail

VERSION="${1:?Usage: bump-clitorrents.sh <version>}"
VERSION="${VERSION#v}"
FORMULA="Formula/clitorrents.rb"
REPO="j-norwood-young/clitorrents"
PLATFORM="darwin-arm64"

if [[ ! -f "$FORMULA" ]]; then
  echo "Formula not found: $FORMULA" >&2
  exit 1
fi

URL="https://github.com/${REPO}/releases/download/v${VERSION}/clitorrents-${VERSION}-${PLATFORM}.tar.gz"
SHA256="$(curl -fsSL "$URL" | sha256sum | awk '{print $1}')"

perl -0pi -e "s|url \"https://github.com/${REPO}/releases/download/v[^/]+/clitorrents-[^\"]+-darwin-arm64.tar.gz\"|url \"${URL}\"|g" "$FORMULA"
perl -0pi -e "s|sha256 \"[^\"]+\"|sha256 \"${SHA256}\"|" "$FORMULA"

echo "Updated $FORMULA to clitorrents@${VERSION}"
echo "  url:    ${URL}"
echo "  sha256: ${SHA256}"
