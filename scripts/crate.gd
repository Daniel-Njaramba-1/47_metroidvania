extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#crate_collider enabled by default
	$crate_collider.disabled = false
	#hitbox_collider enabled by default
	$hitbox/hitbox_collider.disabled = false
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.name == "Sword":
		$AnimationPlayer.play("Destroyed")
		#disable hitbox_collider
		$hitbox/hitbox_collider.disabled = true
		#disable crate_collider
		$crate_collider.disabled = true
		await $AnimationPlayer.animation_finished
		queue_free()
