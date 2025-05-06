extends Sprite2D

var score := [0, 0] # 0:Player, 1: CPU
var PADDLE_SPEED_PLAYER := 650
var PADDLE_SPEED_CPU := 350
var PADDLE_SIZE_PLAYER := 1.5
var PADDLE_SIZE_CPU := 0.7
var current_level := 1
var current_lives := 2
var paused := false
var pause_menu
var game_started := false
var current_needed_points := 3
var dialog_counter := 1

var themes := {
	1: Theme.new(),  # Beige
	2: Theme.new(),  # Red
	3: Theme.new(),  # Green
	4: Theme.new(),  # Blue
	5: Theme.new(),  # Yellow
	6: Theme.new(),  # Pink
	7: Theme.new(),  # Petrol
	8: Theme.new()  # Purple
}

var dialogs := {
	1: "You can see your stats
		on the bottom left
		corner.", 
	2: "Use ARROW UP and
		ARROW DOWN to move your
		paddle.",
	3: "The first to reach 
		THREE
		points wins the round.",
	4: "After you win a round,
		the level gets up and
		the game get harder.",
	5: "On the bottom right you
		can see your lives.
		Each time you loose a
		red cross appear.",
	6: "After three loses,
		it's game over.",
	7: "That's all, have fun.",
	8: "",
	9: "It looks like you're
		doing okay even though
		I'm increasing the
		difficulty...",
	10: "Let's do this, from
		now on you'll need to
		get FIVE points to win
		a round.",
	11: "Sounds good?", 
	12: "Cool, let's have
		some fun.",
	13: "",
	14: ""
}

var textureBgBorder := {
	1: preload("res://assets/border_beige.png"),  # Beige
	2: preload("res://assets/border_red.png"),    # Red
	3: preload("res://assets/border_green.png"),    # Green
	4: preload("res://assets/border_blue.png"),   # Blue
	5: preload("res://assets/border_yellow.png"),  # Yellow
	6: preload("res://assets/border_pink.png"),     # Pink
	7: preload("res://assets/border_petrol.png"),  # Petrol
	8: preload("res://assets/border_purple.png")     # Purple
}

var textureBgScore := {
	1: preload("res://assets/score_beige.png"),  # Beige
	2: preload("res://assets/score_red.png"),    # Red
	3: preload("res://assets/score_green.png"),    # Green
	4: preload("res://assets/score_blue.png"),   # Blue
	5: preload("res://assets/score_yellow.png"),  # Yellow
	6: preload("res://assets/score_pink.png"),     # Pink
	7: preload("res://assets/score_petrol.png"),  # Petrol
	8: preload("res://assets/score_purple.png")     # Purple
}

func _ready():
	if $BallTimer.timeout.is_connected(_on_ball_timer_timeout):
		$BallTimer.timeout.disconnect(_on_ball_timer_timeout)
		$BallTimer.timeout.connect(_on_ball_timer_timeout)
	$Hud/LevelNumber.text = str(current_level)
	setup_themes_and_textures()
	set_level_color()
	set_stats()
	$Hud/FirstLife.hide()
	$Hud/SecondLife.hide()
	pause_menu = $PauseMenu
	pause_menu.resume_pressed.connect(Callable(self, "_on_pause_menu_resume"))
	pause_menu.quit_pressed.connect(Callable(self, "_on_quit_pressed"))
	$Obstacle1.get_node("CollisionShape2D").disabled = true
	$Obstacle2.get_node("CollisionShape2D").disabled = true
	$Obstacle3.get_node("CollisionShape2D").disabled = true
	
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		show_pause_menu()
	if Input.is_action_just_pressed("start_game"):
		if !game_started and dialog_counter < 15:
			$DialogBox.text = dialogs[dialog_counter];
			dialog_counter += 1;
			if !game_started and (dialog_counter == 9 or dialog_counter == 14):
				game_started = true
				$PressSpaceToStart.hide()
				$BallTimer.start()

func show_pause_menu():
	if paused:
		$PauseMenu.hide()
		Engine.time_scale = 1
		paused = false
	else:
		$PauseMenu.show()
		Engine.time_scale = 0
		paused = true

func _on_pause_menu_resume():
	show_pause_menu()

func _on_quit_pressed():
	$BallTimer.stop()
	get_tree().change_scene_to_file("res://mainMenu.tscn")

