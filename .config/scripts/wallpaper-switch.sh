#!/usr/bin/env bash

## Creator: Faye
## Github: https://github.com/seraphicfae/dotfiles

WALL_DIR="$HOME/.config/wallpapers"
STATE_FILE="$HOME/.cache/swww_idx"

mkdir -p "$(dirname "$STATE_FILE")"

# Find a list of wallpapers
mapfile -t WALLS < <(find "$WALL_DIR" -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \) | sort)
[ ${#WALLS[@]} -gt 0 ] || exit 1

# Find current wallpaper
if [[ -r "$STATE_FILE" ]]; then
  idx=$(<"$STATE_FILE")
else
  idx=0
fi

# Wrap around if at the end
(( idx >= ${#WALLS[@]} )) && idx=0

# Wallpaper effects
swww img "${WALLS[idx]}" \
  --transition-type grow \
  --transition-pos center \
  --transition-duration 1.5 \
  --transition-fps 60 \
  --transition-bezier 0.54,0,0.34,0.99

# Cycle-based switching
printf '%d' $(( (idx + 1) % ${#WALLS[@]} )) > "$STATE_FILE"
