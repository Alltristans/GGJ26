extends Node2D
## Example NPC Script
## Contoh implementasi NPC dengan berbagai behaviors

# ============================================================
# EXPORTS (visible di Inspector)
# ============================================================

## NPC name
@export var npc_name: String = "NPC"

## NPC sprite
@export var npc_sprite: Texture2D

## Dialog lines
@export var dialog_lines: Array[String] = [
	"Hello!",
	"How are you?",
	"Goodbye!"
]

## Movement area (patrol)
@export var patrol_distance: float = 100.0

## Movement speed
@export var move_speed: float = 50.0


# ============================================================
# ONREADY VARIABLES
# ============================================================

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var interaction_area: Area2D = $InteractionArea


# ============================================================
# STATE
# ============================================================

enum NPCState {
	IDLE,
	WALKING,
	TALKING,
	WORKING
}

var current_state: NPCState = NPCState.IDLE
var start_position: Vector2
var is_player_nearby: bool = false
var current_dialog_index: int = 0


# ============================================================
# SIGNALS
# ============================================================

signal dialog_started(npc_name: String)
signal dialog_finished
signal npc_inspected(npc: Node2D)


# ============================================================
# LIFECYCLE
# ============================================================

func _ready() -> void:
	# Save start position for patrol
	start_position = global_position
	
	# Setup sprite
	if npc_sprite and sprite:
		sprite.texture = npc_sprite
	
	# Connect interaction area signals
	if interaction_area:
		interaction_area.body_entered.connect(_on_body_entered)
		interaction_area.body_exited.connect(_on_body_exited)
	
	# Add to group
	add_to_group("npcs")
	
	# Start behavior
	_start_behavior()


func _process(delta: float) -> void:
	# Update based on state
	match current_state:
		NPCState.IDLE:
			_idle_behavior(delta)
		NPCState.WALKING:
			_walking_behavior(delta)
		NPCState.TALKING:
			_talking_behavior(delta)
		NPCState.WORKING:
			_working_behavior(delta)
	
	# Check for interaction input
	if is_player_nearby and Input.is_action_just_pressed("ui_accept"):
		start_dialog()


# ============================================================
# STATE BEHAVIORS
# ============================================================

func _idle_behavior(_delta: float) -> void:
	if animation_player:
		animation_player.play("idle")


func _walking_behavior(delta: float) -> void:
	if animation_player:
		animation_player.play("walk")
	
	# Simple patrol
	var offset = sin(Time.get_ticks_msec() * 0.001) * patrol_distance
	var target_x = start_position.x + offset
	global_position.x = move_toward(global_position.x, target_x, move_speed * delta)
	
	# Flip sprite based on direction
	if sprite:
		sprite.flip_h = offset < 0


func _talking_behavior(_delta: float) -> void:
	if animation_player:
		animation_player.play("talk")


func _working_behavior(_delta: float) -> void:
	if animation_player:
		animation_player.play("work")


# ============================================================
# STATE TRANSITIONS
# ============================================================

func change_state(new_state: NPCState) -> void:
	if current_state == new_state:
		return
	
	# Exit current state
	_exit_state(current_state)
	
	# Change state
	current_state = new_state
	
	# Enter new state
	_enter_state(new_state)
	
	print(npc_name, " changed state to: ", NPCState.keys()[new_state])


func _enter_state(state: NPCState) -> void:
	match state:
		NPCState.IDLE:
			pass
		NPCState.WALKING:
			pass
		NPCState.TALKING:
			pass
		NPCState.WORKING:
			pass


func _exit_state(state: NPCState) -> void:
	match state:
		NPCState.IDLE:
			pass
		NPCState.WALKING:
			pass
		NPCState.TALKING:
			current_dialog_index = 0
		NPCState.WORKING:
			pass


# ============================================================
# BEHAVIORS
# ============================================================

func _start_behavior() -> void:
	# Random behavior cycle
	_behavior_cycle()


func _behavior_cycle() -> void:
	while true:
		# Idle for a bit
		change_state(NPCState.IDLE)
		await get_tree().create_timer(randf_range(2.0, 4.0)).timeout
		
		# Walk around
		change_state(NPCState.WALKING)
		await get_tree().create_timer(randf_range(3.0, 6.0)).timeout
		
		# Work for a bit
		change_state(NPCState.WORKING)
		await get_tree().create_timer(randf_range(2.0, 5.0)).timeout


