extends Control
## NotesPopup - Menampilkan gambar catatan ukuran asli

@onready var notes_image: TextureRect = $NotesImage

func _ready() -> void:
    visible = false

func _input(event: InputEvent) -> void:
    if visible and event.is_action_pressed("ui_cancel"):
        hide_popup()
        get_viewport().set_input_as_handled()

func show_popup() -> void:
    visible = true

func hide_popup() -> void:
    visible = false

func _on_overlay_input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
        hide_popup()
