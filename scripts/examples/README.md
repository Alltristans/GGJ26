# Example Scripts
## Contoh Script untuk Belajar Godot

Folder ini berisi contoh-contoh script yang mendemonstrasikan berbagai fitur dan pattern di Godot.

---

## 📁 Files

### 1. `example_player.gd`
**Character controller lengkap dengan:**
- Movement (walk, jump)
- Gravity & physics
- Health system
- Damage & healing
- Animations
- Sound effects
- Knockback
- Teleport
- Invincibility frames
- Async functions (coroutines)
- Debug drawing

**Cara pakai:**
```
1. Buat CharacterBody2D node
2. Add children: Sprite2D, CollisionShape2D, AnimationPlayer, AudioStreamPlayer
3. Attach script example_player.gd
4. Configure exports di Inspector
```

### 2. `example_npc.gd`
**NPC system lengkap dengan:**
- State machine (Idle, Walking, Talking, Working)
- Patrol behavior
- Dialog system
- Interaction detection
- Tool interaction
- Quest system
- AI behaviors (look at, follow, flee)
- Debug visualization

**Cara pakai:**
```
1. Buat Node2D node
2. Add children: Sprite2D, AnimationPlayer, Area2D (dengan CollisionShape2D)
3. Attach script example_npc.gd
4. Configure dialog lines & behavior di Inspector
```

---

## 🎯 Konsep yang Diajarkan

### Variables & Types
```gdscript
var health: int = 100
@export var speed: float = 200.0
@onready var sprite = $Sprite2D
const MAX_HEALTH = 100
```

### Signals
```gdscript
signal health_changed(new_health)
health_changed.emit(50)
```

### State Machine
```gdscript
enum State { IDLE, WALKING, ATTACKING }
var current_state: State = State.IDLE
```

### Physics
```gdscript
velocity.y += gravity * delta
move_and_slide()
is_on_floor()
```

### Animations
```gdscript
animation_player.play("walk")
await animation_player.animation_finished
```

### Tweens
```gdscript
var tween = create_tween()
tween.tween_property(sprite, "modulate", Color.RED, 0.5)
```

### Async/Await
```gdscript
await get_tree().create_timer(2.0).timeout
print("2 seconds passed")
```

### Collision Detection
```gdscript
func _on_area_entered(area: Area2D):
    if area.is_in_group("enemy"):
        take_damage(10)
```

### Input Handling
```gdscript
if Input.is_action_just_pressed("jump"):
    jump()

var direction = Input.get_axis("ui_left", "ui_right")
```

---

## 🔧 Modify & Learn

### Experiment dengan:

1. **Ubah nilai exports**
   - Speed, jump force, gravity
   - Lihat efeknya secara real-time

2. **Tambah states baru**
   - Attack state
   - Dash state
   - Crouch state

3. **Tambah animations**
   - Attack animations
   - Special moves
   - Particle effects

4. **Extend behaviors**
   - AI pathfinding
   - Complex dialog trees
   - Inventory system

---

## 📚 Pattern yang Digunakan

### 1. Export Pattern
```gdscript
@export var speed: float = 100.0
@export var sprite: Texture2D
@export_range(0, 100) var health: int = 100
```
**Keuntungan**: Configure di Inspector tanpa edit code

### 2. Onready Pattern
```gdscript
@onready var sprite = $Sprite2D
```
**Keuntungan**: Safe node reference, called after _ready()

### 3. Signal Pattern
```gdscript
signal event_happened
event_happened.emit()
```
**Keuntungan**: Decoupled communication antar nodes

### 4. State Machine Pattern
```gdscript
enum State { IDLE, WALKING }
var current_state: State

func change_state(new_state: State):
    _exit_state(current_state)
    current_state = new_state
    _enter_state(new_state)
```
**Keuntungan**: Organized behavior management

### 5. Property Setter Pattern
```gdscript
var health: int = 100:
    set(value):
        health = clamp(value, 0, 100)
        health_changed.emit(health)
```
**Keuntungan**: Automatic validation & event triggering

---

## 🎮 Testing Examples

### Test Player Script:
```
1. Create new scene
2. Add CharacterBody2D with example_player.gd
3. Add Sprite2D child (any sprite)
4. Add CollisionShape2D child (RectangleShape2D)
5. Add ground (StaticBody2D with CollisionShape2D)
6. Press F6 to test
7. Use arrow keys to move, Space to jump
```

### Test NPC Script:
```
1. Create new scene
2. Add Node2D with example_npc.gd
3. Add Sprite2D child
4. Add Area2D child named "InteractionArea"
   └ Add CollisionShape2D (CircleShape2D)
5. Add player nearby
6. Press F6 to test
7. Walk near NPC, press Enter to interact
```

---

## 💡 Tips Belajar

1. **Read the comments** - Banyak penjelasan di dalam code
2. **Modify values** - Experiment dengan parameters
3. **Add print statements** - Debug untuk understand flow
4. **Break things** - Learn dari error messages
5. **Build incrementally** - Start simple, add features slowly

---

## 🚀 Next Steps

Setelah memahami examples ini:

1. **Combine concepts** - Buat game sederhana
2. **Add your features** - Customize untuk game Anda
3. **Refactor** - Improve code structure
4. **Optimize** - Profile & optimize performance

---

## 📖 Related Documentation

- [GDSCRIPT_CHEATSHEET.md](../../GDSCRIPT_CHEATSHEET.md)
- [CONVERSION_GUIDE.md](../../CONVERSION_GUIDE.md)
- [Godot Docs - GDScript](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/)

---

**Happy Learning! 🎓**
