#!/usr/bin/env bash

# Creator : Faye | https://github.com/seraphicfae/dotfiles

WALLPAPER_DIR="$HOME/.config/wallpapers"
CACHE_DIR="$HOME/.cache"
STATE_FILE="$CACHE_DIR/swww_idx"
CURRENT_WALLPAPER="$CACHE_DIR/current_wallpaper"

mkdir -p "$CACHE_DIR"

mapfile -t WALLPAPER_PATHS < <(find "$WALLPAPER_DIR" -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \) | sort)

if [ ${#WALLPAPER_PATHS[@]} -eq 0 ]; then
  notify-send "No wallpapers found in $WALLPAPER_DIR"
  exit 1
fi

WALLPAPER_NAMES=()
for path in "${WALLPAPER_PATHS[@]}"; do
    WALLPAPER_NAMES+=("$(basename "$path")")
done

SELECTED_NAME=$(printf '%s\n' "${WALLPAPER_NAMES[@]}" | rofi -dmenu -p "Select Wallpaper" -theme "$HOME/.config/rofi/wallpaper/wallpaper.rasi")

for i in "${!WALLPAPER_NAMES[@]}"; do
    if [[ "${WALLPAPER_NAMES[$i]}" == "$SELECTED_NAME" ]]; then
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
