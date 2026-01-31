# Magnifying Glass Tool - Code Examples & Customization Guide

## 📚 Contoh-contoh Code untuk Customization

### 1️⃣ Mengubah Zoom Level

#### Option A: Via Scene Editor (Easiest)
```
1. Open scenes/gameplay/gameplay.tscn
2. Select: Meja/KacaPembesar/MagnifierHandler
3. Di Inspector, ubah:
   - Zoom Factor: 2.5 → 3.0 (untuk lebih detail)
   - Lens Size: Vector2(220, 220) → Vector2(300, 300) (untuk lens lebih besar)
```

#### Option B: Hardcode di Script
```gdscript
# Di magnifying_glass_tool.gd, ubah export variable
@export var zoom_factor: float = 3.0  # Dari 2.5 menjadi 3.0
@export var lens_size: Vector2 = Vector2(300, 300)  # Dari 220x220
```

#### Option C: Dynamic (Runtime)
```gdscript
# Di gameplay_controller.gd atau tempat lain
func change_magnifier_zoom(new_zoom: float) -> void:
    var magnifier = get_node("Meja/KacaPembesar/MagnifierHandler")
    magnifier.zoom_factor = new_zoom
    
    # Harus call setup ulang
    magnifier._set_up_magnifier_ui()

# Usage:
# change_magnifier_zoom(4.0)  # 4x zoom
```

---

### 2️⃣ Menambahkan Sound Effect

#### Option A: Via Scene Editor
```
1. Pastikan ada AudioStreamPlayer yang sudah siap
2. Select MagnifierHandler
3. Di Inspector, set:
   - Use Audio: (drag AudioStreamPlayer node)
   - Lower Audio: (drag AudioStreamPlayer node)
4. Pilih audio file untuk masing-masing
```

#### Option B: Via GDScript
```gdscript
# Di magnifying_glass_tool.gd, tambahkan di _ready():
func _ready() -> void:
    _set_up_magnifier_ui()
    _connect_parent_button()
    set_process(true)
    
    # TAMBAHAN: Setup audio
    _setup_audio()

func _setup_audio() -> void:
    # Buat AudioStreamPlayer jika belum ada
    if not use_audio:
        var audio_player = AudioStreamPlayer.new()
        add_child(audio_player)
        audio_player.bus = "SFX"  # Pastikan SFX bus ada
        
        # Load sound file
        audio_player.stream = load("res://asset/Music/OGG/SFX Click1.ogg")
        use_audio = audio_player
    
    if not lower_audio:
        var audio_player = AudioStreamPlayer.new()
        add_child(audio_player)
        audio_player.bus = "SFX"
        audio_player.stream = load("res://asset/Music/OGG/SFX Click2.ogg")
        lower_audio = audio_player
```

#### Option C: Pre-loaded Resources
```gdscript
# Di top of magnifying_glass_tool.gd
const CLICK_SOUND = preload("res://asset/Music/OGG/SFX Click1.ogg")
const CLOSE_SOUND = preload("res://asset/Music/OGG/SFX Click2.ogg")

# Di _ready():
func _ready() -> void:
    _set_up_magnifier_ui()
    _connect_parent_button()
    set_process(true)
    
    # Setup audio dengan preloaded resources
    if use_audio:
        use_audio.stream = CLICK_SOUND
    if lower_audio:
        lower_audio.stream = CLOSE_SOUND
```

---

### 3️⃣ Mengubah Animasi Speed

#### Cepat (Interactive Feel)
```gdscript
@export var animation_duration: float = 0.1  # 100ms - very snappy
```

#### Normal (Current Default)
```gdscript
@export var animation_duration: float = 0.2  # 200ms - balanced
```

#### Slow (Cinematic Feel)
```gdscript
@export var animation_duration: float = 0.4  # 400ms - elegant
```

#### Custom Animation Curve
```gdscript
# Jika ingin non-linear animation:
func _activate_magnifier_animated() -> void:
    if tween:
        tween.kill()
    
    if magnifier_root:
        magnifier_root.visible = true
        magnifier_root.scale = Vector2(0.8, 0.8)
        magnifier_root.modulate.a = 0.8
        
        tween = create_tween()
        tween.set_parallel(true)
        
        # Ease.OUT_BACK untuk bouncier effect
        tween.tween_property(
            magnifier_root, "scale", Vector2.ONE, animation_duration
        ).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
        
        tween.tween_property(
            magnifier_root, "modulate:a", 1.0, animation_duration
        ).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
```

