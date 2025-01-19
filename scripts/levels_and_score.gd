extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$score/score.visible = false
	$score/score_number.visible = false
	#display_score()
	#$score_number.text = var_to_str(Player_data.diamond)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	display_score()

func display_score() -> void:
	$score/score_number.text = "Score: " + var_to_str(Game_manager.score)
		
func _on_level_1_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_one.tscn")


func _on_level_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_two.tscn")
	
