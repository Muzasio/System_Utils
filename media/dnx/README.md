# 🎞️ DNxHR & ProRes Converter (FFmpeg Automation Script)

![Shell Script](https://img.shields.io/badge/language-Bash-blue)
![License](https://img.shields.io/badge/license-Free-green)
![Platform](https://img.shields.io/badge/platform-Linux-lightgrey)

---

## 🧩 Overview

This Bash script automates the conversion of video files (`.mp4` / `.mkv`) and **PNG sequences** into high-quality, post-production-ready formats:

- 🎥 **DNxHR LB MOV** (for lightweight, fast editing)
- 🎨 **ProRes 4444 MOV** (for alpha/PNG sequence renders)

It supports automatic renaming, optional logging, and terminal progress tracking — ideal for quick batch conversions before importing into **DaVinci Resolve**, **Premiere Pro**, or **Avid Media Composer**.

---

## ⚙️ Features

- 🧠 Auto-renames videos (`vid001`, `vid002`, …) for cleaner batch workflow  
- 🎬 Converts to **DNxHR LB MOV (10-bit)**  
- 🖼️ Converts **PNG sequences → ProRes 4444 MOV** (supports alpha)  
- 📝 Optional detailed log file (`convert.log`) in output directory  
- ⏱️ Calculates real-time progress using ffmpeg timestamps  
- 🧭 Auto-detects horizontal/vertical PNG orientation  
- 🔒 Safe overwrite protection — skips already converted files  

---

## 🧠 Requirements

Install these free dependencies first:

```bash
sudo apt install ffmpeg imagemagick gnome-terminal
```

---

## 🚀 Setup (Nautilus Integration)

1. Create your Nautilus scripts folder if it doesn’t exist:

   ```bash
   mkdir -p ~/.local/share/nautilus/scripts
   ```

2. Save the script as:

   ```bash
   ~/.local/share/nautilus/scripts/Convert_to_DNxHR.sh
   ```

3. Make it executable:

   ```bash
   chmod +x ~/.local/share/nautilus/scripts/Convert_to_DNxHR.sh
   ```

4. Restart Nautilus to apply changes:

   ```bash
   nautilus -q
   ```

You can now **right-click any folder or video → Scripts → Convert_to_DNxHR**.

---

## 📁 Default Paths

| Type | Path |
|------|------|
| **Input directory** | `~/Downloads/edit` (can override by passing a custom path) |
| **Output directory** | `~/Videos/output_dnxhr` |
| **Optional log file** | `~/Videos/output_dnxhr/convert.log` |

---

## 🧾 Example Usage

Run manually in terminal:

```bash
./Convert_to_DNxHR.sh ~/Downloads/my_project/
```

Or simply right-click your folder in Nautilus and select the script.

---

## 🧩 Output Formats

### 🎥 For Videos
| Property | Value |
|-----------|--------|
| **Codec** | DNxHR LB |
| **Pixel Format** | yuv420p |
| **Audio** | PCM 16-bit |
| **Extension** | .mov |

### 🖼️ For PNG Sequences
| Property | Value |
|-----------|--------|
| **Codec** | ProRes 4444 |
| **Pixel Format** | yuva444p10le |
| **Transparency** | Supported |

---

## 💡 Tips

- Enable logging (`y`) for troubleshooting or audit trails.  
- Logging captures all ffmpeg output and timestamps.  
- If a file already exists, it’s skipped automatically.  
- You can change the input default path in the script header for your preferred working directory.

---

## ✅ License

**Free to use, modify, and distribute** under an open-source spirit.  
Requires only **FFmpeg**, **ImageMagick**, and **GNOME Terminal** (all free).

---

> _Created for smooth, professional-grade conversions between DNxHR and ProRes formats on Linux._
