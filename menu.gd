extends Control


func _on_play_pressed() -> void:
	Engine.time_scale = 1
	if get_tree().get_current_scene().get_name() == "game":
		get_tree().get_current_scene().queue_free()
	# Carica la nuova scena
	get_tree().change_scene_to_file("res://game.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
