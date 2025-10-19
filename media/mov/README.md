# 🎞️ MOV → DNxHR Converter (FFmpeg Batch Script)

![Shell Script](https://img.shields.io/badge/language-Bash-blue)
![License](https://img.shields.io/badge/license-Free-green)
![Platform](https://img.shields.io/badge/platform-Linux-lightgrey)

## 🧩 Overview

A streamlined **Bash automation script** for converting `.mov` video files into **DNxHR LB format** — optimized for post-production workflows in DaVinci Resolve, Avid, or Premiere Pro.

It automatically renames, processes, and optionally logs each conversion, giving clean, edit-ready outputs without overwriting existing files.

---

## ⚙️ Features

- 🎬 Batch converts `.mov` files → **DNxHR LB MOV**
- 🧾 Auto-renames inputs (`mov001.mov`, `mov002.mov`, …)
- 📈 Displays real-time progress during conversion
- 🪵 Optional logging to a timestamped file
- 🛡️ Prevents overwriting existing exports
- 🖱️ Works standalone or via **Nautilus right-click**

---

## 🧠 Requirements

Install free dependencies (standard on most Linux systems):

```bash
sudo apt install ffmpeg imagemagick gnome-terminal
```

---

## 🚀 Setup (for Nautilus Integration)

1. Create the Nautilus scripts folder:

   ```bash
   mkdir -p ~/.local/share/nautilus/scripts
   ```

2. Save this file as:

   ```bash
   ~/.local/share/nautilus/scripts/Convert_MOV_to_DNxHR.sh
   ```

3. Make it executable:

   ```bash
   chmod +x ~/.local/share/nautilus/scripts/Convert_MOV_to_DNxHR.sh
   ```

4. Restart Nautilus:

   ```bash
   nautilus -q
   ```

You can now **right-click a folder or MOV file → Scripts → Convert_MOV_to_DNxHR**.

---

## 📁 Default Paths

| Type | Path |
|------|------|
| **Input directory** | `~/Downloads/edit` |
| **Output directory** | `~/Videos/output_mov_dnxhr` |
| **Optional log file** | `~/Videos/output_mov_dnxhr/convert_mov.log` |

---

## 🧩 Output Format

| Property | Value |
|-----------|--------|
| **Codec** | DNxHR LB |
| **Pixel Format** | yuv420p |
| **Audio** | PCM 16-bit |
| **Container** | .mov |
| **Metadata** | Rotation reset (`rotate=0`) |

---

## 🧾 Example Usage

Run manually:

```bash
./Convert_MOV_to_DNxHR.sh ~/Downloads/edit
```

Or just **drag and drop** a MOV folder onto the script.

---

## 💡 Notes

- 🪵 Logging is optional — enable when prompted (`y/n`).
- 🧩 Existing converted files are skipped safely.
- ⚙️ Uses CPU multithreading for faster conversion.
- 📊 Automatically calculates and displays completion percentage.

---

## ✅ License

**Completely free to use and modify.**  
Requires only open-source tools: **FFmpeg**, **ImageMagick**, and **GNOME Terminal**.
