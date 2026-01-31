# Magnifying Glass Tool - Dokumentasi

## Deskripsi
Tool Magnifying Glass adalah fitur untuk melihat area tertentu dengan lebih detail menggunakan zoom magnifier. User dapat mengklik button kaca pembesar untuk mengaktifkan fitur zoom pada area kacanya.

## Fitur Utama
- 🔍 **Zoom Magnifier**: Memperbesar area di sekitar kursor mouse hingga 2.5x
- 🎯 **Follow Mouse**: Lens secara otomatis mengikuti posisi mouse
- ⭕ **Circular Lens**: Lensa berbentuk lingkaran dengan shader custom
- ✨ **Smooth Animation**: Animasi pop-in/pop-out yang halus
- 🎨 **Visual Polish**: Border frame yang elegan pada lensa

## Struktur File

### Script
- `scripts/tools/magnifying_glass_tool.gd` - Main script untuk magnifier tool
  - Extends `ToolController` (base class untuk semua tools)
  - Menangani toggling magnifier, camera positioning, dan animasi

### Scene
- `scenes/tools/magnifier_ui.tscn` - Scene untuk UI magnifier (standalone)
- `scenes/gameplay/gameplay.tscn` - Integrated magnifier dalam gameplay

### Komponen Magnifier
```
MagnifierRoot (Control) - Root node, digroup "magnifier_ui"
├── LensFrame (Control) - Frame untuk lens
│   ├── LensView (TextureRect) - Menampilkan konten dari SubViewport
│   └── LensFrame2D (Control) - Decorative border
│       └── FrameBorder (ColorRect) - Warna frame coklat
└── MagnifierViewport (SubViewport) - Render target untuk camera
    └── MagnifierCamera (Camera2D) - Camera yang di-zoom
```

## Cara Kerja

### 1. Aktivasi
- User klik button "KacaPembesar" di scene gameplay
- Trigger `on_use()` method di MagnifyingGlassTool
- Magnifier toggle menjadi active dengan animasi smooth

### 2. Rendering
- `MagnifierViewport` merender scene dengan `MagnifierCamera`
- Camera di-set zoom 0.4x (kebalikan dari zoom_factor 2.5x)
- SubViewport di-copy ke `LensView` texture
- Shader circular mask menghasilkan bentuk lingkaran

### 3. Following
- Di `_process()`, camera position diupdate ke mouse position
- Lens position juga diupdate agar center dengan mouse
- Hasil: lens mengikuti mouse dengan zoom area di-center

### 4. Deaktivasi
- User klik lagi atau right-click tool
- Trigger animasi fadeout dan scale down
- Magnifier hidden setelah animasi selesai

## Settingan Export

Di MagnifyingGlassTool, ada beberapa settingan yang bisa dikustomisasi:

```gdscript
@export var zoom_factor: float = 2.5              # Faktor zoom (lebih besar = lebih zoom)
@export var lens_size: Vector2 = Vector2(220, 220) # Ukuran lens dalam pixel
@export var animation_duration: float = 0.2        # Durasi animasi aktif/non-aktif
```

## Shader Explanation

Shader circular lens menggunakan distance function:

```glsl
float dist = distance(uv, vec2(0.5));  // Hitung jarak dari center
if (dist > 0.5) discard;               // Discard pixel di luar radius 0.5
COLOR = texture(TEXTURE, uv);          // Apply texture dengan zoom
```

Hasil: Lens berbentuk sempurna circular dengan edge yang clean.

## Cara Menggunakan di Gameplay

### Setup Minimal
1. Pastikan `magnifier_ui.tscn` sudah ada atau nodes sudah di-scene
2. Node parent button harus `TextureButton` (otomatis konek ke magnifier)
3. MagnifierHandler script otomatis cari "magnifier_ui" group saat ready

### Custom Zoom
Di inspector, ubah nilai `zoom_factor` di script `MagnifierHandler`:
- 2.0 = 2x zoom (default awal)
- 2.5 = 2.5x zoom (recommended)
- 3.0 = 3x zoom (lebih detail tapi area lebih kecil)

### Mengubah Ukuran Lens
Ubah `lens_size` di MagnifierHandler:
```gdscript
lens_size = Vector2(300, 300)  # Lens lebih besar
```

## Integrasi dengan Tool System

MagnifyingGlassTool mengikuti pattern dari ToolController:

```gdscript
on_hover()   -> Set cursor magnifier glass
on_select()  -> Tool dipilih
on_use()     -> Left-click, toggle magnifier
on_lower()   -> Right-click, deactivate magnifier
```

## Debugging Tips

### Magnifier tidak muncul?
1. Cek apakah MagnifierRoot ada di "magnifier_ui" group
2. Cek apakah SubViewport size sudah benar
3. Cek console untuk error messages

### Lens tidak follow mouse?
1. Pastikan `set_process(true)` ada di `_ready()`
2. Cek apakah magnifier_root dan magnifier_camera valid
3. Pastikan CanvasLayer tidak mengblock input

### Zoom terlihat aneh?
1. Cek `magnifier_viewport.world_2d` sudah assign
2. Pastikan MagnifierCamera zoom value correct
3. Check shader pada LensView material

## Peningkatan Masa Depan

Fitur yang bisa ditambahkan:
- [ ] Magnifier dengan background effect (dimming)
- [ ] Multiple zoom levels (right-click untuk zoom lebih)
- [ ] Grid overlay untuk measurement
- [ ] Sound effect saat toggle magnifier
- [ ] Keybind untuk quick magnifier (misal: Space)
- [ ] Magnifier brightness control
- [ ] Custom lens shapes (square, oval, dll)

## File yang Berubah

1. `scripts/tools/magnifying_glass_tool.gd` - Diupdate dengan fitur lengkap
2. `scenes/gameplay/gameplay.tscn` - Struktur magnifier diperbaiki
3. `scenes/tools/magnifier_ui.tscn` - Scene baru dibuat (optional standalone scene)

---

**Last Updated**: February 1, 2026  
**Status**: ✅ Implementasi Selesai - Siap Digunakan
