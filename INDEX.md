# 📖 Documentation Index
## Panduan Lengkap Project GGJ 2026 - Godot Version

Selamat datang di project Godot! Ini adalah konversi dari Unity ke Godot Engine.

---

## 🚀 Mulai Cepat

**Baru pertama kali pakai Godot?** Mulai dari sini:

1. **[QUICK_START.md](QUICK_START.md)** ⭐
   - Install Godot
   - Buka project
   - Interface overview
   - Shortcuts penting
   - Testing game

2. **[README.md](README.md)**
   - Overview project
   - Struktur folder
   - Sistem yang sudah dikonversi
   - Next steps

---

## 📚 Panduan Teknis

### Untuk Developer Unity

3. **[CONVERSION_GUIDE.md](CONVERSION_GUIDE.md)** ⭐⭐⭐
   - Mapping Unity → Godot
   - Lifecycle methods
   - Input system
   - Signals vs Events
   - Scene management
   - **WAJIB BACA!**

4. **[GDSCRIPT_CHEATSHEET.md](GDSCRIPT_CHEATSHEET.md)** ⭐⭐
   - Syntax reference
   - Common patterns
   - Best practices
   - Quick reference

### Struktur & Organisasi

5. **[STRUCTURE.md](STRUCTURE.md)**
   - File organization
   - Folder structure
   - Naming conventions
   - Best practices

6. **[TODO.md](TODO.md)**
   - Task list
   - Completed items
   - In progress
   - Missing features

---

## 🎯 Referensi Cepat

### Membuat Scene Baru
```
1. Scene > New Scene (Ctrl+N)
2. Pilih root node type
3. Add child nodes
4. Save (Ctrl+S)
```

### Membuat Script Baru
```
1. Pilih node
2. Attach Script (icon script)
3. Choose template
4. Save
```

### Import Assets
```
1. Copy files ke folder assets/
2. Godot auto-import
3. Drag & drop ke scene
```

### Run Game
```
F5  - Run project
F6  - Run current scene
F7  - Debug step
```

---

## 📂 File Locations

### Scripts
```
scripts/
├── core/          - GameManager
├── tools/         - Tool system
├── npc/           - NPC management
├── ui/            - UI controllers
├── cutscene/      - Cutscenes
├── transitions/   - Scene transitions
└── ending/        - Ending logic
```

### Scenes
```
scenes/
├── ui/            - Menu, settings, UI
├── gameplay/      - Main gameplay
├── npc/           - NPC characters
├── tools/         - Tool objects
├── cutscene/      - Cutscene scenes
└── endings/       - Ending scenes
```

### Assets (to be added)
```
assets/
├── sprites/       - Images
├── audio/         - Sounds & music
└── fonts/         - Typography
```

---

## 🔍 Troubleshooting

### Scene tidak load
- Check `project.godot` main_scene path
- Ensure scene file exists
- Check console for errors

### Script error
- GDScript is indentation-sensitive
- Check variable names (case sensitive)
- Use F1 for built-in help

### Asset tidak muncul
- Check import settings
- Right-click > Reimport
- Verify file path (res://...)

---

## 🆘 Butuh Bantuan?

### Dokumentasi Resmi
- **Godot Docs**: https://docs.godotengine.org/
- **GDScript Tutorial**: https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/
- **Unity to Godot**: https://docs.godotengine.org/en/stable/tutorials/best_practices/unity_to_godot.html

### In-Editor Help
- Tekan **F1** di Godot untuk built-in documentation
- Search class/function names
- Includes code examples

### Community
- **Godot Discord**: https://discord.gg/godotengine
- **Reddit**: r/godot
- **Forum**: https://forum.godotengine.org/

---

## 📖 Reading Order (Recommended)

### Jika Anda Baru di Godot:

```
1. QUICK_START.md      ← Install & setup
2. README.md           ← Project overview
3. CONVERSION_GUIDE.md ← Unity → Godot mapping
4. GDSCRIPT_CHEATSHEET.md ← Coding reference
5. STRUCTURE.md        ← File organization
6. TODO.md             ← What's next
```

### Jika Sudah Familiar dengan Godot:

```
1. README.md           ← Project overview
2. TODO.md             ← Current tasks
3. STRUCTURE.md        ← File locations
4. Code files          ← Dive in!
```

---

## 🎮 Project Overview

### Game Type
- **Genre**: [Describe your game]
- **Engine**: Godot 4.3+
- **Language**: GDScript
- **Platform**: PC (Windows/Linux/Mac)

### Core Systems Implemented

✅ **GameManager** - State management
✅ **Tool System** - Player tools (magnifying glass, etc)
✅ **NPC System** - Queue controller
✅ **UI System** - Menus, buttons, settings
✅ **Cutscene System** - Dialog & events
✅ **Transition System** - Scene fades
✅ **Ending System** - Multiple endings
✅ **Audio System** - Settings & playback

### To Be Implemented

- [ ] Gameplay mechanics
- [ ] Character sprites
- [ ] Audio assets
- [ ] UI polish
- [ ] More tools
- [ ] Full game loop

---

## 💡 Tips

### Development Workflow
1. Create scene
2. Add nodes
3. Attach scripts
4. Test with F6
5. Iterate

### Performance
- Godot is lighter than Unity
- Profile with Debugger > Profiler
- Use object pooling for frequent spawns

### Version Control
- `.gitignore` already configured
- `.tscn` files are text-based (mergeable!)
- Commit often

### Learning Resources
- **Official tutorials** in Godot docs
- **GDQuest** on YouTube
- **HeartBeast** tutorials
- Built-in demos: Help > Download Assets

---

## 🎯 Quick Goals

### Short Term (1-2 days)
- [ ] Import assets dari Unity
- [ ] Setup GameManager autoload
- [ ] Create player character scene
- [ ] Basic movement

### Medium Term (1 week)
- [ ] Implement core gameplay
- [ ] Add all tools
- [ ] Create NPC behaviors
- [ ] Build UI

### Long Term (2+ weeks)
- [ ] Polish & effects
- [ ] Sound design
- [ ] Testing & debugging
- [ ] Build & deploy

---

## 📝 Version History

- **v0.1.0** - Initial Godot conversion
  - All Unity scripts converted to GDScript
  - Basic scene structure
  - Complete documentation

---

## 🙏 Credits

**Original Unity Project**: GGJ 2026 - Kelompok 10
**Godot Conversion**: [Your Name]
**Engine**: Godot Engine 4.3

---

## 📜 License

See [LICENSE](LICENSE) file for details.

---

**Selamat berkembang dengan Godot! 🚀**

Remember: Godot is lighter, faster, and more fun than Unity! Enjoy! 😊
