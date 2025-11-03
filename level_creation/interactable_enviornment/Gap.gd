extends Area3D
class_name Gap

@export var connections : Array[Gap]
@export var is_hook_point = false
@export_group("Launch Timing")
## The "high, long hop" time, when player enters at min_speed.
@export var time_at_min_speed: float = 1.2
## The "fast, low hop" time, when player enters at max_speed.
@export var time_at_max_speed: float = 0.8
## might want to incorporate if its set to zero enable the hop from zero animation, especially for wall grabs

@export_group("Player Speed")
@export var min_speed_threshold: float = 3.0
@export var max_speed_threshold: float = 8.0

@onready var gap_helper: GapHelper = $GapHelper

signal _set_gap_data (pos : Vector3, velocity: Vector3, acreq : Array)
 #might want to add animation requests here too
 #and final rotation?

#TODO, for now I will just have this select array[0] but in the future figure out a selection system
var velocity := Vector3.ZERO
var direction := Vector3.ZERO
var acreq := []
# This is the core formula
# v = (d / t) - (0.5 * g * t)
#v = initial velocity, d = displacement, t = time, g = gravity
#gotta figure out the y launch here i think
var t : float = 0.0
var d : Vector3 = Vector3.ZERO
var g = Vector3(0,-9.8,0)



func _on_body_entered(body: BaseC) -> void:
	var destination := Vector3.ZERO
	if is_hook_point:
		acreq.append("hook")
		connect_to_body(body)
		
		if body.input_dir == Vector2.ZERO: while body.input_dir == Vector2.ZERO:
			await get_tree().physics_frame
		destination = compare_options(body.input_dir)
		acreq = ['unhook']
		emit_signal("_set_gap_data", Vector3.ZERO, Vector3.ZERO, acreq)
	else:
		var input3 = Vector3(body.input_dir.x,0,body.input_dir.y).normalized()
		var dot = input3.dot((gap_helper.get_input_req()))
		if dot > 0:
			destination = connections[0].global_position #TODO
			connect_to_body(body)
	
	if destination != Vector3.ZERO:launch(body, destination)

func compare_options(input: Vector2) -> Vector3:
	var input3 = Vector3(input.x,0,input.y).normalized()
	
	var closest_point = connections[0].global_position
	
	for i : Gap in connections:
		var dot = input3.dot((i.global_position - global_position).normalized())
		var dot_old = input3.dot((closest_point - global_position).normalized())
		
		if dot > dot_old: closest_point = i.global_position
	
	return closest_point
	
func launch(body: BaseC, destination: Vector3): #if not hookpoint leave gap?
	var player_velocity = body.velocity
	var player_speed = (player_velocity * Vector3(1, 0, 1)).length()
	
	var speed_ratio = inverse_lerp(min_speed_threshold, max_speed_threshold, player_speed) #so this is reallllllly cool, boutta use this more :D
	speed_ratio = clamp(speed_ratio, 0.0, 1.0) # Ensure it's in range, hm is this nececary TODO
	var dynamic_traversal_time = lerp(time_at_min_speed, time_at_max_speed, speed_ratio) #very interesting strategy modifying hte percentage rather than the value :o
	
	
	d = destination - body.global_position
	var start_vel_calc = (d / dynamic_traversal_time)- (0.5 * g * dynamic_traversal_time)
	velocity = start_vel_calc
	
	acreq.append("launch")
	emit_signal("_set_gap_data", velocity, velocity, acreq)
	
	await get_tree().create_timer(dynamic_traversal_time).timeout
	_set_gap_data.disconnect(body._set_modified_input)

func connect_to_body(body: BaseC):
	_set_gap_data.connect(body._set_modified_input)
	acreq.append("enter_gap")
	emit_signal("_set_gap_data", Vector3.ZERO, Vector3.ZERO, acreq)
	print(acreq)
