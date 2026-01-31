extends Control

@onready var score_label: Label = $TopBar/ScoreLabel
@onready var timer_label: Label = $TopBar/TimerLabel
@onready var npc_counter_label: Label = $TopBar/NPCCounterLabel
@onready var npc_info_panel: PanelContainer = $NPCInfoPanel
@onready var npc_name_label: Label = $NPCInfoPanel/VBox/NameLabel
@onready var npc_details_label: Label = $NPCInfoPanel/VBox/DetailsLabel
@onready var pass_button: Button = $BottomBar/ActionButtons/PassButton
@onready var detain_button: Button = $BottomBar/ActionButtons/DetainButton
@onready var inspect_button: Button = $BottomBar/ToolBar/InspectButton

var current_npc: Node2D = null

func _ready() -> void:
	if GameplayManager:
		GameplayManager.score_changed.connect(_on_score_changed)
		GameplayManager.timer_changed.connect(_on_timer_changed)
		GameplayManager.npc_processed.connect(_on_npc_processed)
		GameplayManager.game_over.connect(_on_game_over)

	pass_button.pressed.connect(_on_pass_pressed)
	detain_button.pressed.connect(_on_detain_pressed)
	inspect_button.pressed.connect(_on_inspect_pressed)
	_update_ui()

func _update_ui() -> void:
	if GameplayManager:
		var stats = GameplayManager.get_stats()
		score_label.text = "Score: " + str(stats.score)
		timer_label.text = GameplayManager.get_formatted_time()
		npc_counter_label.text = "NPCs: %d/%d" % [stats.npcs_processed, stats.total_npcs]

func set_current_npc(npc: Node2D) -> void:
	current_npc = npc
	if npc:
		npc_name_label.text = npc.npc_data.get("name", "Unknown")
		npc_details_label.text = "Click Inspect to view details"
		npc_info_panel.visible = true
	else:
		npc_info_panel.visible = false

func _on_score_changed(new_score: int) -> void:
	score_label.text = "Score: " + str(new_score)

func _on_timer_changed(seconds_left: int) -> void:
	timer_label.text = GameplayManager.get_formatted_time()
	if seconds_left <= 30:
		timer_label.modulate = Color.RED
	else:
		timer_label.modulate = Color.WHITE

func _on_npc_processed(processed: int, total: int) -> void:
	npc_counter_label.text = "NPCs: %d/%d" % [processed, total]

func _on_game_over(won: bool) -> void:
	pass_button.visible = false
	detain_button.visible = false
	inspect_button.visible = false
	_show_game_over(won)

func _on_pass_pressed() -> void:
	_make_decision("pass")

func _on_detain_pressed() -> void:
	_make_decision("detain")

func _make_decision(action: String) -> void:
	if not current_npc:
		return
	var was_correct = current_npc.check_decision(action)
	GameplayManager.process_npc(was_correct)
	get_tree().call_group("gameplay", "on_decision_made")

func _on_inspect_pressed() -> void:
	if current_npc:
		npc_details_label.text = current_npc.get_inspection_info()

func _show_game_over(won: bool) -> void:
	var label = Label.new()
	label.text = "YOU WIN!" if won else "GAME OVER"
	label.add_theme_font_size_override("font_size", 48)
	label.position = get_viewport_rect().size / 2
	add_child(label)
