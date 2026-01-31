# 🔧 SETUP MANUAL - Magnifying Glass Tool

Jika magnifier tidak bekerja, ikuti langkah-langkah ini di Godot Editor:

---

## ⚠️ LANGKAH 1: Reload Scene

1. Di Godot, buka: `scenes/gameplay/gameplay.tscn`
2. Tekan **F5** atau klik **Reload** button untuk reload scene
3. Tunggu sampai scene fully loaded

---

## ⚠️ LANGKAH 2: Verifikasi Script Attachment

### Check MagnifierHandler:
1. Di Scene Tree, navigate: `Meja/KacaPembesar/MagnifierHandler`
2. Klik node `MagnifierHandler`
3. Di Inspector, cari **Script**
4. Pastikan script sudah ter-attach:
   ```
   Script: res://scripts/tools/magnifying_glass_tool.gd
   ```

**Jika belum ter-attach:**
- Drag file `scripts/tools/magnifying_glass_tool.gd` ke **Script** field
- ATAU klik folder icon → pilih file
- Tekan Enter untuk confirm

---

## ⚠️ LANGKAH 3: Verify Node References

### 3A. Check MagnifierRoot Group:
1. Navigate: `MagnifierLayer/MagnifierRoot`
2. Klik `MagnifierRoot` node
3. Di Inspector, cari **Node** section
4. Lihat di bawah → **Groups**
5. Pastikan ada group: `magnifier_ui`

**Jika belum ada:**
- Klik **Node** tab (di atas Scene tree)
- Klik **Groups** section
- Klik button **Add Group**
- Type: `magnifier_ui`
- Tekan Enter

### 3B. Check MagnifierHandler Properties:
1. Klik `MagnifierHandler` node
2. Di Inspector, scroll down to **Script Variables** section
3. Verifikasi nilai:
   ```
   Zoom Factor: 2.5
   Lens Size: (220, 220)
   ```

---

## ⚠️ LANGKAH 4: Test Button Connection

1. Klik button `KacaPembesar` node
2. Di Inspector, cari **TextureButton** section
3. Scroll down → cari **Signals**
4. Cari signal: `pressed`

**Jika ada error atau tidak terlihat pressed:**
- Tekan F5 untuk reload scene

---

## ⚠️ LANGKAH 5: Check Shader Material

1. Navigate: `MagnifierLayer/MagnifierRoot/LensFrame/LensView`
2. Klik `LensView` node
3. Di Inspector, cari **Material**
4. Pastikan ter-assign:
   ```
   Material: SubResource("ShaderMaterial_lens")
   ```

**Jika kosong atau error:**
- Buka file teks: `gameplay.tscn`
- Cari: `[sub_resource type="Shader"]` 
- Pastikan shader sudah ada di awal file
- Jika tidak ada, copy-paste:

```
[sub_resource type="Shader" id="Shader_magnifier_lens"]
code = "shader_type canvas_item;

void fragment(){
	vec2 uv = UV;
	float dist = distance(uv, vec2(0.5));
	
	// Create circular lens with smooth edges
	if (dist > 0.5) {
		discard;
	}
	
	// Apply zoom to the magnified content
	COLOR = texture(TEXTURE, uv);
}
"

[sub_resource type="ShaderMaterial" id="ShaderMaterial_lens"]
shader = SubResource("Shader_magnifier_lens")
```

---

## ✅ LANGKAH 6: Final Test

1. Tekan **F5** atau klik **Play** button
2. Dalam game, cari button **Kaca Pembesar** (glasses icon) di meja
3. Hover di atas button → cursor harus berubah (jika sudah assign cursor texture)
4. **KLIK** button
5. Lihat apakah lens (lingkaran transparan) muncul

---

## 🐛 DEBUGGING TIPS

### Jika magnifier tidak muncul:

**Step 1: Check console untuk error**
1. Buka **Output** console (bottom panel)
2. Lihat apakah ada error messages (merah)
3. Copy error message dan cek apa yang salah

