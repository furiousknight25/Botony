class_name GunC extends Node3D

@export var fire_speed := .5
@export var g_cursor : cursor #this will be a scene with its own g_cursor code 

@export var bullet_type = "res://Hazards/bullet.tscn"
var fire_ready = true
@onready var bullet_spawn = $bullet_spawn
@onready var bullet_delay = $bullet_delay

func _ready():
	bullet_delay.wait_time = fire_speed
	
func fire_weapon():
	if fire_ready == false: return
	fire_ready = false
	var Bullet = load(bullet_type)
	var spawned_bullet = Bullet.instantiate()
	bullet_spawn.add_child(spawned_bullet)
	bullet_delay.start()

func _on_bullet_delay_timeout():
	fire_ready = true
	
func cursorC_place(pos : Vector3):
	g_cursor.position = pos
	g_cursor.rotation.y = atan2((global_position.x - g_cursor.position.x), (global_position.z - g_cursor.position.z)) + PI
	g_cursor.rotation.z = 0

	g_cursor.gun_position = global_position
	#g_cursor_change(distance) send this data into the g_cursor so it plays an animation and decides its effects
