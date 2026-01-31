# Unity to Godot Conversion Guide
# Panduan Konversi Unity ke Godot untuk Project GGJ 2026

## Mapping Komponen Utama

### 1. MonoBehaviour → Node System

**Unity:**
```csharp
public class MyScript : MonoBehaviour
{
    void Start() { }
    void Update() { }
}
```

**Godot:**
```gdscript
extends Node2D

func _ready():
    pass

func _process(delta):
    pass
```

### 2. GameObject Hierarchy

**Unity:**
- GameObject
  - Transform
  - Components

**Godot:**
- Node (base)
  - Node2D (2D games)
  - Node3D (3D games)
  - Control (UI)

### 3. Lifecycle Methods

| Unity | Godot | Keterangan |
|-------|-------|------------|
| `Awake()` | `_init()` | Constructor |
| `Start()` | `_ready()` | Initialization |
| `Update()` | `_process(delta)` | Every frame |
| `FixedUpdate()` | `_physics_process(delta)` | Physics frame |
| `OnDestroy()` | `_exit_tree()` | Cleanup |

### 4. Input System

**Unity:**
```csharp
if (Input.GetKeyDown(KeyCode.Space))
if (Input.GetMouseButtonDown(0))
```

**Godot:**
```gdscript
if Input.is_action_just_pressed("ui_accept"):
if Input.is_action_just_pressed("ui_left_click"):
```

### 5. Instantiation

**Unity:**
```csharp
GameObject obj = Instantiate(prefab);
Destroy(obj, 2.0f);
```

**Godot:**
```gdscript
var obj = scene.instantiate()
add_child(obj)
obj.queue_free()  # atau obj.free() immediate
```

### 6. Scene Management

**Unity:**
```csharp
SceneManager.LoadScene("MainMenu");
```

**Godot:**
```gdscript
get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
```

### 7. Singleton Pattern

**Unity:**
```csharp
public class GameManager : MonoBehaviour
{
    public static GameManager Instance { get; private set; }
    
    void Awake()
    {
        if (Instance != null && Instance != this)
        {
            Destroy(gameObject);
            return;
        }
        Instance = this;
        DontDestroyOnLoad(gameObject);
    }
}
```

**Godot (Method 1 - Script):**
```gdscript
extends Node

static var instance: Node = null

func _ready():
    if instance != null and instance != self:
        queue_free()
        return
    instance = self
```

**Godot (Method 2 - Autoload - RECOMMENDED):**
1. Project > Project Settings > Autoload
2. Add script sebagai singleton
3. Access: `GameManager.method_name()`

### 8. Signals (Events)

**Unity:**
```csharp
public event Action<int> OnScoreChanged;
OnScoreChanged?.Invoke(newScore);

// Subscribe
gameManager.OnScoreChanged += HandleScoreChanged;
```

**Godot:**
```gdscript
signal score_changed(new_score)
score_changed.emit(100)

# Connect
game_manager.score_changed.connect(_on_score_changed)
```

### 9. Coroutines

**Unity:**
```csharp
IEnumerator WaitAndPrint()
{
    yield return new WaitForSeconds(2);
    print("Done");
}
StartCoroutine(WaitAndPrint());
```

**Godot:**
```gdscript
func wait_and_print():
    await get_tree().create_timer(2.0).timeout
    print("Done")

wait_and_print()
```

### 10. Finding Objects

**Unity:**
```csharp
GameObject player = GameObject.FindWithTag("Player");
MyScript script = FindObjectOfType<MyScript>();
```

**Godot:**
```gdscript
var player = get_tree().get_first_node_in_group("player")
var script = get_node("/root/GameManager")
```

### 11. Physics & Collision

**Unity:**
```csharp
void OnCollisionEnter2D(Collision2D collision)
{
    if (collision.gameObject.CompareTag("Enemy"))
    {
        // Handle collision
    }
}
```

**Godot:**
```gdscript
func _on_area_2d_body_entered(body):
    if body.is_in_group("enemy"):
        # Handle collision
        pass
```

### 12. UI System

**Unity:**
- Canvas
- RectTransform
- Button, Text, Image

**Godot:**
- Control nodes
- Anchors & Margins
- Button, Label, TextureRect

### 13. Animation

**Unity:**
```csharp
animator.SetTrigger("Jump");
animator.SetBool("IsRunning", true);
```

**Godot:**
```gdscript
$AnimationPlayer.play("jump")
# Or
$AnimatedSprite2D.play("run")
```

### 14. Audio

**Unity:**
```csharp
audioSource.Play();
audioSource.PlayOneShot(clip);
```

**Godot:**
```gdscript
$AudioStreamPlayer.play()
# atau
$AudioStreamPlayer2D.play()  # For positional audio
```

### 15. Vector Math

**Unity:**
```csharp
Vector2 direction = new Vector2(1, 0);
float distance = Vector2.Distance(a, b);
```

**Godot:**
```gdscript
var direction = Vector2(1, 0)
var distance = a.distance_to(b)
```

## Script Migration Checklist

Untuk setiap Unity script:

- [ ] Change class declaration: `public class X : MonoBehaviour` → `extends Node2D`
- [ ] Change `Start()` → `_ready()`
- [ ] Change `Update()` → `_process(delta)`
- [ ] Change variable declarations: `public float speed` → `@export var speed: float`
- [ ] Change `GameObject` references → `Node` references
- [ ] Change `Instantiate()` → `.instantiate()` + `add_child()`
- [ ] Change `Destroy()` → `queue_free()`
- [ ] Change `Input.GetKey*()` → `Input.is_action_*()`
- [ ] Change events → signals
- [ ] Change coroutines → `await`

## Tips Konversi

1. **Mulai dari Core Systems** - GameManager, state management dulu
2. **Gunakan Groups** - Setara dengan tags di Unity
3. **Signals > Direct Calls** - Lebih maintainable
4. **Autoload untuk Singletons** - Lebih clean dari script-based singleton
5. **Scene Inheritance** - Powerful feature Godot untuk reusable components
6. **Built-in Nodes** - Gunakan built-in nodes Godot, jangan reinvent the wheel

## Asset Pipeline

| Unity | Godot | Notes |
|-------|-------|-------|
| `.png`, `.jpg` | `.png`, `.jpg` | Auto-import |
| `.wav`, `.mp3` | `.wav`, `.mp3`, `.ogg` | Prefer .ogg |
| `.prefab` | `.tscn` | Scene files |
| `.anim` | `.tres` (Animation) | Different format |

## Common Pitfalls

1. **Null Reference** - Di Godot use `is_instance_valid()` atau check `!= null`
2. **Transform** - Di Godot: `position`, `rotation`, `scale` direct properties
3. **Layer Masks** - Different system, use collision layers/masks
4. **Time** - `Time.deltaTime` → parameter `delta` di `_process(delta)`
5. **String Comparison** - Case sensitive by default

## Performance Tips

- Godot generally lebih performant dari Unity untuk 2D
- Gunakan `Object Pooling` untuk frequent instantiation
- `queue_free()` vs `free()` - queue lebih safe
- Signals punya overhead kecil, tapi worth it untuk architecture

## Resources

- Official Migration Guide: https://docs.godotengine.org/en/stable/tutorials/best_practices/unity_to_godot.html
- GDScript Reference: https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/
- Godot Class Reference: https://docs.godotengine.org/en/stable/classes/

---

Good luck dengan konversi! 🚀
