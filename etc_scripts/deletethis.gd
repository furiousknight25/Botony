extends CharacterBody3D

#region Export Variables
#All of the export variables
@export var commandable = false
@export var sentry_mode = false
@export var move_speed = 5
@export var target_type = ""
@export var ally_type = ""
@export var bullet_type = "res://Hazards/bullet.tscn"
@export var health = 1

#endregion
#region Normal Variables
#All of the regular variables
var dead = false
var eye_line = Vector3.UP * 1.5
var target_aquired = false
#endregion
#region Onready Variables
#All of the Onready variables
@onready var sight_range = $sight_range
@onready var nav_agent = $NavigationAgent3D
#@onready var target : CharacterBody3D = get_tree().get_first_node_in_group(target_type)

#endregion
#region Signals
signal death_note
#endregion

#region Reaction Code
func deathnote():
	chase_function_set()
	print("he's dead")
	
func hurt(damage):
	health -= damage
	if health <= 0:
		die()
func die():
	queue_free()
#endregion

#region Passive Functions

#the one and only physics process
func _physics_process(delta):
	chase()
	point_gun()
	fire_weapon()
	find_closest_target_or_null()
	#avoid_NPC()
#endregion

#region Chase Target Function

@onready var closest_target = null

#Timer that plays on loop on start that activates several functions
func _on_timer_timeout():
	chase_function_set()

func chase_function_set():
	makepath()

#Finds the closest target
func find_closest_target_or_null():
	if sentry_mode == true: return
	var all_targets = get_tree().get_nodes_in_group(target_type)
	if (all_targets.size() > 0):
		closest_target = all_targets[0]
		for player in all_targets:
			var distance_to_this_player = global_position.distance_squared_to(player.global_position)
			var distance_to_closest_target = global_position.distance_squared_to(closest_target.global_position)
			if (distance_to_this_player < distance_to_closest_target):
				closest_target = player
	else: closest_target = null
	return closest_target

func makepath():
	if closest_target != null:
		nav_agent.target_position = closest_target.global_position

func chase():
	#if target_aquired == true: return
	if nav_agent == null: return
	if nav_agent.is_navigation_finished(): return
	if closest_target == null: return
	#var dir = to_local(nav_agent.get_next_path_position()).normalized()
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * move_speed
	nav_agent.set_velocity(new_velocity)

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	if closest_target == null: return
	if nav_agent.is_target_reachable() == false: return
	velocity = velocity.move_toward(safe_velocity, .25)
	move_and_slide()

#endregion

#region Find Closest Shootable Target

var current_range_target
@onready var check_target_timer = $Timers/check_target_timer

func _on_check_target_timer_timeout():
	get_closest_shootable_target_or_null()

func get_closest_shootable_target_or_null():
	var testsight = sight_range.get_overlapping_bodies()
	var all_targets = []
	for body in testsight:
		if body.is_in_group(target_type):
			all_targets.push_back(body)
	if (all_targets.size() > 0):
		current_range_target = all_targets[0]
		for player in all_targets:
			var query = PhysicsRayQueryParameters3D.create(global_position, player.global_position, 1-4)
			var result = get_world_3d().direct_space_state.intersect_ray(query)
			if result:
				if result.collider == player:
					var distance_to_this_player = global_position.distance_squared_to(player.global_position)
					var distance_to_closest_target = global_position.distance_squared_to(current_range_target.global_position)
					if (distance_to_this_player < distance_to_closest_target):
						current_range_target = player
						print("visible")
					else: print("hidden")
	else: current_range_target = null
	if current_range_target != null:
		print(current_range_target.name)
		
	return current_range_target

#endregion

#region Shoot Function
var fire_ready = true
@onready var weapon = $weapon
@onready var bullet_spawn = $weapon/bullet_spawn
@onready var bullet_delay = $Timers/bullet_delay
@onready var current_target_raycast_l = $weapon/CurrentTargetRaycastL
@onready var current_target_raycast_r = $weapon/CurrentTargetRaycastR
var L_raycolliding = false
var R_raycolliding = false

func fire_weapon():
	if target_aquired == false : return
	if fire_ready == false: return
	fire_ready = false
	var Bullet = load(bullet_type)
	var spawned_bullet = Bullet.instantiate()
	bullet_spawn.add_child(spawned_bullet)
	bullet_delay.start()

func _on_bullet_delay_timeout():
	fire_ready = true
	
func point_gun():
	if current_range_target == null: 
		target_aquired = false
		return
	weapon.look_at(current_range_target.global_transform.origin,Vector3.UP)
	var bodyhalfl = current_target_raycast_l.get_collider()
	var bodyhalfr = current_target_raycast_r.get_collider()
	if bodyhalfl != null: 
		if bodyhalfl.is_in_group(target_type):
			L_raycolliding = true
			bullet_clear()
		else: 
			L_raycolliding = false
			bullet_clear()
	if bodyhalfr != null: 
		if bodyhalfr.is_in_group(target_type):
			R_raycolliding = true
			bullet_clear()
		else: 
			R_raycolliding = false
			bullet_clear()

func bullet_clear():
	if L_raycolliding and R_raycolliding:
		target_aquired = true
	else: target_aquired = false
#endregion









