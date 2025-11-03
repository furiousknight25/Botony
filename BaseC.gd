class_name BaseC extends CharacterBody3D
#manages communcation between the nodes, takes in the AI, Player, and outside input and manages the controllers
#also manages the state machine responsble for actions

enum STATES {IDLE, ACTIVE, GAP, DEPLOY}
var cur_state = STATES.IDLE
@onready var movement_c : MovementC = $MovementC
@onready var aim_c : AimC = $AimC
@onready var animation_c : AnimationC= $AnimationC
@onready var ability_c: AbilityC = $AbilityC

var target_position : Vector3
var input_dir : Vector2
var acreq = [] #action request

var m_target_position : Vector3
var m_input_dir : Vector3
var m_acreq = [] #action request

func _process(delta):
	if acreq.has("disconnect"):
		disconnect_controller()
	match cur_state:
		STATES.IDLE: #also responsible for walking
			idle_process(delta)
		STATES.ACTIVE:
			active_process(delta)
		STATES.GAP:
			gap_process(delta)
		STATES.DEPLOY:
			deploy_process(delta)
	

func disconnect_controller():
	acreq.clear()

func idle_process(delta):
	aim_c.target_position = target_position
	movement_c.direction = Vector3(input_dir.x, 0, input_dir.y)
	
	if acreq.has('action_1') or acreq.has('action_2') or acreq.has('action_3'):
		if acreq.has('action_1'): ability_c.activate_ability(1)
		if acreq.has('action_2'): ability_c.activate_ability(1) #REALLY jank
		if acreq.has('action_3'): ability_c.activate_ability(1)
		acreq.clear()
		set_state_deploy()
	if acreq.has("run"): set_state_active()
	if m_acreq.has("enter_gap"): set_state_gap()
	
func active_process(delta):
	movement_c.intent = movement_c.transform.basis * Vector3(input_dir.x, 0, input_dir.y).normalized()
	if !acreq.has("run"): set_state_idle()
	if m_acreq.has("enter_gap"): set_state_gap()

func gap_process(delta):
	if m_acreq.has("launch"): 
		movement_c.velocity = m_input_dir
		m_acreq.erase("launch")
	if m_acreq.has("hook"):
		movement_c.is_hooked = true
		m_acreq.erase("hook")
	if m_acreq.has("unhook"):
		movement_c.is_hooked = false
		m_acreq.erase("unhook")
	if m_acreq.has("leave_gap"):
		set_state_idle()
		m_acreq.clear()
	
	
	aim_c.target_position = m_target_position
	
func deploy_process(delta):
	aim_c.target_position = m_target_position
	ability_c.set_input(target_position, input_dir, acreq)
	movement_c.direction = Vector3(m_input_dir.x, 0, m_input_dir.y)
	
	if m_acreq.has("idle"): 
		acreq.erase('idle')
		set_state_idle()
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
	m_acreq.erase("enter_gap")
	
func set_state_deploy():
	#prob do like play animation, and then have an animation trigger where it enables set state idle
	cur_state = STATES.DEPLOY
	animation_c.set_deploy() #set anim, each state in the state machine can have it's own blends

func shoot():
	pass

func _set_velocity(v): 
	velocity = v #sets movement, MovementC pulls from this
	move_and_slide()

func _set_input(pos : Vector3, dir : Vector2, acreq : Array):
	self.target_position = pos #sets aim Direction, aimC pulls from this
	self.input_dir = dir
	self.acreq = acreq

#this is for modified input, such as outside factors like cars, abilities and gaps
#we may want to have a 3rd line for physics overide, but idk this seems fair
func _set_modified_input(pos : Vector3, dir : Vector3, acreq : Array):
	self.m_target_position = pos
	self.m_input_dir = dir
	self.m_acreq = acreq
	

func death():
	queue_free()
