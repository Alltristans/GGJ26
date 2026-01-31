extends Node
## SceneTransitionController - Mengontrol transisi antar scene
##
## Menangani fade in/out dan scene loading

## CanvasLayer untuk overlay transition
@onready var transition_overlay: ColorRect = $TransitionOverlay

## Duration transisi
@export var transition_duration: float = 0.5

## Warna overlay
@export var transition_color: Color = Color.BLACK


func _ready() -> void:
	# Setup overlay
	if not transition_overlay:
		transition_overlay = ColorRect.new()
		add_child(transition_overlay)
		transition_overlay.color = transition_color
		transition_overlay.modulate.a = 0.0
		transition_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)


## Fade to black dan load scene
func transition_to_scene(scene_path: String) -> void:
	# Fade out
	var tween = create_tween()
	tween.tween_property(transition_overlay, "modulate:a", 1.0, transition_duration)
	await tween.finished
	
	# Load scene
	get_tree().change_scene_to_file(scene_path)
	
	# Fade in
	tween = create_tween()
	tween.tween_property(transition_overlay, "modulate:a", 0.0, transition_duration)


## Fade in dari black
func fade_in() -> void:
	transition_overlay.modulate.a = 1.0
	var tween = create_tween()
	tween.tween_property(transition_overlay, "modulate:a", 0.0, transition_duration)


## Fade out ke black
func fade_out() -> void:
	var tween = create_tween()
	tween.tween_property(transition_overlay, "modulate:a", 1.0, transition_duration)
	await tween.finished
