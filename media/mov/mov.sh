#!/bin/bash

# Relaunch in gnome-terminal if not in terminal
if [[ -z "$PS1" && -z "$GNOME_TERMINAL_SCREEN" ]]; then
    gnome-terminal -- bash -c "\"$0\" \"$*\"; echo; echo 'Press ENTER to close...'; read"
    exit
fi

# === CONFIGURATION ===
INPUT_DIR="${1:-$HOME/Downloads/edit}"
OUTPUT_DIR="$HOME/Videos/output_mov_dnxhr"
LOG_FILE="$OUTPUT_DIR/convert_mov.log"
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

# === FUNCTION: Rename MOV video files ===
rename_videos() {
    echo "📁 Renaming MOV video files..."
    count=1
    for file in *.mov; do
        [[ ! -f "$file" ]] && continue
        ext="${file##*.}"
        [[ "$file" =~ ^mov[0-9]+\.mov$ ]] && continue
        while [[ -e "mov${count}.${ext}" ]]; do ((count++)); done
        mv -- "$file" "mov${count}.${ext}"
        echo "✅ Renamed $file to mov${count}.${ext}"
        ((count++))
    done
}

# === FUNCTION: Convert MOV files to DNxHR LB ===
convert_videos() {
    echo "🎬 Converting MOV files..."
    [[ "$ENABLE_LOGGING" == true ]] && echo "=== MOV CONVERSION STARTED $(date) ===" >> "$LOG_FILE"

    for file in mov*.mov; do
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

    [[ "$ENABLE_LOGGING" == true ]] && echo "=== MOV CONVERSION COMPLETE $(date) ===" >> "$LOG_FILE"
}

# === MAIN ===
has_movs=false
for f in *.mov; do [[ -f "$f" ]] && has_movs=true && break; done

[[ "$has_movs" == true ]] && rename_videos && convert_videos

echo -e "\n🏁 All MOV conversions complete. Output: $OUTPUT_DIR"
[[ "$ENABLE_LOGGING" == true ]] && echo "📄 Log saved to: $LOG_FILE"

