extends Node3D

@export var body_to_rotate : Node3D
@export var body : CharacterBody3D
@export var movementC : Node3D
@export var gunC : Node3D
@export var aim_speed := 8
@onready var camera : Camera3D = get_tree().get_nodes_in_group("camera")[0]

var intent : float

func _process(delta):
	if movementC.cur_state == movementC.STATES.ACTIVE:
		body_to_rotate.rotation.y = lerp_angle(body_to_rotate.rotation.y, body.rotation.y, 5 * delta)
		
	if  movementC.cur_state == movementC.STATES.WALK or movementC.cur_state == movementC.STATES.IDLE:
		var angle_difference = abs(angle_difference(fmod(atan2(body.velocity.x,body.velocity.z), 2*PI), fmod(body_to_rotate.global_rotation.y, 2*PI))/PI)
		movementC.angle_difference = angle_difference
		body.rotation.y = intent + PI
		body_to_rotate.rotation.y = lerp_angle(body_to_rotate.rotation.y, intent + PI, aim_speed * delta)
	position = body.position
	body_to_rotate.position = position

func shoot():
	gunC.fire_weapon()
