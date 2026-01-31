# SETUP GODOT PROJECT - LANGKAH PENTING!

## 1. Setup GameplayManager sebagai Autoload (WAJIB!)

1. Buka Godot
2. Klik: Project > Project Settings
3. Tab: Autoload
4. Path: res://scripts/core/gameplay_manager.gd
5. Node Name: GameplayManager
6. Klik Add
7. Pastikan Enable ON
8. Klik Close

## 2. Buka Project

1. Launch Godot Engine
2. Import project ini
3. Tunggu import selesai

## 3. Test Game

1. Tekan F5 untuk run
2. Main menu akan muncul
3. Klik Start Game
4. Gameplay dimulai!

## 4. Gameplay Instructions

- NPC akan muncul satu per satu
- Klik INSPECT untuk melihat detail
- Pilih PASS jika tidak mencurigakan (suspicion < 50%)
- Pilih DETAIN jika mencurigakan (suspicion > 50%)
- Score: +100 benar, -50 salah
- Win: Process 8 NPCs dengan akurasi 70%+
- Time limit: 3 menit

## 5. Files yang Sudah Dibuat

 scripts/core/gameplay_manager.gd
 scripts/npc/npc_character.gd
 scripts/npc/npc_data_generator.gd
 scripts/ui/gameplay_ui.gd
 scripts/gameplay/gameplay_controller.gd
 scenes/npc/npc_character.tscn
 scenes/ui/gameplay_ui.tscn
 scenes/gameplay/gameplay.tscn

## 6. Troubleshooting

Jika error "GameplayManager not found":
- Pastikan sudah setup Autoload (step 1)
- Restart Godot

Jika NPC tidak muncul:
- Check console output
- Pastikan npc_character.tscn sudah ada

## READY TO PLAY! 

Tekan F5 dan enjoy your game!
