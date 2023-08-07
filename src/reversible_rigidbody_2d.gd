class_name ReversibleRigidBody2D extends RigidBody2D

var _position_buffer: PackedVector2Array
var _rotation_buffer: PackedFloat32Array
var _linear_velocity_buffer : PackedVector2Array
var _angular_velocity_buffer : PackedFloat32Array

var _buffer_index := 0
@onready var _buffer_size := int(Engine.physics_ticks_per_second * reverse_buffer_time)

## For checking if the object is currently rewinding.
## WARNING: Only use this as a getter. If you want to set if the object is rewinding, use the start_rewind() or stop_rewind() functions.
## Modifying this variable by hand might result in unexpected behaviour.
var rewinding := false

## The CollisionShape2D of the given ReversibleRigidBody2D. 
@export var collision_shape_2d: CollisionShape2D

## How many time in seconds should the reverse_buffer store for the given object movement.
## When trying to reverse time, if the object goes over the time limit it will move to the last recorded position in the buffer.
@export_range(1.0, 17.0) var reverse_buffer_time: float = 3.0

## Determines wether the object should keep its momentum from the rewind state or not.
@export var keep_momentum := false

func _ready() -> void:
	_position_buffer.resize(_buffer_size)
	_rotation_buffer.resize(_buffer_size)
	_linear_velocity_buffer.resize(_buffer_size)
	_angular_velocity_buffer.resize(_buffer_size)

func start_rewind() -> void:
	rewinding = true
	collision_shape_2d.set_deferred("disabled", true)

func stop_rewind() -> void:
	rewinding = false
	collision_shape_2d.set_deferred("disabled", false)
	var momentum = int(keep_momentum) * -2 + 1
	linear_velocity = momentum * _linear_velocity_buffer[_buffer_index]
	angular_velocity = momentum * _angular_velocity_buffer[_buffer_index]

func _physics_process(_delta: float) -> void:
	if rewinding: return
	
	_buffer_index %= _buffer_size
	
	_position_buffer[_buffer_index] = global_position
	_rotation_buffer[_buffer_index] = rotation
	_linear_velocity_buffer[_buffer_index] = linear_velocity
	_angular_velocity_buffer[_buffer_index] = angular_velocity
	
	_buffer_index += 1

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if !rewinding: return
	
	_buffer_index %= _buffer_size
	_buffer_index -= 1
	state.transform = Transform2D(_rotation_buffer[_buffer_index], _position_buffer[_buffer_index])