func _on_ball_timer_timeout() -> void:
	$Ball.new_ball()
	$CPU.locked_movement = false
	$Ball.show()

func setup_themes_and_textures():
	themes[1].set_color("font_color", "Label", Color("#ffad63")) # Beige
	$BgBorder.texture = textureBgBorder[1]
	$BgScore.texture = textureBgBorder[1]
	
	themes[2].set_color("font_color", "Label", Color("#fe0000")) # Red
	themes[3].set_color("font_color", "Label", Color("#51ff00")) # Green
	themes[4].set_color("font_color", "Label", Color("#0000fe")) # Blue 
	themes[5].set_color("font_color", "Label", Color("#ffff00")) # Yellow
	themes[6].set_color("font_color", "Label", Color("#ff00fe")) # Pink
	themes[7].set_color("font_color", "Label", Color("#008486")) # Petrol
	themes[8].set_color("font_color", "Label", Color("#5b315b")) # Purple
	set_level_color()

func set_level_color():
	if current_level in themes:
		$Hud/LevelNumber.theme = themes[current_level]
		$BgBorder.texture = textureBgBorder[current_level]
		$BgScore.texture = textureBgScore[current_level]
	else:
		current_level = 1  # Resetta se il livello non esiste
		$Hud/LevelNumber.theme = themes[1]
		$BgBorder.texture = textureBgBorder[1]
		$BgScore.texture = textureBgScore[1]

func set_stats():
	match current_level:
		1:
			PADDLE_SPEED_PLAYER = 750
			PADDLE_SPEED_CPU = 350
			$Hud/PlayerSpeedINT.text = str(75)
			$Hud/CPUSpeedINT.text = str(35)
			PADDLE_SIZE_PLAYER = 1.5
			PADDLE_SIZE_CPU = 0.6
			$Hud/PlayerSizeINT.text = str(15)
			$Hud/CPUSizeINT.text = str(6)
			$Player.change_paddle_height()
			$CPU.change_paddle_height()
			$Ball.change_start_speed(500)
		2:
			PADDLE_SPEED_PLAYER = 700
			PADDLE_SPEED_CPU = 350
			$Hud/PlayerSpeedINT.text = str(70)
			$Hud/CPUSpeedINT.text = str(35)
			PADDLE_SIZE_PLAYER = 1.4
			PADDLE_SIZE_CPU = 0.7
			$Hud/PlayerSizeINT.text = str(14)
			$Hud/CPUSizeINT.text = str(7)
			$Player.change_paddle_height()
			$CPU.change_paddle_height()
			$Ball.change_start_speed(550)
		3:
			PADDLE_SPEED_PLAYER = 700
			PADDLE_SPEED_CPU = 375
			$Hud/PlayerSpeedINT.text = str(70)
			$Hud/CPUSpeedINT.text = str(37)
			PADDLE_SIZE_PLAYER = 1.3
			PADDLE_SIZE_CPU = 0.7
			$Hud/PlayerSizeINT.text = str(13)
			$Hud/CPUSizeINT.text = str(8)
			$Player.change_paddle_height()
			$CPU.change_paddle_height()
			$Ball.change_start_speed(550)
		4:
			PADDLE_SPEED_PLAYER = 650
			PADDLE_SPEED_CPU = 415
			$Hud/PlayerSpeedINT.text = str(65)
			$Hud/CPUSpeedINT.text = str(41)
			PADDLE_SIZE_PLAYER = 1.3
			PADDLE_SIZE_CPU = 0.7
			$Hud/PlayerSizeINT.text = str(13)
			$Hud/CPUSizeINT.text = str(9)
			$Player.change_paddle_height()
			$CPU.change_paddle_height()
			$Ball.change_start_speed(600)
		5:
			PADDLE_SPEED_PLAYER = 650
			PADDLE_SPEED_CPU = 430
			$Hud/PlayerSpeedINT.text = str(65)
			$Hud/CPUSpeedINT.text = str(43)
			PADDLE_SIZE_PLAYER = 1.2
			PADDLE_SIZE_CPU = 0.8
			$Hud/PlayerSizeINT.text = str(12)
			$Hud/CPUSizeINT.text = str(8)
			$Player.change_paddle_height()
			$CPU.change_paddle_height()
			$Ball.change_start_speed(600)
		6:
			PADDLE_SPEED_PLAYER = 600
			PADDLE_SPEED_CPU = 450
			$Hud/PlayerSpeedINT.text = str(60)
			$Hud/CPUSpeedINT.text = str(45)
			PADDLE_SIZE_PLAYER = 1.2
			PADDLE_SIZE_CPU = 0.8
			$Hud/PlayerSizeINT.text = str(12)
			$Hud/CPUSizeINT.text = str(8)
			$Player.change_paddle_height()
			$CPU.change_paddle_height()
			$Ball.change_start_speed(650)
		7:
			PADDLE_SPEED_PLAYER = 600
			PADDLE_SPEED_CPU = 450
			$Hud/PlayerSpeedINT.text = str(60)
			$Hud/CPUSpeedINT.text = str(45)
			PADDLE_SIZE_PLAYER = 1.2
			PADDLE_SIZE_CPU = 0.9
			$Hud/PlayerSizeINT.text = str(12)
			$Hud/CPUSizeINT.text = str(9)
			$Player.change_paddle_height()
			$CPU.change_paddle_height()
			$NetCover.show()
			$Obstacle1.show()
			$Obstacle1.get_node("CollisionShape2D").set_deferred("disabled", false)
			$Ball.change_start_speed(650)
		8:
			PADDLE_SPEED_PLAYER = 550
			PADDLE_SPEED_CPU = 475
			$Hud/PlayerSpeedINT.text = str(55)
			$Hud/CPUSpeedINT.text = str(50)
			PADDLE_SIZE_PLAYER = 1.2
			PADDLE_SIZE_CPU = 0.9
			$Hud/PlayerSizeINT.text = str(12)
			$Hud/CPUSizeINT.text = str(9)
			$Player.change_paddle_height()
			$CPU.change_paddle_height()
			$NetCover.show()
			$Obstacle1.hide()
			$Obstacle1.get_node("CollisionShape2D").set_deferred("disabled", true)
			$Obstacle2.show()
			$Obstacle2.get_node("CollisionShape2D").set_deferred("disabled", false)
			$Obstacle3.show()
			$Obstacle3.get_node("CollisionShape2D").set_deferred("disabled", false)
			$Ball.change_start_speed(700)

