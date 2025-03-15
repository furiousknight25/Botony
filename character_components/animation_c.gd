class_name AnimationC extends AnimationTree
#Animation Controller is useful for all the little bits of small details in playing animations and ONLY playing animations
@onready var state_m : AnimationNodeStateMachinePlayback = get('parameters/StateMachine/playback')
var velocity = Vector2.ZERO
@export var idle_frequence = 3
var idle_time = 0

func _process(delta):
	if state_m.get_current_node() == "Idle":
		if idle_time >= idle_frequence: play_idle(3) #TODO change 7 to automated
		else: idle_time += delta
	if state_m.get_current_node() == "Moving":
		manage_moving(delta)
	

func manage_moving(delta):
	var blend_length = 0.0
	if velocity.length() > 1.0: blend_length = 1.0
	set("parameters/StateMachine/Moving/Blend2/blend_amount", move_toward(get("parameters/StateMachine/Moving/Blend2/blend_amount"), blend_length, delta * 5))
	set("parameters/StateMachine/Moving/Walk/blend_position", velocity * Vector2(-1,1))
	
func set_idle():
	state_m.travel('Idle')

func set_moving():
	state_m.start('Idle')
	state_m.travel('Moving')

func play_idle(idle_amounts):
	idle_time = 0
	var choice = randi_range(1, idle_amounts)
	state_m.travel('idle gesture ' + str(choice))
