extends Node
## EndingManager - Mengelola ending scenes
##
## Menangani logic untuk berbagai ending berdasarkan player choices

enum EndingType {
	GOOD_ENDING,
	BAD_ENDING,
	NEUTRAL_ENDING
}

## Signal untuk ending triggered
signal ending_triggered(ending_type: EndingType)

## Current ending type
var current_ending: EndingType = EndingType.NEUTRAL_ENDING


## Trigger ending berdasarkan kondisi game
func trigger_ending(ending: EndingType) -> void:
	current_ending = ending
	ending_triggered.emit(ending)
	
	match ending:
		EndingType.GOOD_ENDING:
			_show_good_ending()
		EndingType.BAD_ENDING:
			_show_bad_ending()
		EndingType.NEUTRAL_ENDING:
			_show_neutral_ending()


func _show_good_ending() -> void:
	print("Good ending!")
	# Load good ending scene
	get_tree().change_scene_to_file("res://scenes/endings/good_ending.tscn")


func _show_bad_ending() -> void:
	print("Bad ending!")
	# Load bad ending scene
	get_tree().change_scene_to_file("res://scenes/endings/bad_ending.tscn")


func _show_neutral_ending() -> void:
	print("Neutral ending!")
	# Load neutral ending scene
	get_tree().change_scene_to_file("res://scenes/endings/neutral_ending.tscn")
