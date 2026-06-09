#!/usr/bin/env bash
set -euo pipefail

VERSION="${1:?Usage: bump-clitorrents.sh <version>}"
VERSION="${VERSION#v}"
FORMULA="Formula/clitorrents.rb"
REPO="j-norwood-young/clitorrents"

if [[ ! -f "$FORMULA" ]]; then
  echo "Formula not found: $FORMULA" >&2
  exit 1
fi

sha_for() {
  local platform="$1"
  local url="https://github.com/${REPO}/releases/download/v${VERSION}/clitorrents-${VERSION}-${platform}.tar.gz"
  curl -fsSL "$url" | sha256sum | awk '{print $1}'
}

ARM_SHA="$(sha_for darwin-arm64)"
X64_SHA="$(sha_for darwin-x64)"

perl -0pi -e "s|url \"https://github.com/${REPO}/releases/download/v[^/]+/clitorrents-[^\"]+-darwin-arm64.tar.gz\"|url \"https://github.com/${REPO}/releases/download/v${VERSION}/clitorrents-${VERSION}-darwin-arm64.tar.gz\"|g" "$FORMULA"
perl -0pi -e "s|url \"https://github.com/${REPO}/releases/download/v[^/]+/clitorrents-[^\"]+-darwin-x64.tar.gz\"|url \"https://github.com/${REPO}/releases/download/v${VERSION}/clitorrents-${VERSION}-darwin-x64.tar.gz\"|g" "$FORMULA"
perl -0pi -e "s|sha256 \"[^\"]+\"(\s*\n\s*end\s*\n\s*on_intel)|sha256 \"${ARM_SHA}\"\\1|" "$FORMULA"
perl -0pi -e "s|(on_intel do\n\s*url \"[^\"]+\"\n\s*)sha256 \"[^\"]+\"|\\1sha256 \"${X64_SHA}\"|" "$FORMULA"

echo "Updated $FORMULA to clitorrents@${VERSION}"
echo "  darwin-arm64 sha256: ${ARM_SHA}"
echo "  darwin-x64   sha256: ${X64_SHA}"
