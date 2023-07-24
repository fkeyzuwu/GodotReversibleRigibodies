extends ReversibleRigidBody3D

@onready var mesh_instance: MeshInstance3D = $MeshInstance3D

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_R:
			start_rewind()
			mesh_instance.mesh.material.next_pass.set_shader_parameter("enable", true)
		elif !event.pressed and event.keycode == KEY_R:
			stop_rewind()
			mesh_instance.mesh.material.next_pass.set_shader_parameter("enable", false)
