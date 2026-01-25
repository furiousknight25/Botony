@abstract
extends Area3D
class_name Bullet

#initialize all variables with database
@export var time_to_despawn : float
@export var velocity : Vector3
@export var speed : float
var on = false

@abstract func fire(vel : Vector3, spe : float)
@abstract func destroy_self()

func _physics_process(delta: float) -> void:
	if on:
		global_position += velocity * speed
