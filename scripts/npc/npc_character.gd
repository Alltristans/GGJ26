extends Node2D
class_name NPCCharacter

var npc_data: Dictionary = {}

signal inspected
signal decision_made(action: String, was_correct: bool)

func initialize(data: Dictionary) -> void:
npc_data = data
if has_node("NameLabel"):
get_node("NameLabel").text = npc_data.get("name", "Unknown")

func get_inspection_info() -> String:
var info = "Name: " + npc_data.get("name", "Unknown") + "\n"
info += "Suspicion: " + str(npc_data.get("suspicion_level", 0)) + "%\n"
var traits = npc_data.get("traits", [])
info += "Traits: " + ", ".join(traits)
return info

func check_decision(action: String) -> bool:
var correct_action = npc_data.get("correct_action", "pass")
var correct = (action == correct_action)
decision_made.emit(action, correct)
return correct
