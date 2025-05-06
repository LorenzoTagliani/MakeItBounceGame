extends Control

signal resume_pressed
signal options_pressed
signal quit_pressed

func _ready():
	$ColorRect/MarginContainer/VBoxContainer/Resume.connect("pressed", Callable(self, "_on_resume_pressed"))
	$ColorRect/MarginContainer/VBoxContainer/Quit.connect("pressed", Callable(self, "_on_quit_pressed"))

func _on_resume_pressed():
	emit_signal("resume_pressed")

func _on_quit_pressed():
	emit_signal("quit_pressed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
