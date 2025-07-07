#!/usr/bin/env bash

## Creator: Faye
## Github: https://github.com/seraphicfae/dotfiles

# Wallpaper directory
WALL_DIR="$HOME/.config/wallpapers"
CACHE_DIR="$HOME/.cache"

# Get the list of wallpapers (full paths)
mapfile -t WALL_PATHS < <(find "$WALL_DIR" -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \) | sort)

# List the names of the wallpapers
WALL_NAMES=()
for path in "${WALL_PATHS[@]}"; do
    WALL_NAMES+=("$(basename "$path")")
done

# Rofi for selecting wallpapers
SELECTED_NAME=$(printf '%s\n' "${WALL_NAMES[@]}" | rofi -dmenu -p "Select Wallpaper" -theme "$HOME/.config/rofi/wallpaper/wallpaper.rasi")

# Match selected name to full path
for i in "${!WALL_NAMES[@]}"; do
    if [[ "${WALL_NAMES[$i]}" == "$SELECTED_NAME" ]]; then
        SELECTED_PATH="${WALL_PATHS[$i]}"
        break
    fi
done

# Apply the wallpaper
if [ -n "$SELECTED_PATH" ]; then
    cp "$SELECTED_PATH" "$CACHE_DIR/current_wallpaper"
    swww img "$CACHE_DIR/current_wallpaper" \
        --transition-type grow \
        --transition-pos center \
        --transition-duration 1.5 \
        --transition-fps 60 \
        --transition-bezier 0.54,0,0.34,0.99
fi
