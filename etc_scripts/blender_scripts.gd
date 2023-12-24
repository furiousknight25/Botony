extends Node3D

var mesh
# Called when the node enters the scene tree for the first time.
func _ready():
	mesh = get_children()
	for object in mesh:
		object.create_trimesh_collision()