# ============================================================
# DIALOG SYSTEM
# ============================================================

func start_dialog() -> void:
	if current_state == NPCState.TALKING:
		# Continue to next line
		next_dialog_line()
	else:
		# Start new dialog
		change_state(NPCState.TALKING)
		current_dialog_index = 0
		dialog_started.emit(npc_name)
		_show_dialog_line(dialog_lines[0])


func next_dialog_line() -> void:
	current_dialog_index += 1
	
	if current_dialog_index >= dialog_lines.size():
		end_dialog()
	else:
		_show_dialog_line(dialog_lines[current_dialog_index])


func end_dialog() -> void:
	dialog_finished.emit()
	change_state(NPCState.IDLE)
	current_dialog_index = 0


func _show_dialog_line(text: String) -> void:
	print(npc_name, ": ", text)
	# Emit signal untuk UI dialog box
	# DialogManager.show_dialog(npc_name, text)


# ============================================================
# INTERACTION
# ============================================================

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_player_nearby = true
		_show_interaction_prompt(true)


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_player_nearby = false
		_show_interaction_prompt(false)


func _show_interaction_prompt(show: bool) -> void:
	# Show "Press E to talk" prompt
	# Implement dengan UI Label atau sprite
	print("Interaction prompt: ", show)


## Called when player uses tool on this NPC
func on_tool_used(tool_name: String) -> void:
	match tool_name:
		"magnifying_glass":
			_on_inspected()
		"scanner":
			_on_scanned()
		_:
			print("Unknown tool: ", tool_name)


func _on_inspected() -> void:
	npc_inspected.emit(self)
	print(npc_name, " was inspected!")
	
	# Show info or special dialog
	_show_dialog_line("You're looking at me closely...")


func _on_scanned() -> void:
	print(npc_name, " was scanned!")
	# Show scan results


# ============================================================
# AI BEHAVIORS (Advanced)
# ============================================================

func look_at_player() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player and sprite:
		sprite.flip_h = player.global_position.x < global_position.x


func flee_from_player(flee_speed: float = 100.0) -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player:
		var direction = (global_position - player.global_position).normalized()
		global_position += direction * flee_speed * get_process_delta_time()


func follow_player(follow_speed: float = 50.0) -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player:
		var direction = (player.global_position - global_position).normalized()
		global_position += direction * follow_speed * get_process_delta_time()


# ============================================================
# QUEST SYSTEM
# ============================================================

var has_quest: bool = false
var quest_completed: bool = false

func give_quest() -> void:
	if has_quest and not quest_completed:
		print(npc_name, " gives you a quest!")
		# QuestManager.add_quest("collect_items", self)


func complete_quest() -> void:
	quest_completed = true
	print(npc_name, ": Thank you for completing my quest!")
	# Give reward


# ============================================================
# UTILITY
# ============================================================

func get_npc_info() -> Dictionary:
	return {
		"name": npc_name,
		"position": global_position,
		"state": NPCState.keys()[current_state],
		"dialog_index": current_dialog_index
	}


func set_npc_data(data: Dictionary) -> void:
	if data.has("name"):
		npc_name = data.name
	if data.has("dialog_lines"):
		dialog_lines = data.dialog_lines


# ============================================================
# DEBUG
# ============================================================

func _draw() -> void:
	if OS.is_debug_build():
		# Draw interaction radius
		draw_circle(Vector2.ZERO, 50, Color(0, 1, 0, 0.2))
		
		# Draw patrol path
		draw_line(
			Vector2(-patrol_distance, 0),
			Vector2(patrol_distance, 0),
			Color.YELLOW,
			2.0
		)


# ============================================================
# NOTES
# ============================================================

# Setup scene hierarchy:
# NPCCharacter (Node2D) - this script
# ├── Sprite2D
# ├── AnimationPlayer
# ├── InteractionArea (Area2D)
# │   └── CollisionShape2D (CircleShape2D radius ~50)
# └── DialogBubble (Optional)

# Usage:
# 1. Create scene dari hierarchy di atas
# 2. Attach script ini ke root node
# 3. Setup sprite & animations
# 4. Configure @export variables di Inspector
# 5. Connect signals jika perlu

# Extend dengan:
# - Shop system
# - Quest system
# - Emotion system
# - Schedule system (time-based behavior)
# - Relationship system dengan player
