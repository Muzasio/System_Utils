# 🎞️ ProRes 4444 Converter (FFmpeg + Nautilus Script)

![Shell Script](https://img.shields.io/badge/language-Bash-blue)
![License](https://img.shields.io/badge/license-Free-green)
![Platform](https://img.shields.io/badge/platform-Linux-lightgrey)

## 🧩 Overview

A simple **Nautilus (right-click)** Bash script to convert videos (`.mp4`, `.avi`) or **PNG image sequences** into **Apple ProRes 4444 MOV** files — ready for DaVinci Resolve or any professional NLE.

The script automatically:
- Launches in a terminal
- Checks dependencies
- Organizes outputs into:
  ```
  ~/Videos/output_prores/
  ```

---

## ⚙️ Features

- 🎬 Converts `.mp4` / `.avi` → **ProRes 4444 MOV**
- 🖼️ Converts **PNG sequences** → ProRes 4444 MOV (auto-detects frame numbers)
- 🔊 Preserves audio (if present)
- 🧠 Handles duplicates and existing files gracefully
- 🖱️ Designed for **drag-and-drop** or **right-click use** in GNOME/Nautilus

---

## 🧠 Requirements

Install these tools (both free):

```bash
sudo apt install ffmpeg imagemagick
```

---

## 🚀 Setup (Nautilus Integration)

1. Create your Nautilus scripts folder (if not present):

   ```bash
   mkdir -p ~/.local/share/nautilus/scripts
   ```

2. Save the script as:

   ```
   ~/.local/share/nautilus/scripts/Convert_to_ProRes.sh
   ```

3. Make it executable:

   ```bash
   chmod +x ~/.local/share/nautilus/scripts/Convert_to_ProRes.sh
   ```

4. Restart Nautilus to apply changes:

   ```bash
   nautilus -q
   ```

You can now **right-click any video or folder → Scripts → Convert_to_ProRes**.

---

## 🧩 Output Format

| Property | Value |
|-----------|--------|
| **Codec** | `prores_ks` |
| **Profile** | `4 (ProRes 4444)` |
| **Pixel Format** | `yuva444p10le` |
| **Audio** | `PCM 16-bit` |

---

## 📁 Output Location

All converted files are stored in:

```
~/Videos/output_prores/
```

Existing outputs are **skipped automatically**.

---

## 🧾 Notes

- PNG sequence conversion assumes frame numbering:
  ```
  0001.png, 0002.png, 0003.png, …
  ```
- Compatible with **DaVinci Resolve**, **Premiere Pro**, and **Final Cut Pro**.
- Requires **no root access** and runs entirely in user space.

---

## 🧑‍💻 Example (Manual Run)

```bash
./Convert_to_ProRes.sh ~/Videos/my_clip.mp4
./Convert_to_ProRes.sh ~/Projects/animation_frames/
```

---

## ✅ License

**Free to use, modify, and distribute.**

Dependencies:
- FFmpeg
- ImageMagick

---

> _Created for fast and lossless ProRes 4444 conversion on Linux. Ideal for VFX, compositing, and post-production workflows._