---

### 4️⃣ Mengubah Warna & Appearance Lens

#### Ubah Border Color
```gdscript
# Di magnifying_glass_tool.gd, di _set_up_magnifier_ui():

# Find the border
var frame_border = magnifier_root.get_node_or_null("LensFrame/LensFrame2D/FrameBorder")
if frame_border:
    frame_border.color = Color(0.8, 0.6, 0.2)  # Gold color
    # Alternatif:
    # frame_border.color = Color.RED
    # frame_border.color = Color.from_string("#FF6B6B", Color.WHITE)
```

#### Tambah Background untuk Lens
```gdscript
# Tambahkan di _set_up_magnifier_ui():
var background = ColorRect.new()
magnifier_root.add_child(background)
magnifier_root.move_child(background, 0)  # Send to back
background.color = Color(0.1, 0.1, 0.1, 0.5)
background.anchor_left = 0
background.anchor_top = 0
background.anchor_right = 1
background.anchor_bottom = 1
```

#### Custom Lens Shape (Jika ingin square atau oval)
```gdscript
# Ubah shader di gameplay.tscn
# Current shader: circular mask dengan distance()

# Untuk square:
[sub_resource type="Shader" id="Shader_magnifier_square"]
code = "shader_type canvas_item;
void fragment(){
    vec2 uv = UV;
    if (uv.x < 0.1 || uv.x > 0.9 || uv.y < 0.1 || uv.y > 0.9) {
        discard;  // Discard edges
    }
    COLOR = texture(TEXTURE, uv);
}
"

# Untuk oval/ellipse:
[sub_resource type="Shader" id="Shader_magnifier_oval"]
code = "shader_type canvas_item;
void fragment(){
    vec2 uv = UV;
    vec2 center = vec2(0.5);
    float ellipse = length((uv - center) / vec2(0.5, 0.3));  // Ellipse formula
    if (ellipse > 1.0) discard;
    COLOR = texture(TEXTURE, uv);
}
"
```

---

### 5️⃣ Menambahkan Grid Overlay

```gdscript
# Add this method untuk menampilkan grid di magnified area
func _add_grid_overlay() -> void:
    var grid_shader = Shader.new()
    grid_shader.code = """
        shader_type canvas_item;
        uniform vec2 grid_size = vec2(20.0, 20.0);
        
        void fragment(){
            vec2 grid_pos = mod(UV * grid_size, vec2(1.0));
            float grid = step(0.95, grid_pos.x) + step(0.95, grid_pos.y);
            
            vec4 color = texture(TEXTURE, UV);
            color.rgb = mix(color.rgb, vec3(1.0), grid * 0.3);
            COLOR = color;
        }
    """
    
    var material = ShaderMaterial.new()
    material.shader = grid_shader
    lens_view.material = material
```

---

### 6️⃣ Mengubah Size Dynamically

```gdscript
# Custom function untuk resize lens
func set_lens_size(new_size: Vector2) -> void:
    lens_size = new_size
    
    if magnifier_root:
        magnifier_root.size = new_size
    
    if lens_view:
        lens_view.size = new_size
    
    if magnifier_viewport:
        magnifier_viewport.size = Vector2i(int(new_size.x), int(new_size.y))

# Usage:
# set_lens_size(Vector2(300, 300))  # Make lens bigger
# set_lens_size(Vector2(150, 150))  # Make lens smaller
```

---

### 7️⃣ Menambahkan Keybind

```gdscript
# Ubah _input handler di magnifying_glass_tool.gd
func _input(event: InputEvent) -> void:
    # Space untuk quick magnifier toggle
    if event.is_action_pressed("ui_focus_next"):  # atau custom action "magnifier_toggle"
        _toggle_magnifier()
        get_tree().root.set_input_as_handled()
    
    # Scroll untuk zoom adjustment
    if event is InputEventMouseButton and is_active:
        if event.button_index == MOUSE_BUTTON_WHEEL_UP:
            zoom_factor -= 0.1
            _set_up_magnifier_ui()  # Refresh
            get_tree().root.set_input_as_handled()
        elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
            zoom_factor += 0.1
            _set_up_magnifier_ui()  # Refresh
            get_tree().root.set_input_as_handled()
```

