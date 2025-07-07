#!/usr/bin/env bash

## Creator: Faye
## Github: https://github.com/seraphicfae/dotfiles

# Wallpaper directory
WALL_DIR="$HOME/.config/wallpapers"
CACHE_DIR="$HOME/.cache"
STATE_FILE="$CACHE_DIR/swww_idx"
CURRENT_WALL="$CACHE_DIR/current_wallpaper"

mkdir -p "$CACHE_DIR"

# Get list of wallpapers
mapfile -t WALL_PATHS < <(find "$WALL_DIR" -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \) | sort)

# Cancel if no wallpapers
if [ ${#WALL_PATHS[@]} -eq 0 ]; then
  notify-send "No wallpapers found in $WALL_DIR"
  exit 1
fi

# Get the file names
WALL_NAMES=()
for path in "${WALL_PATHS[@]}"; do
    WALL_NAMES+=("$(basename "$path")")
done

# Show list with rofi
SELECTED_NAME=$(printf '%s\n' "${WALL_NAMES[@]}" | rofi -dmenu -p "Select Wallpaper" -theme "$HOME/.config/rofi/wallpaper/wallpaper.rasi")

# Match selected name to full path and index
for i in "${!WALL_NAMES[@]}"; do
    if [[ "${WALL_NAMES[$i]}" == "$SELECTED_NAME" ]]; then
        SELECTED_PATH="${WALL_PATHS[$i]}"
        SELECTED_IDX="$i"
        break
    fi
done

# Apply and store state
if [ -n "$SELECTED_PATH" ]; then
    cp "$SELECTED_PATH" "$CURRENT_WALL"
    printf '%d' "$SELECTED_IDX" > "$STATE_FILE"

    swww img "$CURRENT_WALL" \
        --transition-type grow \
        --transition-pos center \
        --transition-duration 1.5 \
        --transition-fps 60 \
        --transition-bezier 0.54,0,0.34,0.99
fi
