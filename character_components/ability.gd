class_name Ability extends Node3D

var enabled = false

var target_position : Vector3
var input_dir : Vector2
var acreq = [] #action request

func activate_ability(): #should override 
	return self
	
func deactivate_ability():
	pass

func set_target_position(pos : Vector3):
	return Vector3.ZERO
func set_input_dir(dir : Vector2):
	return Vector2.ZERO
func set_acreq(acreq : Array):
	return []