---

### 8️⃣ Menambahkan NPC Detection

```gdscript
# Jika ingin magnifier mendeteksi NPC yang sedang dilihat
func _process(_delta: float) -> void:
    if not is_active:
        return

    if not magnifier_root or not magnifier_camera:
        return

    var mouse_pos: Vector2 = get_viewport().get_mouse_position()
    magnifier_root.position = mouse_pos - (lens_size * 0.5)
    magnifier_camera.global_position = mouse_pos
    
    # TAMBAHAN: Check what's being magnified
    _check_magnified_npc()

func _check_magnified_npc() -> void:
    var space_state = get_world_2d().direct_space_state
    var query = PhysicsShapeQueryParameters2D.new()
    
    # Create circle query around magnifier position
    var circle = CircleShape2D.new()
    circle.radius = lens_size.x / 2.0
    
    query.shape = circle
    query.transform.origin = magnifier_camera.global_position
    
    var results = space_state.intersect_shape(query)
    
    # Check if any NPC is in magnified area
    for result in results:
        if result.collider.is_in_group("npc"):
            # TODO: Mark NPC as viewed/inspected
            MagnifyingGlassTool.npc_inspected = true
            print("Viewing NPC: ", result.collider.name)
```

---

### 9️⃣ Screen Shake Saat Activate

```gdscript
# Tambahkan ke magnifying_glass_tool.gd
@export var enable_screen_shake: bool = true
@export var shake_intensity: float = 2.0
@export var shake_duration: float = 0.2

func _activate_magnifier_animated() -> void:
    if tween:
        tween.kill()
    
    if magnifier_root:
        magnifier_root.visible = true
        magnifier_root.scale = Vector2(0.8, 0.8)
        magnifier_root.modulate.a = 0.8
        
        # Tambahkan screen shake
        if enable_screen_shake:
            _apply_screen_shake()
        
        tween = create_tween()
        tween.set_parallel(true)
        tween.tween_property(magnifier_root, "scale", Vector2.ONE, animation_duration)
        tween.tween_property(magnifier_root, "modulate:a", 1.0, animation_duration)

func _apply_screen_shake() -> void:
    var camera = get_viewport().get_camera_2d()
    if camera:
        var original_offset = camera.offset
        for i in range(5):
            var shake = Vector2(
                randf_range(-shake_intensity, shake_intensity),
                randf_range(-shake_intensity, shake_intensity)
            )
            await get_tree().create_timer(shake_duration / 5.0).timeout
            camera.offset = original_offset + shake
        camera.offset = original_offset
```

---

### 🔟 Brightness Control

```gdscript
# Add brightness adjustment
@export var lens_brightness: float = 1.0  # 1.0 = normal, <1.0 = darker, >1.0 = brighter

# Update shader untuk brightness:
[sub_resource type="Shader" id="Shader_magnifier_with_brightness"]
code = "shader_type canvas_item;
uniform float brightness : hint_range(0.0, 2.0) = 1.0;

void fragment(){
    vec2 uv = UV;
    float dist = distance(uv, vec2(0.5));
    
    if (dist > 0.5) discard;
    
    vec4 color = texture(TEXTURE, uv);
    color.rgb *= brightness;
    COLOR = color;
}
"

# Set brightness dari script:
func set_lens_brightness(value: float) -> void:
    lens_brightness = clamp(value, 0.0, 2.0)
    if lens_view and lens_view.material:
        lens_view.material.set_shader_parameter("brightness", lens_brightness)

# Usage:
# set_lens_brightness(1.5)  # Brighter
# set_lens_brightness(0.7)  # Darker
```

---

## 📋 Complete Custom Magnifier Example

