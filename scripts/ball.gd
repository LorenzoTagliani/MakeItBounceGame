extends CharacterBody2D

var win_size : Vector2
var START_SPEED : int = 500
const ACCL : int = 25
const ACCL_OBS : int = 10
const SPEED_CAP : int = 1800
var speed : int
var dir : Vector2
const MAX_Y_VECTOR : float = 0.6

func _ready():
	#win_size = get_viewport_rect().size
	win_size.x = 1152
	win_size.y = 648

func change_start_speed(speed):
	START_SPEED = speed # Start speed della palla

func new_ball(): #Inizializza una nuova palla
	position.x = 654 #Posizione della x della palla (sempre la stessa, centro campo)
	var y_pos #inizializzazione posizione y
	if randf() < 0.5: #calcolo posizione y
		y_pos = randi_range(200, 277)
	else: 
		y_pos = randi_range(371, win_size.y - 200)
	
	position.y = y_pos 
	speed = START_SPEED
	# print("Posizione della pallina x: " + str(position.x) + ", y: " + str(position.y)), serve per debug per stampare la posizione della pallina
	dir = random_direction()
	
func _physics_process(delta: float) -> void:
	var collision = move_and_collide(dir * speed * delta)
	var collider
	if  collision:
		collider = collision.get_collider()
		if collider == $"../Player" or collider == $"../CPU":
			$"../paddleSound".play()
			if speed < SPEED_CAP:
				speed += ACCL
			dir = new_direction(collider)
		elif collider == $"../Obstacle1" or collider == $"../Obstacle2" or collider == $"../Obstacle3":
			$"../wallSound".play()
			if speed < SPEED_CAP:
				speed += ACCL_OBS
			dir = new_direction(collider)
		else:
			$"../wallSound".play()
			dir = dir.bounce(collision.get_normal())

func random_direction():
	var new_dir := Vector2()
	new_dir.x = [1, -1].pick_random()
	new_dir.y = randf_range(-1, 1)
	return new_dir.normalized()
	
func new_direction(collider):
	var ball_y = position.y
	var paddle_y = collider.position.y
	var dist = ball_y - paddle_y
	var new_dir := Vector2()
	
	# Ottieni p_height dinamicamente (aggiungi questo controllo)
	var paddle_height = 150  # Default
	if collider.has_method("get_paddle_height"):  # Aggiungi questo metodo ai paddle
		paddle_height = collider.get_paddle_height()
	
	new_dir.x = -dir.x  # Inverte la direzione X
	new_dir.y = (dist / (paddle_height / 2)) * MAX_Y_VECTOR
	return new_dir.normalized()	
	
