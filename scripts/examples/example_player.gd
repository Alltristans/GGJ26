extends CharacterBody2D
## Example Player Controller
## Script contoh untuk mendemonstrasikan berbagai fitur Godot

# ============================================================
# VARIABLES
# ============================================================

## Movement speed
@export var move_speed: float = 200.0

## Jump force
@export var jump_force: float = -400.0

## Gravity
@export var gravity: float = 980.0

## Player sprite
@onready var sprite: Sprite2D = $Sprite2D

## Animation player
@onready var animation_player: AnimationPlayer = $AnimationPlayer

## Audio player untuk sound effects
@onready var jump_sound: AudioStreamPlayer = $JumpSound

# Internal state
var is_jumping: bool = false


# ============================================================
# SIGNALS
# ============================================================

## Emitted when player takes damage
signal health_changed(new_health: int)

## Emitted when player dies
signal player_died


# ============================================================
# LIFECYCLE METHODS
# ============================================================

## Called when the node enters the scene tree
func _ready() -> void:
	print("Player ready!")
	add_to_group("player")  # Add to group for easy finding


## Called every frame
func _process(delta: float) -> void:
	# Update animations based on velocity
	_update_animations()


## Called every physics frame
func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Handle movement
	_handle_movement()
	
	# Move the character
	move_and_slide()


## Handle input events
func _input(event: InputEvent) -> void:
	# Example: Handle mouse click
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
			print("Clicked at: ", mouse_event.position)


# ============================================================
# MOVEMENT
# ============================================================

## Handle player movement
func _handle_movement() -> void:
	# Get input direction (-1, 0, 1)
	var input_direction = Input.get_axis("ui_left", "ui_right")
	
	# Apply horizontal movement
	if input_direction != 0:
		velocity.x = input_direction * move_speed
		# Flip sprite based on direction
		sprite.flip_h = input_direction < 0
	else:
		# Smooth stop
		velocity.x = move_toward(velocity.x, 0, move_speed * 0.1)
	
	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		_jump()


## Make player jump
func _jump() -> void:
	velocity.y = jump_force
	is_jumping = true
	
	# Play jump sound
	if jump_sound:
		jump_sound.play()
	
	# Play jump animation
	if animation_player:
		animation_player.play("jump")


# ============================================================
# ANIMATIONS
# ============================================================

## Update animations based on state
func _update_animations() -> void:
	if not animation_player:
		return
	
	if is_on_floor():
		is_jumping = false
		
		if abs(velocity.x) > 10:
			animation_player.play("walk")
		else:
			animation_player.play("idle")
	else:
		if velocity.y < 0:
			animation_player.play("jump")
		else:
			animation_player.play("fall")


# ============================================================
# HEALTH & DAMAGE
# ============================================================

## Current health
var health: int = 100:
	set(value):
		health = clamp(value, 0, 100)
		health_changed.emit(health)
		
		if health <= 0:
			_die()


## Take damage
func take_damage(amount: int) -> void:
	health -= amount
	
	# Flash red
	_flash_damage()
	
	# Knockback
	_apply_knockback(Vector2(-100, -200))


## Heal
func heal(amount: int) -> void:
	health += amount
	print("Healed! Health: ", health)


## Flash sprite red on damage
func _flash_damage() -> void:
	var tween = create_tween()
	tween.tween_property(sprite, "modulate", Color.RED, 0.1)
	tween.tween_property(sprite, "modulate", Color.WHITE, 0.1)


## Apply knockback force
func _apply_knockback(force: Vector2) -> void:
	velocity = force


## Handle player death
func _die() -> void:
	print("Player died!")
	player_died.emit()
	
	# Play death animation
	if animation_player:
		animation_player.play("death")
		await animation_player.animation_finished
	
	# Game over
	get_tree().change_scene_to_file("res://scenes/ui/game_over.tscn")


# ============================================================
# COLLISION HANDLING
# ============================================================

