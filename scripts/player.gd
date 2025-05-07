extends StaticBody2D

var win_height : int
var p_height : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	win_height = 648
	p_height = get_parent().PADDLE_SIZE_PLAYER * 100  # Inizializza p_height
	change_paddle_height()

func change_paddle_height():
	var parent = get_parent()  
	var scale_factor  = parent.PADDLE_SIZE_PLAYER
	
	# Applica la scala SOLO sull'asse Y (per non modificare la larghezza)
	p_height = get_parent().PADDLE_SIZE_PLAYER * 100
	self.scale = Vector2(1.0, scale_factor)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_up"):
		position.y -= get_parent().PADDLE_SPEED_PLAYER * delta
	elif Input.is_action_pressed("ui_down"):
		position.y += get_parent().PADDLE_SPEED_PLAYER * delta
	
	position.y = clamp(position.y, p_height / 2, win_height - p_height / 2)

func reset_position():
	position.x = -256
	position.y = 324