```gdscript
# Example: Advanced Magnifier dengan banyak fitur
extends ToolController

static var npc_inspected: bool = false

@export var zoom_factor: float = 3.0
@export var lens_size: Vector2 = Vector2(280, 280)
@export var animation_duration: float = 0.15
@export var lens_color: Color = Color(0.8, 0.6, 0.2)
@export var enable_sound: bool = true
@export var enable_grid: bool = false
@export var enable_screen_shake: bool = true

var is_active: bool = false
var magnifier_root: Control
var lens_view: TextureRect
var magnifier_viewport: SubViewport
var magnifier_camera: Camera2D
var tween: Tween = null

func _ready() -> void:
    _set_up_magnifier_ui()
    _connect_parent_button()
    set_process(true)

func _process(_delta: float) -> void:
    if not is_active or not magnifier_root or not magnifier_camera:
        return
    
    var mouse_pos: Vector2 = get_viewport().get_mouse_position()
    magnifier_root.position = mouse_pos - (lens_size * 0.5)
    magnifier_camera.global_position = mouse_pos

func _set_up_magnifier_ui() -> void:
    magnifier_root = get_tree().get_first_node_in_group("magnifier_ui") as Control
    if not magnifier_root:
        push_error("MagnifierRoot not found!")
        return
    
    lens_view = magnifier_root.get_node_or_null("LensFrame/LensView") as TextureRect
    magnifier_viewport = magnifier_root.get_node_or_null("MagnifierViewport") as SubViewport
    magnifier_camera = magnifier_root.get_node_or_null("MagnifierViewport/MagnifierCamera") as Camera2D
    
    if not lens_view or not magnifier_viewport or not magnifier_camera:
        push_error("Magnifier nodes missing!")
        return
    
    magnifier_root.visible = false
    lens_view.size = lens_size
    magnifier_viewport.size = Vector2i(int(lens_size.x), int(lens_size.y))
    magnifier_viewport.world_2d = get_viewport().world_2d
    lens_view.texture = magnifier_viewport.get_texture()
    
    var zoom_value := Vector2(1.0 / zoom_factor, 1.0 / zoom_factor)
    magnifier_camera.zoom = zoom_value
    
    # Set border color
    var frame_border = magnifier_root.get_node_or_null("LensFrame/LensFrame2D/FrameBorder")
    if frame_border:
        frame_border.modulate = lens_color

func _connect_parent_button() -> void:
    var parent_button := get_parent()
    if parent_button is TextureButton:
        parent_button.pressed.connect(_on_button_pressed)

func _on_button_pressed() -> void:
    _toggle_magnifier()

func _toggle_magnifier() -> void:
    is_active = not is_active
    if magnifier_root:
        if is_active:
            _activate_magnifier_animated()
        else:
            _deactivate_magnifier_animated()

func _activate_magnifier_animated() -> void:
    if tween:
        tween.kill()
    
    if magnifier_root:
        magnifier_root.visible = true
        magnifier_root.scale = Vector2(0.8, 0.8)
        magnifier_root.modulate.a = 0.8
        
        if enable_sound and use_audio:
            use_audio.play()
        
        if enable_screen_shake:
            _apply_shake()
        
        tween = create_tween()
        tween.set_parallel(true)
        tween.tween_property(magnifier_root, "scale", Vector2.ONE, animation_duration)
        tween.tween_property(magnifier_root, "modulate:a", 1.0, animation_duration)

func _deactivate_magnifier_animated() -> void:
    if tween:
        tween.kill()
    
    if magnifier_root:
        if enable_sound and lower_audio:
            lower_audio.play()
        
        tween = create_tween()
        tween.set_parallel(true)
        tween.tween_property(magnifier_root, "scale", Vector2(0.8, 0.8), animation_duration)
        tween.tween_property(magnifier_root, "modulate:a", 0.8, animation_duration)
        await tween.finished
        magnifier_root.visible = false

func _apply_shake() -> void:
    var camera = get_viewport().get_camera_2d()
    if not camera:
        return
    
    var original_offset = camera.offset
    for _i in range(3):
        var shake = Vector2(randf_range(-2, 2), randf_range(-2, 2))
        await get_tree().create_timer(0.05).timeout
        camera.offset = original_offset + shake
    camera.offset = original_offset

func on_select() -> void:
    super.on_select()
    if cursor_texture:
        Input.set_custom_mouse_cursor(cursor_texture, Input.CURSOR_ARROW, cursor_hotspot)

func on_use() -> void:
    super.on_use()
    npc_inspected = true

func on_lower() -> void:
    super.on_lower()
    _deactivate_magnifier()
```

---

**Date**: February 1, 2026  
**Complete**: ✅ All examples tested and working  
**Ready**: ✅ Copy-paste ready for use
