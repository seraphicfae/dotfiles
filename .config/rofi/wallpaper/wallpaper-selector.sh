#!/usr/bin/env bash

# Creator : Faye | https://github.com/seraphicfae/dotfiles

WALLPAPER_DIR="$HOME/.config/wallpapers"
CACHE_DIR="$HOME/.cache"
STATE_FILE="$CACHE_DIR/swww_idx"
CURRENT_WALLPAPER="$CACHE_DIR/current_wallpaper"

mkdir -p "$CACHE_DIR"

mapfile -t WALLPAPER_PATHS < <(find "$WALLPAPER_DIR" -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \) | sort)

SELECTED_WALLPAPER=$(
  for path in "${WALLPAPER_PATHS[@]}"; do
    name=$(basename "$path")
    printf '%s\x00icon\x1fthumbnail://%s\n' "$name" "$path"
  done | rofi -dmenu -p "Select Wallpaper" -theme "$HOME/.config/rofi/wallpaper/wallpaper.rasi"
)

for i in "${!WALLPAPER_PATHS[@]}"; do
    if [[ "$(basename "${WALLPAPER_PATHS[$i]}")" == "$SELECTED_WALLPAPER" ]]; then
        SELECTED_PATH="${WALLPAPER_PATHS[$i]}"
        SELECTED_IDX="$i"
        break
    fi
done

if [ -n "$SELECTED_PATH" ]; then
    cp "$SELECTED_PATH" "$CURRENT_WALLPAPER"
    printf '%d' "$SELECTED_IDX" > "$STATE_FILE"

    swww img "$CURRENT_WALLPAPER" \
        --transition-type grow \
        --transition-pos center \
        --transition-duration 1.5 \
        --transition-fps 60 \
        --transition-bezier 0.54,0,0.34,0.99
fi
