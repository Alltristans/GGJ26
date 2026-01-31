extends Node2D

@onready var npc_spawn_point: Marker2D = $NPCSpawnPoint
@onready var gameplay_ui: Control = $CanvasLayer/GameplayUI

@export var npc_scene: PackedScene

var npc_queue: Array[Dictionary] = []
var current_npc: Node2D = null
var current_npc_index: int = 0

func _ready() -> void:
	add_to_group("gameplay")
	if not npc_scene:
		npc_scene = load("res://scenes/npc/npc_character.tscn")
	_generate_npcs()
	GameplayManager.start_game()
	_spawn_next_npc()

func _generate_npcs() -> void:
	var generator = load("res://scripts/npc/npc_data_generator.gd")
	npc_queue = generator.generate_npc_batch(GameplayManager.total_npcs)
	print("Generated ", npc_queue.size(), " NPCs")

func _spawn_next_npc() -> void:
	if current_npc:
		current_npc.queue_free()
		current_npc = null

	if current_npc_index >= npc_queue.size():
		return

	current_npc = npc_scene.instantiate()
	add_child(current_npc)

	if npc_spawn_point:
		current_npc.global_position = npc_spawn_point.global_position
	else:
		current_npc.global_position = Vector2(960, 400)

	var npc_data = npc_queue[current_npc_index]
	current_npc.initialize(npc_data)

	if gameplay_ui:
		gameplay_ui.set_current_npc(current_npc)

	current_npc_index += 1
	print("Spawned: ", npc_data.get("name", "Unknown"))

func on_decision_made() -> void:
	await get_tree().create_timer(1.0).timeout
	_spawn_next_npc()
