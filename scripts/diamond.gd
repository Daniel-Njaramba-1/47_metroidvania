extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#when active collision active, when destroyed, collision disabled
	$CollisionShape2D.disabled = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_body_entered(body):
	if body.name == "Player":
		Player_data.diamond += 1
		$CollisionShape2D.disabled = true
		$Sprite2D.visible = false
		queue_free()
