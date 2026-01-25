@abstract class_name GunC extends Node3D

@export var fire_speed := .5
@export var g_cursor : cursor #this will be a scene with its own g_cursor code 

@export var bullet_type = "res://Hazards/bullet.tscn" #export this and set data on the database
var fire_ready = true
@onready var bullet_spawn = $bullet_spawn
@onready var bullet_delay = $bullet_delay

@abstract func hold_trigger() #build awaits via script instead of physical timers

@abstract func fire() #!!!!!

func cursorC_place(pos : Vector3):
	g_cursor.position = pos
	g_cursor.rotation.y = atan2((global_position.x - g_cursor.position.x), (global_position.z - g_cursor.position.z)) + PI
	g_cursor.rotation.z = 0

	g_cursor.gun_position = global_position
	#g_cursor_change(distance) send this data into the g_cursor so it plays an animation and decides its effects
