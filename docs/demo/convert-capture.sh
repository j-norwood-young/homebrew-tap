#!/usr/bin/env bash
# Convert a clitorrents screencast (.mov) into README-friendly assets.
# Usage: ./convert-capture.sh [path/to/capture.mov]
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SRC="${1:-$ROOT/../clitorrents/clitorrents-capture.mov}"
DEST="$ROOT/docs/demo"

if [[ ! -f "$SRC" ]]; then
  echo "Source not found: $SRC" >&2
  echo "Usage: $0 [capture.mov]" >&2
  exit 1
fi

echo "Converting $SRC → $DEST/tui.{mp4,gif,png}"

ffmpeg -y -i "$SRC" \
  -an -c:v libx264 -crf 22 -preset slow -pix_fmt yuv420p -movflags +faststart \
  -vf "scale=1100:-2:flags=lanczos" \
  "$DEST/tui.mp4"

ffmpeg -y -i "$SRC" \
  -an \
  -vf "fps=15,scale=900:-2:flags=lanczos,split[s0][s1];[s0]palettegen=stats_mode=diff[p];[s1][p]paletteuse=dither=bayer:bayer_scale=3" \
  "$DEST/tui.gif"

ffmpeg -y -i "$SRC" -ss 00:00:08 -frames:v 1 "$DEST/tui.png"

ls -lh "$DEST/tui.mp4" "$DEST/tui.gif" "$DEST/tui.png"
