extends Node

class_name Game_manager

static var remaining_time: float = 100
static var is_timer_active: bool = true
static var score: int = 0

# Scoring multipliers and penalties
static var TIME_MULTIPLIER: int = 5
static var COIN_VALUE: int = 10
static var DIAMOND_VALUE: int = 50
static var HP_BONUS: int = 20
static var HEALTH_PENALTY: int = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_timer()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_timer_active:
		update_timer(delta)

func start_timer() -> void:
	is_timer_active = true
	print("Timer started. Time remaining: ", remaining_time)

func stop_timer() -> void:
	is_timer_active = false
	print("Timer stopped. Final time: ", remaining_time)

func update_timer(delta: float) -> void:
	if remaining_time > 0.0:
		remaining_time = max(remaining_time - delta, 0.0)
		if remaining_time == 0.0:
			on_time_up()

func on_time_up() -> void:
	stop_timer()
	handle_game_over()

# Improved scoring system with bonus and penalties
func calculate_score() -> void:
	var time_bonus = remaining_time * TIME_MULTIPLIER
	var coin_points = Player_data.coin * COIN_VALUE
	var diamond_points = Player_data.diamond * DIAMOND_VALUE
	var health_bonus = max(Player_data.hp * HP_BONUS, 0)
	var health_penalty = (4 - Player_data.hp) * HEALTH_PENALTY  # Assuming max HP is 4

	score = time_bonus + coin_points + diamond_points + health_bonus - health_penalty
	score = max(score, 0)  # Prevent negative scores
	print("Score calculated: Time Bonus = ", time_bonus, ", Coin Points = ", coin_points, 
		  ", Diamond Points = ", diamond_points, ", Health Bonus = ", health_bonus, 
		  ", Health Penalty = ", health_penalty, ", Total Score = ", score)

# Advance to the next level with score recalculation
func advance_to_next_level() -> void:
	calculate_score()
	print("Advancing to the next level with score: ", score)
	get_tree().change_scene("res://level_two.tscn")

# Handle game over scenario
func handle_game_over() -> void:
	print("Game Over! Final Score: ", score)
	get_tree().reload_current_scene()
