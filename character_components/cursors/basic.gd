extends Node3D

class_name cursor

var gun_position = Vector3.ZERO
@export var max_distance := 12
@onready var animation = $AnimationTree
var distance

func _process(delta):
	distance = clamp((gun_position - position).length()/max_distance, 0, 1)
	
	animation.set('parameters/Blend2/blend_amount', distance)
	print(gun_position)
	
