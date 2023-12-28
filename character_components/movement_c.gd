extends Node3D

@export var body_to_move : CharacterBody3D
@export var animation_c : AnimationTree
@export var base_acceleration := 50
@export var max_speed := 6
@export var friction := 10
@export var rot_speed := 10.0
var camera : Camera3D

enum STATES {IDLE, ACTIVE, GAP, DEPLOY}
var cur_state = STATES.IDLE

var velocity := Vector3.ZERO
var rot : float
const GRAVITY = -100
var intent : Vector3

signal movement_data

func _ready():
	camera = get_tree().get_nodes_in_group("camera")[0]

func _process(delta):
	animation_c.set('parameters/Blend2/blend_amount', velocity.length()/max_speed) #delete this when you make system
	print(velocity.length()/max_speed) 
	
	
	emit_signal('movement_data', velocity, rot)
	body_to_move.move_and_slide()
#region this dog is up bruh
	match cur_state:
		STATES.IDLE:
			idle_process(delta)
		STATES.ACTIVE:
			active_process(delta)
		STATES.GAP:
			gap_process(delta)
		STATES.DEPLOY:
			deploy_process(delta)
#endregion
	
	if !body_to_move.is_on_floor():# jank fix
		velocity.y += GRAVITY * delta
	else:
		velocity.y = 0
	
#region state processes
func idle_process(delta):
	velocity.x = move_toward(velocity.x, 0.0, friction * delta)
	velocity.z = move_toward(velocity.z, 0.0, friction * delta)
	
func active_process(delta):
	if intent:
		body_to_move.rotation.y = lerp_angle(body_to_move.rotation.y, atan2(intent.x, intent.z), delta * rot_speed)
		velocity += body_to_move.global_transform.basis.z * delta * base_acceleration
		var drift_factor = body_to_move.velocity.dot(body_to_move.basis.x)
		var drift_force = (body_to_move.basis.x * drift_factor)
		velocity -= drift_force
		var current_max_speed = max(0, (max_speed - (abs(drift_factor * 10))))
		velocity = velocity.limit_length(current_max_speed)
		
func gap_process(delta):
	pass

func deploy_process(delta):
	pass
	
#endregion
#region set state
func set_state_idle():
	cur_state = STATES.IDLE
func set_state_active():
	cur_state = STATES.ACTIVE
func set_state_gap():
	cur_state = STATES.GAP
func set_state_deploy():
	#prob do like play animation, and then have an animation trigger where it enables set state idle
	cur_state = STATES.DEPLOY
#endregion
