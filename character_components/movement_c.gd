class_name MovementC extends Node3D
#manages where the creature moves based on input and state
#vehicles could always be in the active state and shoot could be honk

@onready var baseC = get_parent()
@export var animation_c : AnimationC
@export var base_acceleration := 50
@export var max_speed := 3
@export var max_speed_sprint := 8
@export var friction := 10
@export var rot_speed := 10.0
@export var aim_subtract := 0 #set higher if you want slower when faced other way

var velocity := Vector3.ZERO
var rot : float
var angle_difference = 0
const GRAVITY = -100
var intent : Vector3
var direction : Vector3

signal movement_data

func _process(delta): 
	animation_c.velocity = Vector2(velocity.x, velocity.z).rotated($"../baseV".rotation.y)/max_speed #TODO
	emit_signal('movement_data', velocity) #to player
	baseC.move_and_slide()
	
#region this dog is up bruh
	match baseC.cur_state:
		baseC.STATES.ACTIVE:
			active_process(delta)
		baseC.STATES.IDLE:
			idle_process(delta)
		baseC.STATES.GAP:
			gap_process(delta)
		baseC.STATES.DEPLOY:
			deploy_process(delta)
#endregion

	
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
		velocity = velocity.limit_length(max_speed)
	else:
		velocity.x = move_toward(velocity.x, 0.0, friction * delta)
		velocity.z = move_toward(velocity.z, 0.0, friction * delta)
	apply_gravity(delta)
func gap_process(delta):
	pass

func deploy_process(delta):
	pass

func apply_gravity(delta):
	if !baseC.is_on_floor():# jank fix
		velocity.y += GRAVITY * delta
	else:
		velocity.y = 0
# charge function
