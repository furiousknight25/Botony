extends Node3D

@export var body_to_move : CharacterBody3D
@export var base_acceleration := 12
@export var max_speed : float
@export var friction := 12
var camera : Camera3D

enum STATES {IDLE, ACTIVE, GAP, DEPLOY}
var cur_state = STATES.IDLE

var velocity := Vector3.ZERO
var rot : float
var rot_speed := 10.0
const GRAVITY = -100
var intent : Vector3


signal movement_data

func _ready():
	camera = get_tree().get_nodes_in_group("camera")[0]

func _process(delta):
	
	#print(velocity)
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
		velocity.x = move_toward(velocity.x, 0.0, 1 * delta)#naturally our body aligns itself, this is it.
		velocity.z = move_toward(velocity.z, 0.0, 1 * delta)
	
#region state processes
func idle_process(delta):
	velocity.x = move_toward(velocity.x, 0.0, friction * delta)#naturally our body aligns itself, this is it.
	velocity.z = move_toward(velocity.z, 0.0, friction * delta)
	
func active_process(delta):
	if intent:
		body_to_move.rotation.y = lerp_angle(body_to_move.rotation.y, atan2(intent.x, intent.z), delta * rot_speed)
		velocity += body_to_move.global_transform.basis.z * delta * base_acceleration
		velocity.x = clamp(velocity.x, -max_speed, max_speed)
		velocity.z = clamp(velocity.z, -max_speed, max_speed)
	
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