**Step 2: Add debug print**
1. Buka: `scripts/tools/magnifying_glass_tool.gd`
2. Tambahkan di `_ready()`:
   ```gdscript
   func _ready() -> void:
       print("MagnifierHandler ready!")
       _set_up_magnifier_ui()
       _connect_parent_button()
       set_process(true)
   ```
3. Run game dan lihat console
4. Jika tidak ada print "MagnifierHandler ready!" → script tidak di-attach

**Step 3: Check button click**
1. Tambahkan di `_on_button_pressed()`:
   ```gdscript
   func _on_button_pressed() -> void:
       print("Button clicked!")
       _toggle_magnifier()
   ```
2. Klik button di game
3. Cek apakah "Button clicked!" muncul di console

**Step 4: Check node finding**
1. Tambahkan di `_set_up_magnifier_ui()` setelah line pertama:
   ```gdscript
   magnifier_root = get_tree().get_first_node_in_group("magnifier_ui") as Control
   if magnifier_root:
       print("✓ MagnifierRoot found!")
   else:
       print("✗ MagnifierRoot NOT found!")
   ```
2. Cek console saat game start

---

## 📋 QUICK CHECKLIST

Pastikan semua ini ✅:

- [ ] Script ter-attach ke `MagnifierHandler` node
- [ ] `magnifier_ui` group ada di `MagnifierRoot`
- [ ] Shader dan material ter-define di `.tscn` file
- [ ] `MagnifierLayer` di scene dengan proper hierarchy
- [ ] `KacaPembesar` button ada dan bisa di-click
- [ ] Console tidak ada error messages
- [ ] Game run tanpa crash
- [ ] Button click trigger `_on_button_pressed()` (cek dengan print)
- [ ] `MagnifierRoot` ditemukan (cek dengan print)

---

## 🔧 CARA MANUAL CREATE MAGNIFIER (JIKA SEMUA GAGAL)

Jika setup sudah benar tapi masih tidak work, try ini:

### Option A: Delete dan recreate nodes

1. Delete node `MagnifierLayer` (dan semua child-nya)
2. Di scene tree, right-click pada `MainMenu` (root)
3. Pilih **Add Child Node**
4. Cari dan pilih **CanvasLayer**
5. Rename menjadi: `MagnifierLayer`
6. Klik `MagnifierLayer` → **Add Child Node**
7. Pilih **Control**
8. Rename menjadi: `MagnifierRoot`
9. Klik `MagnifierRoot` → **Node** tab (atas) → **Groups**
10. Tambahkan group: `magnifier_ui`
11. Klik `MagnifierRoot` → **Add Child Node**
12. Pilih **Control** → Rename: `LensFrame`
13. Klik `LensFrame` → **Add Child Node**
14. Pilih **TextureRect** → Rename: `LensView`
15. Klik `LensView` → di Inspector assign Material:
    - Klik **Material** field
    - Pilih **New ShaderMaterial**
    - Klik shader field yang baru
    - Pilih **New Shader**
    - Copy-paste kode shader di atas
16. Done! Sekarang coba test lagi

---

## 📞 STILL NOT WORKING?

Jika masih tidak bekerja setelah semua steps:

1. **Verify script syntax**: 
   - Buka `magnifying_glass_tool.gd`
   - Pastikan tidak ada red error lines
   - Jika ada, script compile error

2. **Verify scene structure**:
   - Buka `gameplay.tscn` dengan text editor
   - Cari `magnifier_ui` (harus ada)
   - Cari `MagnifierRoot` (harus ada)
   - Cari `Shader_magnifier_lens` (harus ada)

3. **Check console output**:
   - Run game
   - Look for error messages
   - Share error message untuk debug

---

## ✅ KAPAN BERHASIL?

Magnifier sudah berhasil jika:
1. ✅ Hover button → cursor berubah (jika cursor texture assigned)
2. ✅ Klik button → lingkaran semi-transparent muncul
3. ✅ Gerakkan mouse → lingkaran mengikuti mouse
4. ✅ Dalam lingkaran → terlihat zoom dari scene
5. ✅ Klik lagi → lingkaran hilang dengan smooth animation

---

**Date**: February 1, 2026  
**Guidance**: Step-by-step manual setup
