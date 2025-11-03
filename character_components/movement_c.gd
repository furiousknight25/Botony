class_name MovementC extends Node3D
#manages where the creature moves based on input and state
#vehicles could always be in the active state and shoot could be honk

@onready var baseC : BaseC= get_parent()
@export var animation_c : AnimationC
@export var base_acceleration := 50

@export_group("sprinting")
@export var max_speed := 3 
@export var max_speed_sprint := 8
@export var friction := 10
@export var rot_speed := 10.0

@export_group('idle')
@export var aim_subtract := 0 #set higher if you want slower when faced other way

var velocity := Vector3.ZERO
var rot : float
var angle_difference = 0
var gravity = Vector3(0,-9.8,0)
var intent : Vector3 #used for sprinting #TODO, combine these?
var direction : Vector3 #used for default

var is_hooked = false
var is_in_air = false

signal movement_data

func _process(delta): 
	animation_c.velocity = Vector2(velocity.x, velocity.z).rotated($"../baseV".rotation.y)/max_speed #TODO transfer the signal down there into there
	
	
#region this dog is up bruh
	match baseC.cur_state:
		baseC.STATES.ACTIVE:
			active_process(delta)
		baseC.STATES.IDLE:
			idle_process(delta)
		baseC.STATES.GAP:
			gap_process(delta)
		baseC.STATES.ABILITY:
			ability_process(delta)
#endregion
	emit_signal('movement_data', velocity) #to player

#region state processes
func active_process(delta):
	if intent: #TODO manage max speed based on calculations of friction vs just limiting the length
		baseC.rotation.y = lerp_angle(baseC.rotation.y, atan2(intent.x, intent.z), delta * rot_speed)
		velocity += baseC.global_transform.basis.z * delta * base_acceleration
		var drift_factor = baseC.velocity.dot(baseC.basis.x)
		var drift_force = (baseC.basis.x * drift_factor)
		velocity -= drift_force
		#var current_max_speed = max(0, (max_speed - (abs(drift_factor * 10))))
		velocity = velocity.limit_length(max_speed_sprint)
	
	apply_gravity(delta)
	
func idle_process(delta):
	if direction: 
		velocity += direction * base_acceleration * delta
		#velocity = velocity.limit_length(max_speed - (aim_subtract * angle_difference))
		var vel_xz = velocity.limit_length(max_speed)
		velocity.x = vel_xz.x
		velocity.z = vel_xz.z
	else:
		velocity.x = move_toward(velocity.x, 0.0, friction * delta)
		velocity.z = move_toward(velocity.z, 0.0, friction * delta)
	
	animation_c.velocity = Vector2(velocity.x, velocity.z).rotated($"../baseV".rotation.y)/max_speed #TODO
	apply_gravity(delta)

func gap_process(delta):
	if is_hooked:
		velocity = Vector3.ZERO
	else:
		apply_gravity(delta)
		
		if !baseC.is_on_floor(): is_in_air = true
		if is_in_air and baseC.is_on_floor():
			baseC.set_state_idle()
			is_in_air = false
	
func ability_process(delta):
	if direction:
		velocity = direction

func apply_gravity(delta):
	if !baseC.is_on_floor():
		velocity += gravity * delta
	
# charge function
