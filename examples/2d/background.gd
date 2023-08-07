extends Polygon2D

@export var normal_vertex_colors: PackedColorArray
@export var rewind_vertex_colors: PackedColorArray

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("rewind"):
		vertex_colors = rewind_vertex_colors
	elif event.is_action_released("rewind"):
		vertex_colors = normal_vertex_colors

