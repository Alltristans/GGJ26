extends Node

const NAMES = ["John Smith", "Jane Doe", "Alex Kim", "Sam Lee", "Chris Wong"]
const TRAITS_INNOCENT = ["Nervous traveler", "Business person", "Tourist", "Student"]
const TRAITS_SUSPICIOUS = ["Avoiding eye contact", "Sweating", "Fake documents", "Inconsistent story"]

static func generate_npc() -> Dictionary:
var is_suspicious = randf() < 0.3
return {
"name": NAMES[randi() % NAMES.size()],
"is_suspicious": is_suspicious,
"suspicion_level": randi_range(60, 100) if is_suspicious else randi_range(0, 40),
"traits": _get_traits(is_suspicious),
"correct_action": "detain" if is_suspicious else "pass"
}

static func _get_traits(is_suspicious: bool) -> Array:
var pool = TRAITS_SUSPICIOUS if is_suspicious else TRAITS_INNOCENT
var traits = []
for i in range(2):
traits.append(pool[randi() % pool.size()])
return traits

static func generate_npc_batch(count: int) -> Array[Dictionary]:
var npcs: Array[Dictionary] = []
for i in range(count):
npcs.append(generate_npc())
return npcs
