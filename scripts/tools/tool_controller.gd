extends Node2D
## ToolController - Base class untuk semua tools
##
## Menangani hover, select, deselect, dan input untuk aksi use/lower

class_name ToolController

## Flag untuk menentukan apakah tool bisa di-lower dengan right-click
@export var can_be_lowered: bool = true

## AudioStreamPlayer untuk sound effects
@export var use_audio: AudioStreamPlayer
@export var lower_audio: AudioStreamPlayer

## Cursor texture untuk tool ini
@export var cursor_texture: Texture2D
@export var cursor_hotspot: Vector2 = Vector2.ZERO


## Dipanggil ketika tool di-hover
func on_hover() -> void:
	if cursor_texture:
		Input.set_custom_mouse_cursor(cursor_texture, Input.CURSOR_ARROW, cursor_hotspot)


## Dipanggil ketika tool dipilih
func on_select() -> void:
	# Logic tambahan dapat diimplementasikan di class turunan
	pass


## Dipanggil ketika tool di-deselect
func on_deselect() -> void:
	Input.set_custom_mouse_cursor(null)


## Dipanggil ketika tool digunakan (left-click)
func on_use() -> void:
	if use_audio:
		use_audio.play()


## Dipanggil ketika tool di-lower (right-click)
func on_lower() -> void:
	if can_be_lowered and lower_audio:
		lower_audio.play()


## Override method ini di class turunan untuk input handling
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		
		if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
			on_use()
		elif mouse_event.button_index == MOUSE_BUTTON_RIGHT and mouse_event.pressed:
			on_lower()
