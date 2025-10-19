#!/bin/bash

# Get the clicked folder path
FOLDER="$1"

# Output directory
OUTPUT_DIR="$HOME/Videos/rendered"
mkdir -p "$OUTPUT_DIR"  # Ensure output directory exists

# Go to the folder
cd "$FOLDER" || exit 1

# Check for PNGs
if ! ls *.png >/dev/null 2>&1; then
    zenity --error --text="No PNG images found in the selected folder."
    exit 1
fi

# Get sorted list of PNG files
mapfile -t PNG_FILES < <(ls *.png | sort)

# Get the first file
FIRST_FILE="${PNG_FILES[0]}"
EXTENSION="${FIRST_FILE##*.}"

# Extract numeric prefix assuming filenames are like ####.png
START_NUMBER=$(echo "$FIRST_FILE" | grep -o '[0-9]\+' | head -1)

# Determine unique output filename
BASENAME="output"
OUTFILE="$OUTPUT_DIR/$BASENAME.mov"
COUNTER=1
while [[ -f "$OUTFILE" ]]; do
    OUTFILE="$OUTPUT_DIR/${BASENAME}${COUNTER}.mov"
    ((COUNTER++))
done

# Run FFmpeg with ProRes 4444 (supports alpha, Resolve-compatible)
ffmpeg -y -start_number "$START_NUMBER" -framerate 24 -i "%04d.$EXTENSION" \
    -c:v prores_ks -profile:v 4 -pix_fmt yuva444p10le "$OUTFILE"

# Show done message
zenity --info --text="🎉 Video created as: $OUTFILE"

