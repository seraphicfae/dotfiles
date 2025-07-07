#!/usr/bin/env bash

## Creator: Faye
## Github: https://github.com/seraphicfae/dotfiles

WALL_DIR="$HOME/.config/wallpapers"
STATE_FILE="$HOME/.cache/swww_idx"
CURRENT_WALL="$HOME/.cache/current_wallpaper"

mkdir -p "$(dirname "$STATE_FILE")"

mapfile -t WALLS < <(find "$WALL_DIR" -type f | sort)
[ ${#WALLS[@]} -gt 0 ] || exit 1

if [[ -r "$STATE_FILE" ]]; then
  idx=$(<"$STATE_FILE")
else
  idx=0
fi

(( idx >= ${#WALLS[@]} )) && idx=0

# Set wallpaper
swww img "${WALLS[idx]}" \
  --transition-type grow \
  --transition-pos center \
  --transition-duration 1.5 \
  --transition-fps 60 \
  --transition-bezier 0.54,0,0.34,0.99

# Copy the full image (any format) into cache
cp "${WALLS[idx]}" "$CURRENT_WALL"

# Advance index
printf '%d' $(( (idx + 1) % ${#WALLS[@]} )) > "$STATE_FILE"
