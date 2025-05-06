extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Prova a forzare l'altezza in uno script
	var label = get_node("LaTuaLabel")
	label.custom_minimum_size.y = 50  # Valore desiderato
	label.size.y = 50

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
