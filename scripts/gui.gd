extends CanvasLayer

const HEART_ROW_SIZE = 8
const HEART_OFFSET = 16

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#setup hearts
	for i in Player_data.hp:
		var new_heart = Sprite2D.new()
		new_heart.texture = $heart.texture
		new_heart.hframes = $heart.hframes
		$heart.add_child(new_heart)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$coin_number.text = var_to_str(Player_data.coin)
	$diamond_number.text = var_to_str(Player_data.diamond)
	$time_number.text = format_time(Game_manager.remaining_time)
	display_heart()

func display_heart():
	for heart in $heart.get_children():
		var index = heart.get_index()
		var x = (index % HEART_ROW_SIZE) * HEART_OFFSET
		var y = (index / HEART_ROW_SIZE) * HEART_OFFSET
		heart.position = Vector2(x,y)
		
		var last_heart = floor(Player_data.hp)
		if index > last_heart:
			heart.frame = 0
		if index == last_heart:
			heart.frame = (Player_data.hp - last_heart) * 4
		if index < last_heart:
			heart.frame = 4
		
func format_time(seconds:int) -> String:
	var total_seconds = int(seconds)
	var minutes = total_seconds / 60
	var remaining_seconds = seconds % 60
	return "%02d:%02d" % [minutes, remaining_seconds]
