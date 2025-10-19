# 🎞️ PNG Sequence → ProRes 4444 Converter (Nautilus Script)

![Shell Script](https://img.shields.io/badge/language-Bash-blue)
![License](https://img.shields.io/badge/license-Free-green)
![Platform](https://img.shields.io/badge/platform-Linux-lightgrey)

## 🧩 Overview

A minimal **Bash + Zenity** script that converts a folder of **numbered PNG images** into a **ProRes 4444 MOV** file — perfect for compositing or editing in **DaVinci Resolve**, **After Effects**, or **Premiere Pro**.

The script automatically detects frame sequences, preserves alpha transparency, and shows friendly **Zenity pop-up dialogs** for progress, errors, and completion messages.

---

## ⚙️ Features

- 🖼️ Converts **PNG sequences** → **ProRes 4444 MOV**
- ✨ Preserves **alpha transparency**
- 💬 Uses **Zenity pop-ups** for GUI feedback**
- 🧠 Automatically prevents **filename conflicts**
- 🖱️ Designed for **right-click use** in GNOME/Nautilus

---

## 🧠 Requirements

Install free dependencies:

```bash
sudo apt install ffmpeg zenity
```

---

## 🚀 Setup (Nautilus Integration)

1. Create your Nautilus scripts folder (if not present):

   ```bash
   mkdir -p ~/.local/share/nautilus/scripts
   ```

2. Save this file as:

   ```
   ~/.local/share/nautilus/scripts/Convert_PNG_Sequence_to_MOV.sh
   ```

3. Make it executable:

   ```bash
   chmod +x ~/.local/share/nautilus/scripts/Convert_PNG_Sequence_to_MOV.sh
   ```

4. Restart Nautilus:

   ```bash
   nautilus -q
   ```

You can now **right-click any folder → Scripts → Convert_PNG_Sequence_to_MOV**.

---

## 🧩 Output Format

| Property | Value |
|-----------|--------|
| **Codec** | `prores_ks` |
| **Profile** | `4 (ProRes 4444)` |
| **Pixel Format** | `yuva444p10le (10-bit + alpha)` |
| **Container** | `.mov` |
| **Frame Rate** | `24 fps` |

---

## 📁 Default Paths

| Type | Path |
|------|------|
| **Input** | Selected folder in Nautilus |
| **Output** | `~/Videos/rendered/` |

Output filenames **auto-increment** to prevent overwriting (e.g., `output.mov`, `output1.mov`, `output2.mov`).

---

## 🧾 Example (Manual Run)

```bash
./Convert_PNG_Sequence_to_MOV.sh ~/Projects/animation_frames/
```

---

## 💡 Notes

- PNG filenames must include frame numbers (e.g., `0001.png`, `0002.png`, `0003.png`, …).
- Uses **Zenity** for intuitive desktop notifications.
- Output is fully compatible with **DaVinci Resolve**, **Premiere Pro**, and **Final Cut Pro**.

---

## ✅ License

**Free to use, modify, and distribute.**

Dependencies:
- FFmpeg
- Zenity

---

> _Created for fast, lossless ProRes 4444 generation from PNG sequences. Ideal for VFX, animation, and post-production workflows._
