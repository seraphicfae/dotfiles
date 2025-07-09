#!/usr/bin/env bash

# Creator : Faye | https://github.com/seraphicfae/dotfiles

WALL_DIR="$HOME/.config/wallpapers"
STATE_FILE="$HOME/.cache/swww_idx"
CURRENT_WALL="$HOME/.cache/current_wallpaper"

mkdir -p "$(dirname "$STATE_FILE")"

mapfile -t WALLS < <(find "$WALL_DIR" -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \) | sort)
[ ${#WALLS[@]} -gt 0 ] || exit 1

if [[ -r "$STATE_FILE" ]]; then
  idx=$(<"$STATE_FILE")
else
  idx=0
fi

(( idx >= ${#WALLS[@]} )) && idx=0
idx=$(( (idx + 1) % ${#WALLS[@]} ))

swww img "${WALLS[idx]}" \
  --transition-type grow \
  --transition-pos center \
  --transition-duration 1.5 \
  --transition-fps 60 \
  --transition-bezier 0.54,0,0.34,0.99

cp "${WALLS[idx]}" "$CURRENT_WALL"

printf '%d' "$idx" > "$STATE_FILE"
