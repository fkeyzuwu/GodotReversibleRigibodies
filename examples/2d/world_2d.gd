extends Node2D

@onready var background: Polygon2D = $Walls/Background
@export var normal_background_color := Color(0.353, 0.671, 0.592)
@export var rewind_background_color := Color(0.169, 0.675, 0.729)

func _ready() -> void:
	background.color = normal_background_color

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_R:
			background.color = rewind_background_color
		elif !event.pressed and event.keycode == KEY_R:
			background.color = normal_background_color
