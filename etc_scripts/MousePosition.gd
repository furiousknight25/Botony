extends MeshInstance3D

#@export var body : CharacterBody3D
#@onready var camera : Camera3D = get_tree().get_nodes_in_group("camera")[0]
#
#func _ready():
	#show()
#func _process(delta):
	#
	#
	#var offset = -PI * 0.5
	#var screen_pos = camera.unproject_position(global_transform.origin)
	#var mouse_pos = get_viewport().get_mouse_position()
	#var angle = screen_pos.angle_to_point(mouse_pos)
	#position = Vector3.ONE * (-angle + offset)
	#
