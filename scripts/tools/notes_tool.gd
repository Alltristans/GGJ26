extends Node2D
## NotesTool - Tool untuk membuka catatan
##
## Menampilkan popup notes ketika diklik

signal notes_opened
signal notes_closed

## Reference ke popup notes
var notes_popup: Control = null

func _ready() -> void:
	# Connect ke parent button (Notes button)
	var parent_button = get_parent()
	if parent_button is TextureButton:
		parent_button.pressed.connect(_on_notes_clicked)
		print("NotesHandler connected to Notes button!")
	else:
		push_error("NotesHandler parent is not a TextureButton!")

func _on_notes_clicked() -> void:
	print("Notes button clicked!")
	_show_notes_popup()
	notes_opened.emit()

func _show_notes_popup() -> void:
	# Cari notes popup di scene tree
	if not notes_popup:
		notes_popup = get_tree().get_first_node_in_group("notes_popup")
	
	if notes_popup:
		notes_popup.visible = true
		print("Notes popup opened successfully!")
		# Optional: pause game
		# get_tree().paused = true
	else:
		push_error("NotesPopup not found! Make sure it's in group 'notes_popup'")

func close_notes() -> void:
	if notes_popup:
		notes_popup.visible = false
		notes_closed.emit()
		print("Notes popup closed!")
		# Optional: unpause game
		# get_tree().paused = false
