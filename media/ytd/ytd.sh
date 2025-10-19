#!/bin/bash

# === Enterprise YouTube Downloader ===
# Modified to run without administrative privileges

# === Configuration ===
VERSION="2.3.2"
DOWNLOAD_DIR="$HOME/Downloads/youtube_downloads"
LOG_DIR="$DOWNLOAD_DIR/logs"
CONFIG_FILE="$HOME/.yt_downloader.conf"
MAX_RETRIES=3
RETRY_DELAY=5

# Create necessary directories in user space
mkdir -p "$DOWNLOAD_DIR" "$LOG_DIR"

# === Enhanced Logging Function ===
log_message() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] $1" >> "$LOG_DIR/yt_downloader.log"
}

# === Error Handling Function ===
handle_error() {
    log_message "ERROR: $1"
    echo "❌ Error: $1" >&2
    exit 1
}

# === Check Dependencies ===
check_dependencies() {
    local missing_deps=()
    
    if ! command -v yt-dlp &> /dev/null; then
        missing_deps+=("yt-dlp")
    fi
    
    if ! command -v ffmpeg &> /dev/null; then
        missing_deps+=("ffmpeg")
    fi
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        handle_error "Missing dependencies: ${missing_deps[*]}.\nPlease install them using the user-level installation methods."
    fi
}

# === Load Configuration ===
load_config() {
    if [ -f "$CONFIG_FILE" ]; then
        source "$CONFIG_FILE"
        log_message "Configuration loaded from $CONFIG_FILE"
    else
        # Create default config
        cat > "$CONFIG_FILE" << EOF
# YouTube Downloader Configuration
DEFAULT_DOWNLOAD_DIR="$DOWNLOAD_DIR"
DEFAULT_FORMAT="video+audio"
DEFAULT_AUDIO_FORMAT="mp3"
DEFAULT_VIDEO_FORMAT="mp4"
EOF
        log_message "Created default configuration file: $CONFIG_FILE"
    fi
}

# === Validate URL ===
validate_url() {
    local url_pattern='^(https?://)?(www\.)?(youtube|youtu)\.(com|be)/.+$'
    if [[ ! $1 =~ $url_pattern ]]; then
        handle_error "Invalid YouTube URL: $1"
    fi
}

# === Download with retry logic ===
download_with_retry() {
    local url=$1
    local options=$2
    local format=$3
    local attempt=1
    local success=0
    
    while [ $attempt -le $MAX_RETRIES ]; do
        log_message "Download attempt $attempt for URL: $url (Format: $format)"
        echo "Downloading... (Attempt $attempt of $MAX_RETRIES)"
        
        # Use eval to properly handle complex options with quotes
        if eval "yt-dlp $options \"$url\""; then
            success=1
            break
        else
            log_message "Attempt $attempt failed. Retrying in $RETRY_DELAY seconds..."
            echo "⚠️  Download failed. Retrying in $RETRY_DELAY seconds..."
            sleep $RETRY_DELAY
            ((attempt++))
        fi
    done
    
    if [ $success -eq 0 ]; then
        handle_error "Failed to download after $MAX_RETRIES attempts: $url"
    fi
    
    return $success
}

# === Get Best Video and Audio Formats ===
get_best_formats() {
    local url=$1
    log_message "Getting available formats for: $url"
    
    # Use yt-dlp's built-in format selection instead of parsing
    # This avoids the syntax error from malformed format strings
    echo "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best"
}

# === Download Video + Audio ===
download_video_audio() {
    local url=$1
    log_message "Starting video+audio download for: $url"
    echo "Downloading video with audio..."
    
    cd "$DOWNLOAD_DIR"
    
    # Get the format selector
    local format_selector=$(get_best_formats "$url")
    
    log_message "Using format selector: $format_selector"
    echo "Selected format: $format_selector"
    
    # Download and merge using the selected formats
    download_with_retry "$url" \
        "--format \"$format_selector\" --merge-output-format \"$DEFAULT_VIDEO_FORMAT\" -o \"%(title)s.%(ext)s\"" \
        "video+audio"
    
    cd - > /dev/null
    log_message "Video+audio download completed: $url"
}

