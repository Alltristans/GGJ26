# GDScript Cheat Sheet
## Reference Cepat untuk Developer Unity → Godot

---

## 📝 Basic Syntax

### Variables
```gdscript
# Type inference
var name = "Player"
var health = 100
var speed = 5.5

# Explicit typing
var score: int = 0
var position: Vector2 = Vector2.ZERO
var player: CharacterBody2D

# Constants
const MAX_HEALTH = 100
const GRAVITY = 980

# Export (visible di Inspector)
@export var damage: int = 10
@export var sprite: Texture2D
@export_range(0, 100) var volume: float = 50
@export_category("Movement")
@export var walk_speed: float = 100
```

### Functions
```gdscript
# Basic function
func my_function():
    pass

# With parameters
func take_damage(amount: int):
    health -= amount

# With return type
func get_health() -> int:
    return health

# With default parameters
func heal(amount: int = 10):
    health += amount

# Static function
static func calculate_distance(a: Vector2, b: Vector2) -> float:
    return a.distance_to(b)
```

### Control Flow
```gdscript
# If-else
if health <= 0:
    die()
elif health < 30:
    low_health_warning()
else:
    normal_state()

# Match (switch)
match state:
    "IDLE":
        idle_animation()
    "WALK":
        walk_animation()
    "ATTACK":
        attack_animation()
    _:  # default case
        print("Unknown state")

# For loops
for i in range(10):
    print(i)

for item in inventory:
    print(item.name)

for i in range(0, 10, 2):  # start, end, step
    print(i)  # 0, 2, 4, 6, 8

# While loop
while health > 0:
    await get_tree().create_timer(1.0).timeout
    health -= 1
```

---

## 🎮 Common Godot Patterns

### Node Access
```gdscript
# Get child node
var sprite = $Sprite2D
var sprite = get_node("Sprite2D")

# Get node by path
var player = get_node("/root/GameManager/Player")
var ui = get_node("../UI/HealthBar")

# Get parent
var parent = get_parent()

# Find nodes in tree
var player = get_tree().get_first_node_in_group("player")
var enemies = get_tree().get_nodes_in_group("enemies")

# Check if node exists
if has_node("Sprite2D"):
    $Sprite2D.visible = true

# Safe access with @onready
@onready var sprite = $Sprite2D
@onready var animation = $AnimationPlayer
```

### Signals
```gdscript
# Define signal
signal health_changed(new_health)
signal enemy_died(enemy_name, position)

# Emit signal
health_changed.emit(50)
enemy_died.emit("Goblin", global_position)

# Connect signal (in code)
player.health_changed.connect(_on_player_health_changed)

# Disconnect
player.health_changed.disconnect(_on_player_health_changed)

# Signal handler
func _on_player_health_changed(new_health: int):
    health_bar.value = new_health

# One-shot signal
signal_name.connect(callback, CONNECT_ONE_SHOT)
```

### Input Handling
```gdscript
# In _process or _physics_process
func _process(_delta):
    if Input.is_action_pressed("move_right"):
        position.x += speed
    
    if Input.is_action_just_pressed("jump"):
        jump()
    
    if Input.is_action_just_released("attack"):
        release_attack()

# Direct input
func _input(event):
    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
            print("Left click at: ", event.position)
    
    if event is InputEventKey:
        if event.keycode == KEY_ESCAPE and event.pressed:
            pause_game()

# Unhandled input (after UI consumes)
func _unhandled_input(event):
    if event.is_action_pressed("pause"):
        toggle_pause()
```

### Timers
```gdscript
# One-shot timer
await get_tree().create_timer(2.0).timeout
print("2 seconds passed")

# Using Timer node
@onready var timer = $Timer

func _ready():
    timer.wait_time = 3.0
    timer.one_shot = false
    timer.timeout.connect(_on_timer_timeout)
    timer.start()

func _on_timer_timeout():
    print("Timer fired!")
```

### Tweens (Animations)
```gdscript
# Basic tween
var tween = create_tween()
tween.tween_property(sprite, "modulate:a", 0.0, 1.0)  # Fade out

# Chained tweens
var tween = create_tween()
tween.tween_property(self, "position:x", 100, 1.0)
tween.tween_property(self, "position:y", 100, 1.0)
tween.tween_callback(on_animation_complete)

# Parallel tweens
var tween = create_tween()
tween.set_parallel(true)
tween.tween_property(self, "position", Vector2(100, 100), 1.0)
tween.tween_property(self, "rotation", PI, 1.0)

# Easing
tween.set_ease(Tween.EASE_IN_OUT)
tween.set_trans(Tween.TRANS_ELASTIC)

# Available easing: EASE_IN, EASE_OUT, EASE_IN_OUT
# Available transitions: LINEAR, SINE, QUINT, QUART, QUAD, EXPO, ELASTIC, CUBIC, CIRC, BOUNCE, BACK
```

---

## 🎯 Common Tasks

### Instantiate Scenes
```gdscript
# Load and instantiate
var bullet_scene = preload("res://scenes/bullet.tscn")
var bullet = bullet_scene.instantiate()
add_child(bullet)
bullet.position = position

# With export variable
@export var enemy_scene: PackedScene

func spawn_enemy():
    var enemy = enemy_scene.instantiate()
    get_parent().add_child(enemy)
```

