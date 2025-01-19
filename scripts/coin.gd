extends Area2D
class_name Coin

signal coin_collected

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#when active collision active, when destroyed, collision disabled
	$CollisionShape2D.disabled = false
	print("Coin Spawned")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_body_entered(body):
	if body.name == "Player":
		print("Player entered")
		$AnimationPlayer.play("Destroyed")
		Player_data.coin += 1
		await $AnimationPlayer.animation_finished
		$CollisionShape2D.disabled = true
		emit_signal("coin_collected")
		queue_free()
