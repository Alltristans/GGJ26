extends Node2D
class_name NPCCharacter

var npc_data: Dictionary = {}

# References to visual nodes
@onready var character_texture: TextureRect = null
@onready var accessory_texture: TextureRect = null

signal inspected
signal decision_made(action: String, was_correct: bool)

func _ready() -> void:
	# Find texture nodes in the scene tree
	character_texture = find_child("CharacterTexture", true, false) as TextureRect
	accessory_texture = find_child("AccessoryTexture", true, false) as TextureRect

func initialize(data: Dictionary) -> void:
	npc_data = data
	
	# Update name label if exists
	if has_node("NameLabel"):
		get_node("NameLabel").text = npc_data.get("name", "Unknown")
	
	# Update character visual appearance
	_update_character_appearance()

func _update_character_appearance() -> void:
	# Update main character texture
	if character_texture:
		var gender = npc_data.get("gender", CharacterResourceManager.Gender.ANY)
		var char_texture = CharacterResourceManager.get_random_character_texture(gender)
		if char_texture:
			character_texture.texture = char_texture
			print("Set character texture for: ", npc_data.get("name", "Unknown"))
	else:
		push_warning("CharacterTexture node not found!")
	
	# Update accessory (mask, etc.)
	if accessory_texture:
		if npc_data.get("has_accessory", false):
			var accessory_type = npc_data.get("accessory_type", CharacterResourceManager.AccessoryType.NONE)
			var acc_texture = CharacterResourceManager.get_random_accessory(accessory_type)
			if acc_texture:
				accessory_texture.texture = acc_texture
				accessory_texture.visible = true
				print("Added accessory to: ", npc_data.get("name", "Unknown"))
		else:
			accessory_texture.visible = false
	else:
		push_warning("AccessoryTexture node not found!")
info += "Traits: " + ", ".join(traits)
return info

func check_decision(action: String) -> bool:
var correct_action = npc_data.get("correct_action", "pass")
var correct = (action == correct_action)
decision_made.emit(action, correct)
return correct
