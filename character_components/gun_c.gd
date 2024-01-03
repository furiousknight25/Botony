extends Node3D

@export var fire_speed := .5
@export var cursor : Node3D #this will be a scene with its own cursor code 

@export var bullet_type = "res://Hazards/bullet.tscn"
var fire_ready = true
@onready var bullet_spawn = $bullet_spawn
@onready var bullet_delay = $bullet_delay

func _ready():
	bullet_delay.wait_time = fire_speed
	cursor.top_level = true
	
func fire_weapon():
	if fire_ready == false: return
	fire_ready = false
	var Bullet = load(bullet_type)
	var spawned_bullet = Bullet.instantiate()
	bullet_spawn.add_child(spawned_bullet)
	bullet_delay.start()

func _on_bullet_delay_timeout():
	fire_ready = true
	
	
func cursor_place(pos, rot):
	cursor.position = pos
	cursor.rotation.y = rot
	cursor.rotation.z = 0
	
	cursor.gun_position = global_position
	#cursor_change(distance) send this data into the cursor so it plays an animation and decides its effects
