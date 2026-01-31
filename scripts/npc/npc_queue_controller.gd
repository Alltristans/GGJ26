extends Node2D
## NPCQueueController - Mengelola queue NPCs
##
## Mengatur spawning dan management NPC dalam antrian

## Signal dipancarkan ketika NPC terakhir tercapai
signal last_npc_reached

## Prefab/Scene NPC
@export var npc_scene: PackedScene

## Queue NPCs
var npc_queue: Array[Node2D] = []

## Maksimum jumlah NPCs dalam queue
const MAX_NPCS: int = 8

## Index NPC saat ini
var current_npc_index: int = 0


func _ready() -> void:
	# Inisialisasi queue dengan NPCs
	for i in range(MAX_NPCS):
		if npc_scene:
			var npc = npc_scene.instantiate()
			add_child(npc)
			npc.visible = false  # Sembunyikan NPC sampai dibutuhkan
			npc_queue.append(npc)
	
	# Spawn NPC pertama
	spawn_next_npc()


## Spawn NPC berikutnya dalam queue
func spawn_next_npc() -> void:
	if npc_queue.size() > 0:
		var next_npc = npc_queue.pop_front()
		next_npc.visible = true
		current_npc_index += 1
		
		# Check apakah ini NPC terakhir
		if current_npc_index == MAX_NPCS:
			last_npc_reached.emit()


## Memungkinkan player untuk pass NPC saat ini immediately
func pass_current_npc() -> void:
	if npc_queue.size() > 0:
		spawn_next_npc()
