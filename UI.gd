extends CanvasLayer

signal game_control_pressed

func _on_call_wave_pressed():
	game_control_pressed.emit()

func _on_pause_play_pressed():	
	game_control_pressed.emit()
	get_tree().paused = !get_tree().is_paused()

func _on_fast_forward_pressed():
	game_control_pressed.emit()
	if Engine.get_time_scale() == 2.0:
		Engine.set_time_scale(1.0)
	else :
		Engine.set_time_scale(2.0)

