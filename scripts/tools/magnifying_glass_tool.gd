extends ToolController
## MagnifyingGlassTool - Magnifier tool sebagai cursor dengan zoom lens
##
## Ketika active: cursor berubah jadi kaca pembesar yang bisa zoom area di bawah

## Flag static untuk mengindikasikan NPC sudah diinspect
static var npc_inspected: bool = false

## Zoom settings
@export var zoom_factor: float = 2.5
@export var lens_size: float = 120.0  # Diameter lens dalam pixel
@export var animation_duration: float = 0.2

var is_active: bool = false
var magnifier_viewport: SubViewport
var magnifier_camera: Camera2D
var magnifier_ui: Control
var tween: Tween = null
var magnifier_popup: Control = null

func _ready() -> void:
	print("=== MagnifierHandler _ready() START ===")
	_connect_parent_button()
	set_process(false)
	print("=== MagnifierHandler _ready() END ===")


## Dipanggil ketika tool dipilih/diaktifkan
func on_select() -> void:
	super.on_select()
	# Cursor sudah di-set oleh on_hover di base class
	if cursor_texture:
		Input.set_custom_mouse_cursor(cursor_texture, Input.CURSOR_ARROW, cursor_hotspot)


## Dipanggil ketika tool digunakan (left-click)
func on_use() -> void:
	super.on_use()
	# Tandai bahwa NPC sudah diinspect
	npc_inspected = true
	_show_magnifier_popup()


## Dipanggil ketika tool di-lower (right-click)
func on_lower() -> void:
	super.on_lower()
	_deactivate_magnifier()

func _process(_delta: float) -> void:
	if not is_active:
		return

	if not magnifier_viewport or not magnifier_camera:
		return

	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	
	# Update camera untuk zoom area di bawah cursor
	magnifier_camera.global_position = mouse_pos
	
	# Keep magnifier viewport visible during active
	magnifier_viewport.visible = true

func _setup_magnifier_viewport() -> void:
	print(">> Setting up magnifier viewport...")
	
	# Find or create magnifier UI
	magnifier_ui = get_tree().get_first_node_in_group("magnifier_ui") as Control
	if not magnifier_ui:
		print(">> WARNING: magnifier_ui group not found, creating new UI...")
		magnifier_ui = Control.new()
		magnifier_ui.add_to_group("magnifier_ui")
		get_parent().add_child(magnifier_ui)
	
	# Find or create SubViewport
	magnifier_viewport = magnifier_ui.get_node_or_null("MagnifierViewport") as SubViewport
	if not magnifier_viewport:
		print(">> Creating MagnifierViewport...")
		magnifier_viewport = SubViewport.new()
		magnifier_viewport.name = "MagnifierViewport"
		magnifier_viewport.size = Vector2i(int(lens_size), int(lens_size))
		magnifier_viewport.transparent_bg = true
		magnifier_viewport.render_target_update_mode = SubViewport.UPDATE_WHEN_VISIBLE
		magnifier_ui.add_child(magnifier_viewport)
	
	# Find or create Camera
	magnifier_camera = magnifier_viewport.get_node_or_null("MagnifierCamera") as Camera2D
	if not magnifier_camera:
		print(">> Creating MagnifierCamera...")
		magnifier_camera = Camera2D.new()
		magnifier_camera.name = "MagnifierCamera"
		magnifier_camera.zoom = Vector2(1.0 / zoom_factor, 1.0 / zoom_factor)
		magnifier_viewport.add_child(magnifier_camera)
	
	magnifier_viewport.world_2d = get_viewport().world_2d
	magnifier_viewport.visible = false
	
	print(">> Magnifier viewport setup complete!")

func _connect_parent_button() -> void:
	print(">> Looking for parent button...")
	var parent_button := get_parent()
	print(">> Parent type: ", parent_button.get_class())
	print(">> Parent name: ", parent_button.name)
	
	if parent_button is TextureButton:
		print(">> Parent is TextureButton, connecting signal...")
		parent_button.pressed.connect(_on_button_pressed)
		print(">> Signal connected!")
	else:
		push_error("MagnifierHandler parent is not a TextureButton! Parent type: ", parent_button.get_class())

func _on_button_pressed() -> void:
	print("[BUTTON CLICK] KacaPembesar clicked!")
	_show_magnifier_popup()

func _show_magnifier_popup() -> void:
	# Cari magnifier popup di scene tree
	if not magnifier_popup:
		magnifier_popup = get_tree().get_first_node_in_group("magnifier_popup")

	if magnifier_popup:
		if magnifier_popup.has_method("show_popup"):
			magnifier_popup.call("show_popup")
		else:
			magnifier_popup.visible = true
		_deactivate_magnifier()
		print("Magnifier popup opened successfully!")
	else:
		push_error("MagnifierPopup not found! Make sure it's in group 'magnifier_popup'")

func _toggle_magnifier() -> void:
	print("[TOGGLE] Current state: ", is_active, " → ", !is_active)
	is_active = not is_active
	
	if is_active:
		print("[TOGGLE] Activating magnifier...")
		_activate_magnifier()
	else:
		print("[TOGGLE] Deactivating magnifier...")
		_deactivate_magnifier()

func _activate_magnifier() -> void:
	"""Aktifkan magnifier - ubah cursor dan show zoom"""
	if magnifier_viewport:
		magnifier_viewport.visible = true
	print("[ACTIVATE] Magnifier activated!")

func _deactivate_magnifier() -> void:
	"""Nonaktifkan magnifier"""
	is_active = false
	if magnifier_viewport:
		magnifier_viewport.visible = false
	print("[DEACTIVATE] Magnifier deactivated!")
