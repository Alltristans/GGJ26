# GGJ 2026 - Kelompok 10 (Godot Version)

Project game Global Game Jam 2026 Kelompok 10 yang telah dikonversi dari Unity ke Godot 4.3.

## 🎮 Tentang Project

Project ini adalah konversi dari Unity Engine ke Godot Engine untuk performa yang lebih ringan dan efisien.

## 📁 Struktur Project

```
GGJ-2026-Godot/
├── project.godot          # File konfigurasi project Godot
├── icon.svg              # Icon project
├── scenes/               # Semua scene files (.tscn)
│   ├── ui/              # UI scenes
│   │   └── main_menu.tscn
│   ├── gameplay/        # Gameplay scenes
│   │   └── gameplay.tscn
│   └── endings/         # Ending scenes
├── scripts/             # Semua GDScript files (.gd)
│   ├── core/           # Core systems
│   │   └── game_manager.gd
│   ├── tools/          # Tool systems
│   │   ├── tool_controller.gd
│   │   └── magnifying_glass_tool.gd
│   ├── npc/            # NPC systems
│   │   └── npc_queue_controller.gd
│   ├── ui/             # UI scripts
│   │   ├── main_menu_controller.gd
│   │   ├── button_hover_effect.gd
│   │   └── settings_controller.gd
│   ├── cutscene/       # Cutscene systems
│   │   └── cutscene_controller.gd
│   ├── transitions/    # Scene transitions
│   │   └── scene_transition_controller.gd
│   └── ending/         # Ending logic
│       └── ending_manager.gd
├── assets/             # Game assets
│   ├── sprites/        # Sprite images
│   ├── audio/          # Sound effects & music
│   └── fonts/          # Fonts
└── README.md           # File ini
```

## 🚀 Cara Menjalankan

1. **Install Godot Engine 4.3+**
   - Download dari: https://godotengine.org/download
   - Godot jauh lebih ringan dari Unity!

2. **Buka Project**
   - Jalankan Godot Engine
   - Klik "Import"
   - Navigate ke folder ini dan pilih `project.godot`
   - Klik "Import & Edit"

3. **Run Game**
   - Tekan `F5` atau klik tombol Play di pojok kanan atas
   - Untuk run scene saat ini: `F6`

## 🔄 Perubahan dari Unity ke Godot

### Perbedaan Utama:

| Unity (C#) | Godot (GDScript) |
|-----------|------------------|
| `MonoBehaviour` | `Node` / `Node2D` / `Control` |
| `void Start()` | `func _ready()` |
| `void Update()` | `func _process(delta)` |
| `GameObject` | `Node` |
| `Instantiate()` | `instantiate()` |
| `Destroy()` | `queue_free()` |
| `Input.GetKeyDown()` | `Input.is_action_just_pressed()` |
| `SceneManager.LoadScene()` | `get_tree().change_scene_to_file()` |

### Sistem yang Sudah Dikonversi:

✅ **GameManager** - Singleton pattern untuk game states
✅ **ToolController** - Base class untuk semua tools
✅ **MagnifyingGlassTool** - Tool untuk inspect NPCs
✅ **NPCQueueController** - Sistem antrian NPC
✅ **MainMenuController** - Menu utama
✅ **ButtonHoverEffect** - Effect hover untuk buttons
✅ **SceneTransitionController** - Transisi antar scene
✅ **EndingManager** - Sistem multiple endings
✅ **CutsceneController** - Sistem cutscene & dialog
✅ **SettingsController** - Settings menu dengan audio controls

## 🛠️ Yang Perlu Dilengkapi

1. **Assets**
   - Copy sprites dari Unity project ke `assets/sprites/`
   - Copy audio files ke `assets/audio/`
   - Import akan otomatis di Godot

2. **Scenes**
   - Buat scene untuk setiap object/character
   - Setup scene hierarchy menggunakan Node system
   - Attach scripts yang sesuai

3. **Input Mapping**
   - Sudah di-setup di `project.godot`
   - Bisa dikustomisasi di: Project > Project Settings > Input Map

4. **Game Logic**
   - Implementasi logic spesifik game Anda di scene gameplay
   - Connect signals antar nodes
   - Setup collision layers & physics

## 💡 Tips Menggunakan Godot

1. **Signals** - Gunakan signals untuk komunikasi antar nodes (seperti Events di Unity)
   ```gdscript
   signal player_died
   player_died.emit()
   ```

2. **Autoload (Singleton)** - Untuk global managers
   - Project > Project Settings > Autoload
   - Add `game_manager.gd` sebagai autoload

3. **Inspector** - Semua `@export` variable muncul di Inspector
   ```gdscript
   @export var speed: float = 100.0
   ```

4. **Debugging** - Gunakan `print()` untuk debug
   ```gdscript
   print("Debug message: ", variable_name)
   ```

5. **Performance** - Godot jauh lebih ringan dari Unity
   - Startup lebih cepat
   - RAM usage lebih kecil
   - Build size lebih kecil

## 📚 Resources Belajar Godot

- **Official Docs**: https://docs.godotengine.org/
- **GDScript Basics**: https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/
- **Unity to Godot Guide**: https://docs.godotengine.org/en/stable/tutorials/best_practices/unity_to_godot.html
- **YouTube Channels**:
  - Brackeys (ada tutorial Godot)
  - GDQuest
  - HeartBeast

## 🎯 Next Steps

1. Buka project di Godot
2. Explore struktur scene yang sudah dibuat
3. Test main menu (`scenes/ui/main_menu.tscn`)
4. Mulai implementasi gameplay logic
5. Import assets dari Unity project
6. Build & test

## ⚡ Keuntungan Godot vs Unity

- ✅ Gratis 100% (tidak ada licensing fees)
- ✅ Lebih ringan (± 50MB download vs Unity 10GB+)
- ✅ Open source
- ✅ Startup lebih cepat
- ✅ Editor lebih responsif
- ✅ Native 2D engine (Unity focused on 3D)
- ✅ Built-in animation system yang powerful
- ✅ Smaller build sizes

## 📝 License

Lihat LICENSE file untuk detail.

## 👥 Contributors

Kelompok 10 - Global Game Jam 2026

---

**Happy Game Development! 🎮**
