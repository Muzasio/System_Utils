# 🎥 Enterprise YouTube Downloader (User-Level Edition)

![Shell Script](https://img.shields.io/badge/language-Bash-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Platform](https://img.shields.io/badge/platform-Linux-lightgrey)

## 🧩 Overview

A fully automated, **non-root YouTube downloader** for Linux.  
Designed for beginners who want a **professional, secure, and log-backed downloading experience** — without requiring administrative privileges.

---

## 📦 Features

- 🚫 Works **without sudo/root**
- 🔁 Automatic retries & structured logging
- 🎧 Supports **Video+Audio** and **Audio-only** modes
- 📂 Creates organized directories under `~/Downloads/youtube_downloads/`
- 🧩 Built-in **dependency check** and **update hints**
- 🧾 Human-readable logs in `~/Downloads/youtube_downloads/logs`
- 🧠 Smart retry logic and graceful error handling

---

## 🧰 Requirements

### Install the required tools (user-level, free):

```bash
python3 -m pip install --user yt-dlp
sudo apt install ffmpeg -y   # or use flatpak/snap if sudo not available
```

Dependencies:
- yt-dlp (YouTube downloader)
- ffmpeg (media merger and converter)

---

## 🚀 Usage

1. Save the script as:
   ```bash
   yt_downloader.sh
   ```

2. Make it executable:
   ```bash
   chmod +x yt_downloader.sh
   ```

3. Run:
   ```bash
   ./yt_downloader.sh
   ```

---

## 🎬 Options

When prompted:

```
1 → Download Video + Audio (MP4)
2 → Download Audio Only (MP3)
```

All downloads are saved in:

```
~/Downloads/youtube_downloads/
```

---

## 🪶 Configuration

Default configuration file:

```
~/.yt_downloader.conf
```

You can customize parameters inside it:

```
DEFAULT_VIDEO_FORMAT="mp4"
DEFAULT_AUDIO_FORMAT="mp3"
DEFAULT_DOWNLOAD_DIR="$HOME/Downloads/youtube_downloads"
```

---

## 📋 Logs

All operations are logged in:

```
~/Downloads/youtube_downloads/logs/yt_downloader.log
```

Logs include timestamps, retry attempts, and success/failure messages.

---

## 🔒 Notes

- Runs entirely in **user space** (no root privileges required)
- Does **not** modify system files
- Ideal for **educational, personal, or archival** purposes
- Uses **retry-based fault tolerance** for unstable connections

---

## 📖 License

**MIT License** — Open-source, free to use, modify, and extend.

> _Built for privacy-conscious users and Linux learners who want reliable YouTube downloads without compromising system integrity._
