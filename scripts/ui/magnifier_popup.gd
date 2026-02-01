extends Control
## MagnifierPopup - Popup dengan zoom area di glasses

@onready var glasses_image: TextureRect = $GlassesImage
@onready var zoom_viewport: SubViewport = $GlassesImage/ZoomViewport
var glasses_texture: Texture2D
var zoom_level: float = 1.0
var zoom_max: float = 3.0
var zoom_min: float = 1.0
var meja_node: Node = null
var original_scale: Vector2 = Vector2.ONE
var original_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	visible = false
	glasses_texture = glasses_image.texture
	
	# Cari node Meja di scene
	var gameplay_layer = get_tree().get_first_node_in_group("gameplay_layer")
	
	if gameplay_layer:
		meja_node = gameplay_layer
		print("Gameplay layer found: ", meja_node.name)
	else:
		# Jika tidak ada group, cari Meja langsung
		meja_node = get_tree().root.find_child("Meja", true, false)
		if meja_node:
			print("Meja found: ", meja_node.name)
	
	if meja_node:
		original_scale = meja_node.scale
		if meja_node is Node2D or meja_node is Control:
			original_position = meja_node.position
	else:
		push_error("Meja node not found!")

func _input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_cancel"):
		hide_popup()
		get_viewport().set_input_as_handled()
	
	# Klik kanan untuk kembali
	if visible and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		hide_popup()
		get_viewport().set_input_as_handled()
	
	# Scroll untuk zoom di area glasses
	if visible and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			zoom_level = min(zoom_max, zoom_level + 0.2)
			update_zoom()
			print("Zoom in: ", zoom_level)
			get_viewport().set_input_as_handled()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			zoom_level = max(zoom_min, zoom_level - 0.2)
			update_zoom()
			print("Zoom out: ", zoom_level)
			get_viewport().set_input_as_handled()

func _process(_delta: float) -> void:
	if visible:
		# Update posisi glasses mengikuti mouse
		glasses_image.global_position = get_global_mouse_position() - Vector2(glasses_texture.get_width() / 2, glasses_texture.get_height() / 2)
		
		# Update zoom secara real-time saat zoom aktif
		if zoom_level > 1.0:
			update_zoom()

func update_zoom() -> void:
	if not meja_node:
		return
	
	var mouse_pos = get_global_mouse_position()
	
	# Zoom node
	meja_node.scale = original_scale * zoom_level
	
	# Offset untuk zoom terpusat di posisi mouse
	if meja_node is Node2D or meja_node is Control:
		var offset = (mouse_pos - original_position) * (zoom_level - 1.0)
		meja_node.position = original_position - offset
	elif meja_node is CanvasLayer:
		var offset = mouse_pos * (zoom_level - 1.0)
		meja_node.offset = -offset

func show_popup() -> void:
	visible = true
	print("Magnifier activated - zoom area active!")
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	zoom_level = 1.0
	
	# Simpan state original
	if meja_node:
		original_scale = meja_node.scale
		if meja_node is Node2D or meja_node is Control:
			original_position = meja_node.position
		print("Original saved - Scale: ", original_scale)

func hide_popup() -> void:
	visible = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	# Restore state original
	if meja_node:
		meja_node.scale = original_scale
		if meja_node is Node2D or meja_node is Control:
			meja_node.position = original_position
		elif meja_node is CanvasLayer:
			meja_node.offset = Vector2.ZERO
		print("Restored to original state")
	
	print("Magnifier closed!")

func _on_overlay_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		hide_popup()
