extends Control
## ButtonHoverEffect - Effect untuk button hover
##
## Menangani visual dan audio feedback untuk button hover

## Scale saat hover
@export var hover_scale: Vector2 = Vector2(1.1, 1.1)

## Duration animasi
@export var animation_duration: float = 0.2

## Audio untuk hover
@export var hover_sound: AudioStreamPlayer

## Original scale
var original_scale: Vector2

## Label node untuk text
var label_node: Label


func _ready() -> void:
	original_scale = scale
	
	# Set pivot ke center untuk scale yang proper
	pivot_offset = size / 2
	
	# Cari Label child jika ada (untuk TextureButton)
	for child in get_children():
		if child is Label:
			label_node = child
			# Set layout agar Label memenuhi button
			label_node.anchors_preset = 15  # Full Rect
			label_node.offset_left = 0
			label_node.offset_top = 0
			label_node.offset_right = 0
			label_node.offset_bottom = 0
			label_node.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			label_node.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			break
	
	# Connect mouse signals
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func _on_mouse_entered() -> void:
	# Animate scale up dengan pivot di center
	var tween = create_tween()
	tween.tween_property(self, "scale", hover_scale, animation_duration)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	
	# Play hover sound
	if hover_sound:
		hover_sound.play()


func _on_mouse_exited() -> void:
	# Animate scale back to original dengan pivot di center
	var tween = create_tween()
	tween.tween_property(self, "scale", original_scale, animation_duration)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)


func _on_pressed() -> void:
	pass # Replace with function body.
