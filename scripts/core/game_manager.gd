extends Node
## GameManager - Singleton untuk mengelola state game
##
## Mengelola state high-level game seperti BOOT, MENU, INTRO, GAMEPLAY, ENDING
## Pattern Singleton memastikan hanya ada satu instance

enum GameState {
	BOOT,
	MENU,
	INTRO,
	GAMEPLAY,
	ENDING
}

## Signal yang dipancarkan ketika state game berubah
signal game_state_changed(new_state: GameState)

## Singleton instance
static var instance: Node = null

## State game saat ini
var current_state: GameState = GameState.BOOT


func _ready() -> void:
	# Implementasi Singleton
	if instance != null and instance != self:
		queue_free()
		return
	instance = self
	
	# Jangan destroy saat load scene baru
	process_mode = Node.PROCESS_MODE_ALWAYS


func _process(_delta: float) -> void:
	# Listen untuk ESC key (untuk skip logic di masa depan)
	if Input.is_action_just_pressed("ui_cancel"):
		# Skip logic akan diimplementasi di sini
		pass


## Mengubah state game dan emit signal
func change_state(new_state: GameState) -> void:
	if current_state == new_state:
		return  # Hindari state change yang redundan
	
	current_state = new_state
	game_state_changed.emit(new_state)
	
	print("Game state changed to: ", GameState.keys()[new_state])
