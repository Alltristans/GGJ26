extends Control
## CutsceneController - Mengontrol cutscene playback
##
## Menangani dialog, animasi, dan transisi cutscene

## Signal untuk cutscene selesai
signal cutscene_finished

## Array of dialog texts
@export var dialog_lines: Array[String] = []

## Current dialog index
var current_line: int = 0

## Label untuk menampilkan dialog
@export var dialog_label: Label

## Speed typing effect
@export var typing_speed: float = 0.05


func _ready() -> void:
	if dialog_lines.size() > 0:
		show_next_line()


func _input(event: InputEvent) -> void:
	# Skip to next line dengan click atau space
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_left_click"):
		show_next_line()


## Tampilkan dialog line berikutnya
func show_next_line() -> void:
	if current_line >= dialog_lines.size():
		cutscene_finished.emit()
		return
	
	if dialog_label:
		var line = dialog_lines[current_line]
		_type_text(line)
	
	current_line += 1


## Typing effect untuk dialog
func _type_text(text: String) -> void:
	dialog_label.text = ""
	
	for i in range(text.length()):
		dialog_label.text += text[i]
		await get_tree().create_timer(typing_speed).timeout
