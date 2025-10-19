#!/bin/bash

# Relaunch in gnome-terminal if not in terminal
if [[ -z "$PS1" && -z "$GNOME_TERMINAL_SCREEN" ]]; then
    gnome-terminal -- bash -c "\"$0\" \"$*\"; echo; echo 'Press ENTER to close...'; read"
    exit
fi

# === CONFIGURATION ===
INPUT_DIR="${1:-$HOME/Downloads/edit}"
OUTPUT_DIR="$HOME/Videos/output_dnxhr"
LOG_FILE="$OUTPUT_DIR/convert.log"
ENABLE_LOGGING=false

mkdir -p "$OUTPUT_DIR"

# Check dependencies
for cmd in ffmpeg identify; do
    if ! command -v "$cmd" >/dev/null; then
        echo "❌ Required tool '$cmd' is not installed."
        exit 1
    fi
done

# Ask if user wants to enable logging
read -rp "📝 Enable logging to $LOG_FILE? (y/n): " log_choice
if [[ "$log_choice" == [Yy] ]]; then
    ENABLE_LOGGING=true
    echo "📄 Logging enabled: $LOG_FILE"
else
    echo "🚫 Logging disabled"
fi

cd "$INPUT_DIR" || { echo "❌ Failed to access input directory: $INPUT_DIR"; exit 1; }

# === FUNCTION: Rename video files ===
rename_videos() {
    echo "📁 Renaming video files..."
    count=1
    for file in *.mp4 *.mkv; do
        [[ ! -f "$file" ]] && continue
        ext="${file##*.}"
        [[ "$file" =~ ^vid[0-9]+\.(mp4|mkv)$ ]] && continue
        while [[ -e "vid${count}.${ext}" ]]; do ((count++)); done
        mv -- "$file" "vid${count}.${ext}"
        echo "✅ Renamed $file to vid${count}.${ext}"
        ((count++))
    done
}

# === FUNCTION: Convert video files to DNxHR LB ===
convert_videos() {
    echo "🎬 Converting video files..."
    [[ "$ENABLE_LOGGING" == true ]] && echo "=== VIDEO CONVERSION STARTED $(date) ===" >> "$LOG_FILE"

    for file in vid*.mp4 vid*.mkv; do
        [[ ! -f "$file" ]] && continue
        base="${file%.*}"
        out="$OUTPUT_DIR/${base}_dnxhr.mov"

        [[ -f "$out" ]] && { echo "⚠️  Already exists: $out"; continue; }

        duration=$(ffmpeg -i "$file" 2>&1 | grep Duration | awk '{print $2}' | tr -d ,)
        total_sec=$(echo "$duration" | awk -F: '{print ($1*3600)+($2*60)+$3}')

        ffmpeg -hide_banner -y -i "$file" \
            -map 0:v:0 -map 0:a:0? \
            -c:v dnxhd -profile:v dnxhr_lb -pix_fmt yuv420p -threads 0 \
            -c:a pcm_s16le -metadata:s:v:0 rotate=0 "$out" 2>&1 |
        while IFS= read -r line; do
            [[ "$ENABLE_LOGGING" == true ]] && echo "$line" >> "$LOG_FILE"
            if [[ "$line" =~ time=([0-9:.]+) ]]; then
                t="${BASH_REMATCH[1]}"
                sec=$(echo "$t" | awk -F: '{print ($1*3600)+($2*60)+$3}')
                pct=$(echo "$sec * 100 / $total_sec" | bc)
                echo -ne "\r🔄 Progress: ${pct}% (${t})"
            fi
        done

        echo -e "\n✅ Finished: $out"
        [[ "$ENABLE_LOGGING" == true ]] && echo "✅ Finished: $out" >> "$LOG_FILE"
    done

    [[ "$ENABLE_LOGGING" == true ]] && echo "=== VIDEO CONVERSION COMPLETE $(date) ===" >> "$LOG_FILE"
}

# === FUNCTION: Convert PNG sequence to MOV (ProRes for alpha) ===
convert_png_sequence() {
    echo "🖼️ Detected PNG sequence. Converting..."

    shopt -s nullglob
    PNG_FILES=(*.png)
    shopt -u nullglob

    [[ ${#PNG_FILES[@]} -eq 0 ]] && return

    first="${PNG_FILES[0]}"
    ext="${first##*.}"
    start_number=$(echo "$first" | grep -o '[0-9]\+' | head -1)
    read WIDTH HEIGHT < <(identify -format "%w %h" "$first")
    ASPECT="horizontal"
    [[ $HEIGHT -gt $WIDTH ]] && ASPECT="vertical"

    base="png_render_${ASPECT}"
    outfile="$OUTPUT_DIR/${base}.mov"
    counter=1
    while [[ -f "$outfile" ]]; do
        outfile="$OUTPUT_DIR/${base}_${counter}.mov"
        ((counter++))
    done

    echo "🎞️ Creating video from PNGs → $outfile"

    ffmpeg -y -start_number "$start_number" -framerate 24 -i "%04d.$ext" \
        -c:v prores_ks -pix_fmt yuva444p10le -profile:v 4 "$outfile"

    if [[ $? -eq 0 ]]; then
        echo "✅ PNG sequence converted: $outfile"
        [[ "$ENABLE_LOGGING" == true ]] && echo "✅ PNG to MOV: $outfile" >> "$LOG_FILE"
    else
        echo "❌ PNG conversion failed"
        [[ "$ENABLE_LOGGING" == true ]] && echo "❌ PNG conversion failed" >> "$LOG_FILE"
    fi
}

# === MAIN ===
has_videos=false
has_pngs=false

for f in *.mp4 *.mkv; do [[ -f "$f" ]] && has_videos=true && break; done
for f in *.png; do [[ -f "$f" ]] && has_pngs=true && break; done

[[ "$has_videos" == true ]] && rename_videos && convert_videos
[[ "$has_pngs" == true ]] && convert_png_sequence

echo -e "\n🏁 All conversions complete. Output: $OUTPUT_DIR"
[[ "$ENABLE_LOGGING" == true ]] && echo "📄 Log saved to: $LOG_FILE"

