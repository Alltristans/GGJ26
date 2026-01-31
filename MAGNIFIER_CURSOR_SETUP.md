# 🔍 MAGNIFIER CURSOR - SETUP & HOW IT WORKS

## 🎯 KONSEP

Magnifier ini bekerja sebagai **cursor dengan zoom lens**:
- Ketika player klik button "Kaca Pembesar", cursor menjadi magnifying glass
- Bagian "kaca" (lens) menampilkan zoomed view dari area di bawah cursor
- Gerakkan mouse, zoom area mengikuti cursor
- Klik lagi untuk off

## 📊 BAGAIMANA CARA KERJANYA

### 1. Struktur Scene
```
MagnifierUI (instance dari magnifier_cursor.tscn)
├── MagnifierViewport (SubViewport - 120x120)
│   └── MagnifierCamera (Camera2D dengan zoom 0.4x = 2.5x)
└── MagnifierDisplay (TextureRect dengan shader)
```

### 2. Shader Magic
Shader di `magnifier_cursor.tscn` melakukan:
- ⭕ Membuat circular mask (hanya bagian dalam lingkaran yang terlihat)
- 🔍 Mengambil sample dari screen_texture dengan zoom
- 🎨 Menambah border effect (coklat/wood color)

### 3. Update Loop
Setiap frame saat magnifier active:
1. Get mouse position
2. Update MagnifierCamera ke mouse position
3. Camera zoom 0.4x membuat area terlihat 2.5x lebih besar
4. Viewport render scene dengan camera yang zoom
5. Texture ditampilkan di layar

## 🚀 CARA PAKAI

### Untuk Player:
```
1. Klik button "Kaca Pembesar" (glasses icon)
2. Cursor berubah jadi magnifying glass
3. Gerakkan mouse - gerakkan zoom lens
4. Lihat bagian "kaca" untuk zoom view
5. Klik lagi untuk turn off
```

### Untuk Developer:

**Jika tidak bekerja:**
1. Buka game (F5)
2. Buka Output console (bottom panel)
3. Lihat error messages
4. Copy error dan beritahu apa isinya

**Untuk customize zoom level:**
```gdscript
# Di MagnifierHandler (Meja/KacaPembesar/MagnifierHandler)
zoom_factor = 3.0  # Dari 2.5 menjadi 3.0 (lebih zoom)
```

**Untuk customize lens size:**
```gdscript
lens_size = 150.0  # Dari 120.0 menjadi 150.0 (lens lebih besar)
```

## 🔧 FILES YANG BERUBAH

1. **scripts/tools/magnifying_glass_tool.gd**
   - Simplified untuk cursor-based magnifier
   - Hapus animation, fokus ke viewport update
   - Auto-create viewport jika tidak ada

2. **scenes/gameplay/gameplay.tscn**
   - Replace MagnifierLayer dengan MagnifierUI instance
   - Load dari magnifier_cursor.tscn

3. **scenes/tools/magnifier_cursor.tscn** (NEW)
   - Scene untuk magnifier UI
   - Include shader, viewport, camera
   - Ready to instance di scene

## 📋 QUICK CHECKLIST

- [x] Script diperbaiki untuk cursor-based
- [x] Scene baru dibuat (magnifier_cursor.tscn)
- [x] gameplay.tscn updated dengan instance
- [x] Shader untuk circular zoom effect
- [x] Camera zoom untuk magnification

## 📞 TROUBLESHOOTING

**Magnifier tidak muncul?**
- Tekan F5 untuk reload scene
- Cek console untuk error
- Pastikan button "KacaPembesar" bisa diklik

**Zoom tidak terlihat?**
- Check shader di magnifier_cursor.tscn
- Verify viewport size (120x120)
- Check camera zoom (0.4 = 2.5x magnification)

**Cursor tidak berubah?**
- Script masih perlu assign cursor texture
- Atau use default magnifier visual

---

**Status**: ✅ Ready to test  
**Date**: February 1, 2026
