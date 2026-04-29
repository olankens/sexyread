#!/bin/bash

set -euo pipefail

RES_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../res" && pwd)"
RAW_PATH="$(cd "$RES_PATH/raw" && pwd)"

trim_res_names() {
  local excludes=("variant=" "Variant=")
  find "$RAW_PATH" -type f -print0 | while IFS= read -r -d "" resource; do
    filename="${resource##*/}"
    for exclude in "${excludes[@]}"; do
      filename="${filename//"$exclude"/}"
    done
    mv "$resource" "$RAW_PATH/$(echo "$filename" | tr "[:upper:]" "[:lower:]")"
  done
}

trim_png_files() {
  find "$RAW_PATH" -type f -name "*.png" -print0 | while IFS= read -r -d "" resource; do
    pngquant --quality=65-90 --force --ext .png "$resource"
  done
}

move_raw_files() {
  find "$RAW_PATH" -type f -print0 | while IFS= read -r -d "" resource; do
    [[ "$(basename "$resource")" == .* ]] && continue
    mv -f "$resource" "$RES_PATH/$(basename "$resource")"
  done
}

trim_res_names
trim_png_files
move_raw_files