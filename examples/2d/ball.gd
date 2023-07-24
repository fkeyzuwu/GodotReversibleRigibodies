extends ReversibleRigidBody2D

var force := 500.0

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if !event.echo:
			if event.pressed and event.keycode == KEY_SPACE and !rewinding:
				var direction = Vector2(randf_range(-1 , 1), randf_range(-1 , 1))
				apply_central_impulse(direction * force)
			elif event.pressed and event.keycode == KEY_R:
				start_rewind()
			elif !event.pressed and event.keycode == KEY_R:
				stop_rewind()
