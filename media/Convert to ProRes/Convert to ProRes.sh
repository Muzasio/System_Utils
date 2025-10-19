#!/bin/bash

# Nautilus script to convert video (MP4/AVI) or PNG sequences to ProRes 4444 for DaVinci Resolve

# Relaunch in gnome-terminal if not in terminal
if [[ -z "$PS1" && -z "$GNOME_TERMINAL_SCREEN" ]]; then
    gnome-terminal -- bash -c "\"$0\" \"$*\"; echo; echo 'Press ENTER to close...'; read"
    exit
fi

# === CONFIGURATION ===
INPUT="$1"  # Can be a single file or a folder
OUTPUT_DIR="$HOME/Videos/output_prores"
mkdir -p "$OUTPUT_DIR"

# Check dependencies
for cmd in ffmpeg identify; do
    if ! command -v "$cmd" >/dev/null; then
        echo "❌ Required tool '$cmd' is not installed."
        exit 1
    fi
done

# === FUNCTION: Convert a single video file to ProRes 4444 ===
convert_single_video() {
    file="$1"
    base=$(basename "$file")
    name="${base%.*}"
    out="$OUTPUT_DIR/${name}_prores.mov"

    if [[ -f "$out" ]]; then
        echo "⚠️  Already exists: $out"
        return
    fi

    echo "🎬 Converting $file → $out"

    ffmpeg -hide_banner -y -i "$file" \
        -map 0:v:0 -map 0:a:0? \
        -c:v prores_ks -profile:v 4 -pix_fmt yuva444p10le \
        -c:a pcm_s16le "$out"

    if [[ $? -eq 0 ]]; then
        echo "✅ Finished: $out"
    else
        echo "❌ Failed: $file"
    fi
}

# === FUNCTION: Convert PNG sequence to ProRes 4444 ===
convert_png_sequence() {
    folder="$1"
    cd "$folder" || return

    shopt -s nullglob
    PNG_FILES=(*.png)
    shopt -u nullglob

    [[ ${#PNG_FILES[@]} -eq 0 ]] && return

    first="${PNG_FILES[0]}"
    ext="${first##*.}"
    start_number=$(echo "$first" | grep -o '[0-9]\+' | head -1)
    base=$(basename "$folder")
    outfile="$OUTPUT_DIR/${base}_sequence_prores.mov"
    counter=1
    while [[ -f "$outfile" ]]; do
        outfile="$OUTPUT_DIR/${base}_sequence_prores_${counter}.mov"
        ((counter++))
    done

    echo "🎞️ Creating video from PNGs in $folder → $outfile"

    ffmpeg -y -start_number "$start_number" -framerate 24 -i "%04d.$ext" \
        -c:v prores_ks -pix_fmt yuva444p10le -profile:v 4 "$outfile"

    if [[ $? -eq 0 ]]; then
        echo "✅ PNG sequence converted: $outfile"
    else
        echo "❌ PNG conversion failed in $folder"
    fi
}

# === MAIN ===
if [[ -d "$INPUT" ]]; then
    # Input is a folder
    echo "📂 Processing folder: $INPUT"
    cd "$INPUT" || exit 1

    has_videos=false
    has_pngs=false

    for f in *.mp4 *.avi; do [[ -f "$f" ]] && has_videos=true && break; done
    for f in *.png; do [[ -f "$f" ]] && has_pngs=true && break; done

    if [[ "$has_videos" == true ]]; then
        for v in *.mp4 *.avi; do
            [[ -f "$v" ]] && convert_single_video "$v"
        done
    fi

    if [[ "$has_pngs" == true ]]; then
        convert_png_sequence "$INPUT"
    fi

else
    # Input is a single file
    case "$INPUT" in
        *.mp4|*.avi) convert_single_video "$INPUT" ;;
        *) echo "❌ Unsupported input: $INPUT" ;;
    esac
fi

echo -e "\n🏁 All conversions complete. Output: $OUTPUT_DIR"

