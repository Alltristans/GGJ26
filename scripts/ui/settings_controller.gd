extends Control
## SettingsController - Mengontrol settings menu
##
## Menangani volume, graphics, dan settings lainnya

## Slider references
@export var master_volume_slider: HSlider
@export var music_volume_slider: HSlider
@export var sfx_volume_slider: HSlider

## Bus indices
const MASTER_BUS = 0
const MUSIC_BUS = 1
const SFX_BUS = 2


func _ready() -> void:
	# Load saved settings
	_load_settings()
	
	# Connect signals
	if master_volume_slider:
		master_volume_slider.value_changed.connect(_on_master_volume_changed)
	if music_volume_slider:
		music_volume_slider.value_changed.connect(_on_music_volume_changed)
	if sfx_volume_slider:
		sfx_volume_slider.value_changed.connect(_on_sfx_volume_changed)


func _on_master_volume_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(MASTER_BUS, linear_to_db(value))
	_save_settings()


func _on_music_volume_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(MUSIC_BUS, linear_to_db(value))
	_save_settings()


func _on_sfx_volume_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(SFX_BUS, linear_to_db(value))
	_save_settings()


func _save_settings() -> void:
	var config = ConfigFile.new()
	config.set_value("audio", "master_volume", master_volume_slider.value if master_volume_slider else 1.0)
	config.set_value("audio", "music_volume", music_volume_slider.value if music_volume_slider else 1.0)
	config.set_value("audio", "sfx_volume", sfx_volume_slider.value if sfx_volume_slider else 1.0)
	config.save("user://settings.cfg")


func _load_settings() -> void:
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	
	if err != OK:
		return
	
	if master_volume_slider:
		master_volume_slider.value = config.get_value("audio", "master_volume", 1.0)
	if music_volume_slider:
		music_volume_slider.value = config.get_value("audio", "music_volume", 1.0)
	if sfx_volume_slider:
		sfx_volume_slider.value = config.get_value("audio", "sfx_volume", 1.0)


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
