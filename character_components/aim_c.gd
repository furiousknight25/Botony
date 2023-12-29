extends Node3D

@export var body_to_rotate : Node3D
@export var body : CharacterBody3D
@onready var camera : Camera3D = get_tree().get_nodes_in_group("camera")[0]

var intent: float
func _process(delta):
	
	print(rad_to_deg(rotation.y))
	var offset = PI/2
	var screen_pos = camera.unproject_position(global_transform.origin)
	var mouse_pos = get_viewport().get_mouse_position()
	var angle = screen_pos.angle_to_point(mouse_pos)
	#perhaps add an ifstatement place because you might want to call functions when past a point
	rotation.y = clamp(-angle + offset, -PI/2 + body.rotation.y, PI/2  + body.rotation.y) # make sure that the rotated body does not copy parent rotation
	position = body.position
	
	body_to_rotate.rotation.y = rotation.y
	body_to_rotate.position = position
