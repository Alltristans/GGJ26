extends Node
## GameplayManager - Mengelola gameplay loop utama

signal score_changed(new_score: int)
signal timer_changed(seconds_left: int)
signal game_over(won: bool)
signal npc_processed(npc_index: int, total: int)

var score: int = 0:
set(value):
score = value
score_changed.emit(score)

var game_time_limit: int = 180
var time_remaining: int = 0
var npcs_processed: int = 0
var total_npcs: int = 8
var correct_decisions: int = 0
var wrong_decisions: int = 0
var is_game_active: bool = false
var game_timer: Timer

func _ready() -> void:
game_timer = Timer.new()
add_child(game_timer)
game_timer.timeout.connect(_on_timer_tick)

func start_game() -> void:
score = 0
npcs_processed = 0
correct_decisions = 0
wrong_decisions = 0
time_remaining = game_time_limit
is_game_active = true
game_timer.wait_time = 1.0
game_timer.start()
print("Game started!")

func end_game(won: bool) -> void:
is_game_active = false
game_timer.stop()
game_over.emit(won)
print("Game ended! Won: ", won, " Score: ", score)

func _on_timer_tick() -> void:
if not is_game_active:
return
time_remaining -= 1
timer_changed.emit(time_remaining)
if time_remaining <= 0:
end_game(false)

func add_score(amount: int) -> void:
score += amount

func process_npc(is_correct: bool) -> void:
npcs_processed += 1
if is_correct:
correct_decisions += 1
add_score(100)
else:
wrong_decisions += 1
add_score(-50)
npc_processed.emit(npcs_processed, total_npcs)
if npcs_processed >= total_npcs:
var accuracy = float(correct_decisions) / float(total_npcs)
var won = accuracy >= 0.7
end_game(won)

func get_stats() -> Dictionary:
return {
"score": score,
"npcs_processed": npcs_processed,
"total_npcs": total_npcs,
"correct": correct_decisions,
"wrong": wrong_decisions,
"time_remaining": time_remaining,
"accuracy": float(correct_decisions) / float(max(npcs_processed, 1))
}

func get_formatted_time() -> String:
var minutes = time_remaining / 60
var seconds = time_remaining % 60
return "%02d:%02d" % [minutes, seconds]
