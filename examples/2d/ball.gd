extends RigidBody2D

var force := 500.0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("apply_ball_force"):
		var direction = Vector2(randf_range(-1 , 1), randf_range(-1 , 1))
		apply_central_impulse(direction * force)
