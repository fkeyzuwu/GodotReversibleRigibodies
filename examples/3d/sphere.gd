extends ReversibleRigidBody3D

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_R:
			start_rewind()
		elif !event.pressed and event.keycode == KEY_R:
			stop_rewind()
