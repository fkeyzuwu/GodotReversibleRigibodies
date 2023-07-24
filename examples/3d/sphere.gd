extends ReversibleRigidBody3D

@onready var mesh_instance: MeshInstance3D = $MeshInstance3D

var force := 5

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if !event.echo: #just pressed
			if event.pressed and event.keycode == KEY_SPACE and !rewinding:
				var direction = Vector3(randf_range(-1 , 1), randf_range(0 , 1), randf_range(-1 , 1))
				apply_central_impulse(direction * force)
			if event.pressed and event.keycode == KEY_R:
				start_rewind()
				mesh_instance.mesh.material.next_pass.set_shader_parameter("enable", true)
			elif !event.pressed and event.keycode == KEY_R:
				stop_rewind()
				mesh_instance.mesh.material.next_pass.set_shader_parameter("enable", false)
