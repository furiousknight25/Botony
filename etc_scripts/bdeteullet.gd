extends Node3D

@export var damage = 1
@export var SPEED = 2
@export var recoil_rate = 1
var rng = RandomNumberGenerator.new()

func _ready():
	top_level = true
	global_position = get_parent().global_position
	global_rotation = get_parent().global_rotation 
	var X = rng.randf_range(-recoil_rate, recoil_rate) #perhaps we want to do random rangle somewhere else
	var Y = rng.randf_range(-recoil_rate, recoil_rate)
	var Z = rng.randf_range(-recoil_rate, recoil_rate)
	#global_rotation +=  Vector3(deg_to_rad(X),deg_to_rad(Y),deg_to_rad(Z))

func _physics_process(delta):
	$Area3D.position.z -= -SPEED * delta

func _on_area_3d_body_entered(body):
	if body.is_in_group("soldier"):
		body.hurt(damage)
	queue_free()

func _on_timer_timeout():
	queue_free()
	