### Delete Objects
```gdscript
# Queue for deletion (safe)
queue_free()

# Immediate deletion (use with caution)
free()

# Remove from parent but don't delete
get_parent().remove_child(self)
```

### Scene Switching
```gdscript
# Change scene
get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

# Change scene with transition
func change_scene_with_fade(scene_path: String):
    # Fade out
    var tween = create_tween()
    tween.tween_property($FadeRect, "modulate:a", 1.0, 0.5)
    await tween.finished
    
    # Change scene
    get_tree().change_scene_to_file(scene_path)

# Reload current scene
get_tree().reload_current_scene()
```

### Pause Game
```gdscript
# Pause
get_tree().paused = true

# Unpause
get_tree().paused = false

# Make node work when paused
process_mode = Node.PROCESS_MODE_ALWAYS
```

---

## 📐 Math & Vectors

```gdscript
# Vector2
var vec = Vector2(10, 20)
var zero = Vector2.ZERO
var one = Vector2.ONE
var up = Vector2.UP        # (0, -1)
var down = Vector2.DOWN    # (0, 1)
var left = Vector2.LEFT    # (-1, 0)
var right = Vector2.RIGHT  # (1, 0)

# Vector operations
var length = vec.length()
var normalized = vec.normalized()
var distance = vec.distance_to(other_vec)
var direction = (target - position).normalized()
var dot_product = vec.dot(other_vec)

# Lerp (linear interpolation)
var current_pos = Vector2(0, 0)
var target_pos = Vector2(100, 100)
var smooth_pos = current_pos.lerp(target_pos, 0.1)

# Move toward
var new_pos = current_pos.move_toward(target_pos, delta * speed)

# Math functions
var angle = atan2(direction.y, direction.x)
var random_value = randf()  # 0.0 to 1.0
var random_int = randi() % 10  # 0 to 9
var clamped = clamp(value, 0, 100)
var abs_value = abs(-5)
var rounded = round(5.7)
var floored = floor(5.7)
var ceiled = ceil(5.2)
```

---

## 🎨 Common Node Operations

### Visibility
```gdscript
# Hide/show
visible = false
show()
hide()

# Modulate (tint/transparency)
modulate = Color(1, 0, 0)  # Red tint
modulate.a = 0.5  # Semi-transparent
```

### Position & Transform
```gdscript
# Position
position = Vector2(100, 100)
global_position = Vector2(500, 500)

# Rotation
rotation = PI / 2  # 90 degrees (radians)
rotation_degrees = 90

# Scale
scale = Vector2(2, 2)  # Double size
scale = Vector2.ONE
```

### Physics
```gdscript
# CharacterBody2D
func _physics_process(delta):
    velocity = Vector2(100, 0)
    move_and_slide()

# RigidBody2D
func _ready():
    apply_impulse(Vector2(100, -200))
    apply_force(Vector2(0, -980))
```

---

## 💾 Save/Load

```gdscript
# Save
func save_game():
    var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
    var save_data = {
        "player_health": health,
        "player_position": position,
        "score": score
    }
    save_file.store_var(save_data)
    save_file.close()

# Load
func load_game():
    if not FileAccess.file_exists("user://savegame.save"):
        return
    
    var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
    var save_data = save_file.get_var()
    save_file.close()
    
    health = save_data.player_health
    position = save_data.player_position
    score = save_data.score

# Config file (for settings)
func save_settings():
    var config = ConfigFile.new()
    config.set_value("audio", "master_volume", 0.8)
    config.set_value("graphics", "fullscreen", true)
    config.save("user://settings.cfg")

func load_settings():
    var config = ConfigFile.new()
    var err = config.load("user://settings.cfg")
    if err != OK:
        return
    
    var master_volume = config.get_value("audio", "master_volume", 1.0)
    var fullscreen = config.get_value("graphics", "fullscreen", false)
```

---

## 🔧 Debugging

```gdscript
# Print to console
print("Hello")
print("Value: ", value)
print_debug("Debug info")  # Includes line number
push_warning("Warning message")
push_error("Error message")

# Assert
assert(health > 0, "Health should be positive")

# Breakpoint (in code)
breakpoint  # Stops debugger here
```

---

## 🎓 Best Practices

1. **Use @onready for node references**
   ```gdscript
   @onready var sprite = $Sprite2D
   ```

2. **Type your variables when possible**
   ```gdscript
   var health: int = 100
   ```

3. **Use signals for communication**
   ```gdscript
   signal health_changed
   ```

4. **Prefer @export over hard-coded values**
   ```gdscript
   @export var speed: float = 100
   ```

5. **Use groups for categorization**
   ```gdscript
   add_to_group("enemies")
   if is_in_group("player"):
   ```

6. **Keep scripts small and focused**
   - One responsibility per script
   - Use composition over inheritance

7. **Name functions descriptively**
   ```gdscript
   func _on_button_pressed():  # Good
   func btn():  # Bad
   ```

---

**Happy coding in Godot! 🚀**