# === Download Audio Only ===
download_audio_only() {
    local url=$1
    log_message "Starting audio-only download for: $url"
    echo "Downloading audio only..."
    
    cd "$DOWNLOAD_DIR"
    
    download_with_retry "$url" \
        "--extract-audio --audio-format \"$DEFAULT_AUDIO_FORMAT\" -o \"%(title)s.%(ext)s\"" \
        "audio-only"
    
    cd - > /dev/null
    log_message "Audio-only download completed: $url"
}

# === Display Download Directory ===
show_download_dir() {
    echo ""
    echo "📁 Download directory: $DOWNLOAD_DIR"
    echo "📁 Contents:"
    echo "=============================================="
    ls -la "$DOWNLOAD_DIR"
    echo "=============================================="
    echo "Total files: $(ls -1 "$DOWNLOAD_DIR" | wc -l)"
}

# === Debug Information ===
show_debug_info() {
    echo ""
    echo "🔍 Debug Information:"
    echo "----------------------------------------------"
    echo "yt-dlp version: $(yt-dlp --version 2>/dev/null || echo 'Unknown')"
    echo "ffmpeg version: $(ffmpeg -version 2>/dev/null | head -n1 || echo 'Not available')"
    echo "Download directory: $DOWNLOAD_DIR"
    echo "Free space: $(df -h "$DOWNLOAD_DIR" | awk 'NR==2 {print $4}')"
    echo "----------------------------------------------"
}

# === Simplified Update Check ===
check_for_updates() {
    echo "Checking yt-dlp version..."
    local current_version=$(yt-dlp --version 2>/dev/null || echo "Unknown")
    echo "✅ Current yt-dlp version: $current_version"
    echo "💡 To update, run: python3 -m pip install --user -U yt-dlp"
}

# === Main Execution ===
main() {
    clear
    echo "=============================================="
    echo "      Enterprise YouTube Downloader v$VERSION"
    echo "     (Modified for non-admin use)"
    echo "=============================================="
    echo ""
    
    # Check dependencies
    check_dependencies
    
    # Check version without attempting system update
    check_for_updates
    
    # Show debug information
    show_debug_info
    echo ""
    
    # Load configuration
    load_config
    
    # Get YouTube URL
    read -p "📺 Enter YouTube URL: " URL
    if [ -z "$URL" ]; then
        handle_error "No URL provided"
    fi
    
    # Validate URL
    validate_url "$URL"
    
    # Test if we can access the URL
    echo "Checking URL accessibility..."
    if ! yt-dlp --simulate --quiet "$URL" >/dev/null 2>&1; then
        echo "⚠️  Cannot access URL directly. Trying with alternative methods..."
        read -p "Continue with download anyway? (y/n): " CONTINUE
        if [[ ! $CONTINUE =~ ^[Yy]$ ]]; then
            handle_error "Cannot access URL. Please check the URL and your internet connection."
        fi
    fi
    
    # Select download format
    echo ""
    echo "Select download format:"
    echo "1) Video + Audio (MP4)"
    echo "2) Audio Only (MP3)"
    read -p "Enter choice [1-2]: " CHOICE
    
    case $CHOICE in
        1)
            download_video_audio "$URL"
            ;;
        2)
            download_audio_only "$URL"
            ;;
        *)
            handle_error "Invalid choice: $CHOICE"
            ;;
    esac
    
    # Show download directory contents
    show_download_dir
    
    log_message "Download completed successfully: $URL"
    echo ""
    echo "✅ Download complete! Files saved to: $DOWNLOAD_DIR"
}

# Enhanced error handling using trap
trap 'echo ""; echo "Script interrupted by user"; log_message "Script interrupted by user"; exit 1' INT
trap 'handle_error "Error occurred at line $LINENO. Check logs for details."' ERR

# Execute main function
main "$@"
