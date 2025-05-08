extends StaticBody2D

var ball_pos : Vector2
var dist : int
var move_by : int
var win_height : int
var p_height : int
var locked_movement : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	win_height = 855
	p_height = get_parent().PADDLE_SIZE_CPU * 100  # Usa il valore dal parent
	change_paddle_height()

func change_paddle_height():
	var parent = get_parent()  
	var scale_factor  = parent.PADDLE_SIZE_CPU
	
	# Applica la scala SOLO sull'asse Y (per non modificare la larghezza)
	p_height = get_parent().PADDLE_SIZE_CPU * 100
	self.scale = Vector2(1.0, scale_factor)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !locked_movement:
		ball_pos = $"../Ball".position
		dist = position.y - ball_pos.y
		if abs(dist) > get_parent().PADDLE_SPEED_CPU * delta:
			move_by = get_parent().PADDLE_SPEED_CPU * delta * (dist / abs(dist))
		else:
			move_by = dist
		position.y -= move_by
		position.y = clamp(position.y, 206 + (p_height/2), win_height - p_height / 2)

func reset_position():
	position.x = 1194
	position.y = 530
	
