extends Area2D
class_name  Flag

var is_active = false

func set_flag_active(active:bool):
	is_active = active
	print("Flag active state set to ", is_active)

func _on_body_entered(body):
	if body.name == "Player" and is_active:
		print("Player entered flag whis is at ", is_active)
		print("Player scored: ", Game_manager.score)
		get_tree().change_scene_to_file("res://scenes/levels_and_score.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	is_active = false
	print("Flag initialized and set to ", is_active)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not is_active and Player_data.diamond == 1:
		set_flag_active(true)
		print("Flag activated")
