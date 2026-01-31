# Quick Start Guide - Godot Version
## Panduan Cepat Memulai Project Godot

### 🎯 Langkah-langkah Setup

#### 1. Install Godot
1. Download Godot 4.3+ dari https://godotengine.org/download
2. Extract dan jalankan `Godot_v4.x.exe` (tidak perlu install)
3. Godot siap digunakan!

#### 2. Buka Project
1. Jalankan Godot Engine
2. Klik tombol **"Import"**
3. Klik **"Browse"** dan pilih folder `GGJ-2026-Godot`
4. Pilih file `project.godot`
5. Klik **"Import & Edit"**

#### 3. Explore Project
- **FileSystem Panel** (kiri bawah): Browse files
- **Scene Panel** (kiri atas): Scene hierarchy
- **Inspector** (kanan): Properties
- **Script Editor** (tengah): Edit scripts

#### 4. Test Main Menu
1. Di FileSystem, double-click: `scenes/ui/main_menu.tscn`
2. Tekan `F6` untuk run scene ini
3. Atau tekan `F5` untuk run dari main scene

---

### 📚 Interface Godot

```
┌─────────────────────────────────────────────────────────┐
│  [▶ Run]  [Scene] [Project] [Debug] [Editor] [Help]    │ ← Top Menu
├──────────┬────────────────────────────────┬─────────────┤
│ Scene    │                                │             │
│ ┣ Node   │      Main Viewport            │             │
│ ┃┣Child  │      (Visual Editor)          │  Inspector  │
│ ┃┗Child2 │                                │             │
│          │                                │  Properties │
│ FileSystem│                               │             │
│ ┣ scenes │                                │             │
│ ┣ scripts│                                │             │
│ ┗ assets │                                │             │
└──────────┴────────────────────────────────┴─────────────┘
           │ Output / Debugger / Console                  │
           └──────────────────────────────────────────────┘
```

---

### ⌨️ Shortcuts Penting

| Shortcut | Fungsi |
|----------|--------|
| `F5` | Run Project |
| `F6` | Run Current Scene |
| `F7` | Step Into (Debug) |
| `Ctrl+S` | Save Scene |
| `Ctrl+Shift+S` | Save Scene As |
| `Ctrl+O` | Open Scene |
| `Ctrl+N` | New Scene |
| `Ctrl+D` | Duplicate Node |
| `Ctrl+Z` | Undo |
| `Ctrl+Y` | Redo |
| `Ctrl+F` | Search in Script |
| `Ctrl+Shift+F` | Search in Files |
| `F1` | Documentation |
| `F2` | Rename Node |
| `F3` | Search |

---

### 🎮 Testing Game

#### Run Full Game:
```
1. Tekan F5
2. Game akan start dari main_scene (main_menu.tscn)
3. Test navigasi menu
```

#### Run Specific Scene:
```
1. Buka scene yang ingin ditest
2. Tekan F6
3. Scene langsung jalan
```

#### Debug:
```
1. Set breakpoint: Klik di line number
2. Run dengan F5
3. Debug panel akan muncul
4. Inspect variables di Debugger panel
```

---

### 🔧 Customize Project

#### 1. Setup Autoload (Singleton)
```
Project > Project Settings > Autoload
Add: game_manager.gd
Path: res://scripts/core/game_manager.gd
Singleton Name: GameManager
✓ Enable
```

#### 2. Setup Input Map
```
Project > Project Settings > Input Map
Sudah ada:
- ui_left_click (Mouse Button 1)
- ui_right_click (Mouse Button 2)
- ui_accept (Space/Enter)
- ui_cancel (Escape)

Tambah custom:
1. Ketik action name
2. Klik Add
3. Klik + untuk add key
4. Press key yang diinginkan
```

#### 3. Window Settings
```
Project > Project Settings > Display > Window
- Size: 1920x1080
- Mode: Windowed/Fullscreen
- Stretch Mode: canvas_items
```

---

### 📝 Workflow Development

#### Creating New Scene:
```
1. Scene > New Scene (Ctrl+N)
2. Pilih tipe root node (Node2D untuk gameplay, Control untuk UI)
3. Build hierarchy dengan Add Child Node (+)
4. Save scene (Ctrl+S)
5. Simpan di folder yang sesuai (scenes/...)
```

#### Creating New Script:
```
1. Pilih node di scene
2. Klik icon script atau tekan Ctrl+Shift+C
3. Atau: Attach Script dari Inspector
4. Pilih template atau kosong
5. Save di folder scripts/...
```

#### Adding Assets:
```
1. Copy file ke folder project (assets/...)
2. Godot auto-import
3. Drag & drop ke scene
4. Adjust properties di Inspector
```

---

### 🎨 Next Steps

1. **Import Assets**
   - Copy sprites dari Unity: `Assets/Arts/` → `assets/sprites/`
   - Copy audio: `Assets/Audio/` → `assets/audio/`

2. **Create NPCs**
   - New scene: `scenes/npc/npc_character.tscn`
   - Add Sprite2D, CollisionShape2D
   - Attach script

3. **Build Gameplay**
   - Open `scenes/gameplay/gameplay.tscn`
   - Add player, NPCs, background
   - Implement game logic

4. **Test & Polish**
   - Test dengan F5/F6
   - Debug dengan breakpoints
   - Polish UI & effects

---

### 🆘 Troubleshooting

**Scene tidak load:**
- Check path di project.godot
- Ensure scene file exists
- Check console untuk errors

**Script error:**
- Check syntax (GDScript is Python-like)
- Check indentation (pakai tabs/4 spaces consistent)
- Check variable names (case sensitive)

**Assets tidak muncul:**
- Check import settings
- Re-import: Right-click asset > Reimport
- Check path relatif (res://...)

**Performance issues:**
- Godot seharusnya ringan
- Check infinite loops
- Use profiler: Debug > Profiler

---

### 📖 Learning Resources

- **F1 dalam Godot**: Built-in documentation
- **Godot Docs**: https://docs.godotengine.org/
- **GDScript**: https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/
- **Your First 2D Game**: https://docs.godotengine.org/en/stable/getting_started/first_2d_game/

---

**Selamat coding! Godot jauh lebih ringan dari Unity! 🚀**
