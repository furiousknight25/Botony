class_name BaseC extends CharacterBody3D
#manages communcation between the nodes, takes in the AI, Player, and outside input and manages the controllers
#also manages the state machine responsble for actions

enum STATES {IDLE, ACTIVE, GAP, DEPLOY}
var cur_state = STATES.IDLE
@onready var movement_c : MovementC = $MovementC
@onready var aim_c : AimC = $AimC
@onready var animation_c : AnimationC= $AnimationC

var target_position : Vector3
var input_dir : Vector2
var acreq = []

func _process(delta):
	match cur_state:
		STATES.IDLE: #also responsible for walking
			idle_process(delta)
		STATES.ACTIVE:
			active_process(delta)
		STATES.GAP:
			gap_process(delta)
		STATES.DEPLOY:
			deploy_process(delta)

func idle_process(delta):
	aim_c.target_position = target_position
	movement_c.direction = Vector3(input_dir.x, 0, input_dir.y)
	
	
	if acreq.has("run"): set_state_active()
	
func active_process(delta):
	movement_c.intent = movement_c.transform.basis * Vector3(input_dir.x, 0, input_dir.y).normalized()
	if !acreq.has("run"): set_state_idle()
	
func gap_process(delta):
	pass

func deploy_process(delta):
	pass

func cursorC_control(delta):
	pass

func set_state_idle():
	cur_state = STATES.IDLE
	animation_c.set_idle()
func set_state_active():
	cur_state = STATES.ACTIVE
	animation_c.set_moving()
func set_state_gap():
	cur_state = STATES.GAP
func set_state_deploy():
	#prob do like play animation, and then have an animation trigger where it enables set state idle
	cur_state = STATES.DEPLOY

func action1():
	pass
func action2():
	pass
func action3():
	pass
func shoot():
	pass

func _set_velocity(v): velocity = v #sets movement, MovementC pulls from this
func _set_input(pos : Vector3, dir : Vector2, acreq : Array):
	self.target_position = pos #sets aim Direction, aimC pulls from this
	self.input_dir = dir
	self.acreq = acreq

func death():
	queue_free()
