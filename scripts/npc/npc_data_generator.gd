extends Node

const NAMES = ["John Smith", "Jane Doe", "Alex Kim", "Sam Lee", "Chris Wong"]
const TRAITS_INNOCENT = ["Nervous traveler", "Business person", "Tourist", "Student"]
const TRAITS_SUSPICIOUS = ["Avoiding eye contact", "Sweating", "Fake documents", "Inconsistent story"]

static func generate_npc() -> Dictionary:
var is_suspicious = randf() < 0.3
	var suspicion = randi_range(60, 100) if is_suspicious else randi_range(0, 40)
	
	# Generate visual data
	var gender = CharacterResourceManager.Gender.MALE if randf() < 0.5 else CharacterResourceManager.Gender.FEMALE
	var has_accessory = CharacterResourceManager.should_have_accessory(suspicion)
	
	return {
		"name": NAMES[randi() % NAMES.size()],
		"is_suspicious": is_suspicious,
		"suspicion_level": suspicion,
		"traits": _get_traits(is_suspicious),
		"correct_action": "detain" if is_suspicious else "pass",
		# Visual data
		"gender": gender,
		"has_accessory": has_accessory,
		"accessory_type": CharacterResourceManager.AccessoryType.MASK if has_accessory else CharacterResourceManager.AccessoryType.NONE

static func generate_npc_batch(count: int) -> Array[Dictionary]:
var npcs: Array[Dictionary] = []
for i in range(count):
npcs.append(generate_npc())
return npcs
