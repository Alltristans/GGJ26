extends Node
## MagnifierTool - Tool untuk membuka popup kaca pembesar

signal magnifier_opened
signal magnifier_closed

var magnifier_popup: Control = null

func _ready() -> void:
	var parent_button = get_parent()
	if parent_button is TextureButton:
		parent_button.pressed.connect(_on_glasses_clicked)
		print("MagnifierHandler connected to KacaPembesar button!")
	else:
		push_error("MagnifierHandler parent is not a TextureButton!")

func _on_glasses_clicked() -> void:
	print("Glasses button clicked!")
	_show_magnifier_popup()
	magnifier_opened.emit()

func _show_magnifier_popup() -> void:
	if not magnifier_popup:
		magnifier_popup = get_tree().get_first_node_in_group("magnifier_popup")
	
	if magnifier_popup:
		magnifier_popup.visible = true
		print("Magnifier popup opened successfully!")
	else:
		push_error("MagnifierPopup not found! Make sure it's in group 'magnifier_popup'")

func close_magnifier() -> void:
	if magnifier_popup:
		magnifier_popup.visible = false
		magnifier_closed.emit()
		print("Magnifier popup closed!")
