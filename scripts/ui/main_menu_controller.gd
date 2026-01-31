extends Control
## MainMenuController - Mengontrol main menu UI
##
## Menangani button clicks dan feedback untuk menu utama

## Reference ke animator untuk feedback
@export var button_animator: AnimationPlayer

## AudioStreamPlayer untuk interaksi button
@export var hover_audio: AudioStreamPlayer
@export var click_audio: AudioStreamPlayer


## Dipanggil ketika button Start diklik
func _on_start_clicked() -> void:
	_play_click_feedback()
	# Load intro atau gameplay scene
	get_tree().change_scene_to_file("res://scenes/gameplay/gameplay.tscn")


## Dipanggil ketika button Settings diklik
func _on_settings_clicked() -> void:
	_play_click_feedback()
	# Load settings scene atau popup
	# get_tree().change_scene_to_file("res://scenes/ui/settings.tscn")
	print("Settings clicked - implement settings scene")


## Dipanggil ketika button Guide diklik
func _on_guide_clicked() -> void:
	_play_click_feedback()
	# Load guide scene atau popup
	print("Guide clicked - implement guide scene")


## Dipanggil ketika button Exit diklik
func _on_exit_clicked() -> void:
	_play_click_feedback()
	get_tree().quit()


## Dipanggil ketika button di-hover
func _on_button_hover() -> void:
	if button_animator:
		button_animator.play("hover")
	
	if hover_audio:
		hover_audio.play()


## Play click feedback
func _play_click_feedback() -> void:
	if button_animator:
		button_animator.play("click")
	
	if click_audio:
		click_audio.play()
