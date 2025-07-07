#!/usr/bin/env bash

## Creator: Faye
## Github: https://github.com/seraphicfae/dotfiles

WALL_DIR="$HOME/.config/wallpapers"
STATE_FILE="$HOME/.cache/swww_idx"
CURRENT_WALL="$HOME/.cache/current_wallpaper"

mkdir -p "$(dirname "$STATE_FILE")"

# Get list of wallpapers sorted
mapfile -t WALLS < <(find "$WALL_DIR" -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \) | sort)
[ ${#WALLS[@]} -gt 0 ] || exit 1

# Get current wallpaper as an index
if [[ -r "$STATE_FILE" ]]; then
  idx=$(<"$STATE_FILE")
else
  idx=0
fi

# Wrap around
(( idx >= ${#WALLS[@]} )) && idx=0

# Add +1 to the index
idx=$(( (idx + 1) % ${#WALLS[@]} ))

# Set wallpaper
swww img "${WALLS[idx]}" \
  --transition-type grow \
  --transition-pos center \
  --transition-duration 1.5 \
  --transition-fps 60 \
  --transition-bezier 0.54,0,0.34,0.99

# Copy current wallpaper into cache
cp "${WALLS[idx]}" "$CURRENT_WALL"

# Save updated index
printf '%d' "$idx" > "$STATE_FILE"
