extends RigidBody2D

var force := 500.0

var position_buffer: PackedVector2Array
var rotation_buffer: PackedFloat32Array
var linear_velocity_buffer: PackedVector2Array
var angular_velocity_buffer: PackedFloat32Array

var buffer_size := 1024
var buffer_index := 0

var rewinding := false

@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D

func _ready() -> void:
	position_buffer.resize(buffer_size)
	rotation_buffer.resize(buffer_size)
	linear_velocity_buffer.resize(buffer_size)
	angular_velocity_buffer.resize(buffer_size)

func _physics_process(_delta: float) -> void:
	if rewinding: return
	
	position_buffer[buffer_index] = global_position
	rotation_buffer[buffer_index] = rotation
	linear_velocity_buffer[buffer_index] = linear_velocity
	angular_velocity_buffer[buffer_index] = angular_velocity
	buffer_index += 1
	buffer_index %= buffer_size
	
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if !rewinding: return
	
	buffer_index -= 1
	buffer_index %= 1024
	state.transform = Transform2D(rotation_buffer[buffer_index], position_buffer[buffer_index])

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("apply_ball_force"):
		var direction = Vector2(randf_range(-1 , 1), randf_range(-1 , 1))
		apply_central_impulse(direction * force)
	elif event.is_action_pressed("rewind"):
		rewinding = true
		collision_polygon_2d.set_deferred("disabled", true)
	elif event.is_action_released("rewind"):
		linear_velocity = linear_velocity_buffer[buffer_index]
		angular_velocity = angular_velocity_buffer[buffer_index]
		rewinding = false
		collision_polygon_2d.set_deferred("disabled", false)
