extends Node3D

@onready var parent = $".."
@onready var velocity = $velocity
@onready var velocity_label: Label3D = $velocity/VelocityLabel

@onready var accel = $accel

@export var velocity_arrow_multiplier := 1
@export var accel_arrow_multiplier := 8

var acceleration := Vector3.ZERO
var old_acceleration := Vector3.ZERO
func _process(delta):
	velocity.position = parent.position + Vector3(0,1.2,0)
	accel.position = parent.position + Vector3(0,1.4,0)
	velocity.target_position = parent.velocity
	var formatted_string_velocity = "X: %f, Y: %f, Z: %f" % [velocity.target_position.x, velocity.target_position.y, velocity.target_position.z]
	velocity_label.text = formatted_string_velocity +  " " + str(rad_to_deg(Vector2(velocity.target_position.x, velocity.target_position.z).angle()))
	
	
	acceleration = parent.velocity - old_acceleration
	old_acceleration = parent.velocity * velocity_arrow_multiplier
	accel.target_position = acceleration * accel_arrow_multiplier
	#accel.target_position = parent.movementC.global_transform.basis.z * delta * parent.movementC.base_acceleration * 50