func _on_score_left_body_entered(body: Node2D) -> void:
	$scoreCPUSound.play()
	score[1] += 1
	$Hud/CPU.text = str(score[1])
	$Ball.hide()
	$Player.reset_position()
	$CPU.reset_position()
	round_end()

func _on_score_right_body_entered(body: Node2D) -> void:
	$scoreSound.play()
	score[0] += 1
	$Hud/PlayerScore.text = str(score[0])
	$Ball.hide()
	$Player.reset_position()
	$CPU.reset_position()
	round_end()

func round_end():
	if score[0] >= current_needed_points:
		if current_level < 8:
			score[0] = 0
			score [1] = 0
			current_level += 1
			$Hud/LevelNumber.text = str(current_level)
			$Hud/CPU.text = str(0)
			$Hud/PlayerScore.text = str(0)
			set_level_color()
			set_stats()
			$CPU.locked_movement = true
			$BallTimer.start()
			if current_level > 5:
				current_needed_points = 5
				if current_level == 6:
					$BallTimer.stop()
					game_started = false
					$PressSpaceToStart.show()
					$DialogBox.text = dialogs[dialog_counter];
					dialog_counter += 1;
		elif current_level >= 8:
			$BallTimer.stop()
			get_tree().change_scene_to_file("res://game_completed.tscn")
		
	elif score[1] >= current_needed_points:
		score[0] = 0
		score [1] = 0
		$Hud/CPU.text = str(0)
		$Hud/PlayerScore.text = str(0)
		if current_lives == 2:
			current_lives -= 1
			$Hud/FirstLife.show()
			set_stats()
			$CPU.locked_movement = true
			$BallTimer.start()
		elif current_lives == 1:
			current_lives -= 1
			$Hud/SecondLife.show()
			set_stats()
			$CPU.locked_movement = true
			$BallTimer.start()
		elif current_lives == 0:
			$CPU.locked_movement = true
			get_tree().change_scene_to_file("res://game_over.tscn")
	else:
		$CPU.locked_movement = true
		$BallTimer.start()
