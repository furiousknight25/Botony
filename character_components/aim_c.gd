class_name AimC extends Node3D
#manages where the player is looking depending on the state
#also manages where the the gun should look

@export var body_to_rotate : Node3D
@onready var base_c = get_parent()
@export var gunC : GunC
@export var aim_speed := 8
@onready var camera : Camera3D = get_tree().get_nodes_in_group("camera")[0]

var target_position = Vector3.ZERO

func _process(delta):
	if base_c.cur_state == base_c.STATES.ACTIVE:
		body_to_rotate.rotation.y = lerp_angle(body_to_rotate.rotation.y, base_c.rotation.y, 5 * delta)
		
	if  base_c.cur_state == base_c.STATES.IDLE:
		var angle_difference = abs(angle_difference(fmod(atan2(base_c.velocity.x,base_c.velocity.z), 2*PI), fmod(body_to_rotate.global_rotation.y, 2*PI))/PI)
		#base_c.rotation.y = atan2((gunC.global_position.x - gunC.g_cursor.global_position.x), (gunC.global_position.z - gunC.g_cursor.global_position.z))
		var intent =  atan2((gunC.global_position.x - gunC.g_cursor.global_position.x), (gunC.global_position.z - gunC.g_cursor.global_position.z))
		body_to_rotate.rotation.y = lerp_angle(body_to_rotate.rotation.y, intent + PI, aim_speed * delta)
		gunC.cursorC_place(target_position)
		
		
	global_position = base_c.global_position
	body_to_rotate.global_position = global_position

func shoot():
	gunC.fire_weapon()
