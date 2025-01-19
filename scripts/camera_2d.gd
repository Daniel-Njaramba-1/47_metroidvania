extends Camera2D

@onready var player = $"../Player"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	camera_panning()
	
func camera_panning():
	position = player.position
	#limits
	var x = floor(position.x/320) * 320
	var y = floor(position.y/180) * 180
	
	position = Vector2(x,y)
	var tween := create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position", Vector2(x,y), 0.14)
	
	