## Called when Area2D enters (if you have Area2D child)
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		take_damage(10)
	elif body.is_in_group("coin"):
		_collect_coin(body)
	elif body.is_in_group("powerup"):
		_collect_powerup(body)


## Collect coin
func _collect_coin(coin: Node2D) -> void:
	# Add to score (access GameManager)
	if GameManager.instance:
		GameManager.instance.add_score(10)
	
	coin.queue_free()


## Collect powerup
func _collect_powerup(powerup: Node2D) -> void:
	health = 100  # Full heal
	powerup.queue_free()


# ============================================================
# UTILITY FUNCTIONS
# ============================================================

## Teleport to position with effect
func teleport_to(target_position: Vector2) -> void:
	# Fade out
	var tween = create_tween()
	tween.tween_property(sprite, "modulate:a", 0.0, 0.3)
	await tween.finished
	
	# Move
	global_position = target_position
	
	# Fade in
	tween = create_tween()
	tween.tween_property(sprite, "modulate:a", 1.0, 0.3)


## Make player invincible for duration
func make_invincible(duration: float) -> void:
	# Disable collision
	set_collision_layer_value(1, false)
	
	# Visual feedback (blinking)
	var tween = create_tween()
	tween.set_loops(int(duration * 10))
	tween.tween_property(sprite, "modulate:a", 0.3, 0.1)
	tween.tween_property(sprite, "modulate:a", 1.0, 0.1)
	
	# Wait
	await get_tree().create_timer(duration).timeout
	
	# Re-enable collision
	set_collision_layer_value(1, true)
	sprite.modulate.a = 1.0


## Get direction to target
func get_direction_to(target: Vector2) -> Vector2:
	return (target - global_position).normalized()


## Check if player is in area
func is_in_area(area_name: String) -> bool:
	var areas = get_tree().get_nodes_in_group(area_name)
	for area in areas:
		if area is Area2D:
			# Check if player overlaps this area
			var shape = area.get_child(0) as CollisionShape2D
			if shape:
				# Simplified check - you'd want proper overlap detection
				return global_position.distance_to(area.global_position) < 100
	return false


# ============================================================
# DEBUG
# ============================================================

## Draw debug info
func _draw() -> void:
	# Draw velocity vector
	if OS.is_debug_build():
		draw_line(Vector2.ZERO, velocity * 0.1, Color.RED, 2.0)


## Print debug info
func _print_debug() -> void:
	print("=== Player Debug ===")
	print("Position: ", global_position)
	print("Velocity: ", velocity)
	print("Health: ", health)
	print("On Floor: ", is_on_floor())
	print("==================")


# ============================================================
# EXAMPLE COROUTINE (ASYNC FUNCTION)
# ============================================================

## Example async function
func example_async_sequence() -> void:
	print("Starting sequence...")
	
	# Wait 1 second
	await get_tree().create_timer(1.0).timeout
	print("1 second passed")
	
	# Jump
	_jump()
	
	# Wait for animation
	if animation_player:
		await animation_player.animation_finished
	
	print("Animation finished!")
	
	# Move to position
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(100, 100), 2.0)
	await tween.finished
	
	print("Sequence complete!")


# ============================================================
# NOTES
# ============================================================

# Cara pakai script ini:
# 1. Buat CharacterBody2D node
# 2. Attach script ini
# 3. Add child nodes:
#    - Sprite2D (for visual)
#    - CollisionShape2D (for physics)
#    - AnimationPlayer (for animations)
#    - AudioStreamPlayer (for sounds)
# 4. Setup @onready paths sesuai hierarchy
# 5. Configure @export variables di Inspector

# Tips:
# - velocity adalah built-in variable di CharacterBody2D
# - move_and_slide() otomatis handle collision
# - is_on_floor() detect ground
# - Signals untuk komunikasi antar nodes
# - await untuk async operations
# - Tween untuk smooth animations
