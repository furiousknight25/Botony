extends Ability

@onready var fuse: Timer = $Fuse
@onready var grenade_body: RigidBody3D = $GrenadeBody
@onready var grenade_cursor: cursor = $GrenadeCursor
@onready var ability_c: AbilityC = get_parent()

var velocity = Vector2.ZERO
@export var base_acceleration := 50
@export var max_speed := 3
@export var friction = 5




func throw(target_pos):
	acreq.erase('shoot')
	acreq.append('idle')
	enabled = false
	grenade_body.linear_velocity = Vector3.ZERO
	grenade_body.global_position = global_position
	grenade_body.freeze = false
	grenade_body.apply_central_impulse(target_position - grenade_body.global_position)
	
	fuse.start()
	grenade_cursor.hide()

func activate_ability(): #should override 
	enabled = true
	grenade_cursor.show()

func _process(delta: float) -> void:
	
	if enabled:
		if acreq.has('shoot'): throw(target_position) #change target position based on collision
		
		grenade_cursor.global_position = target_position
		moving_code(delta)
		ability_c.set_m_input(target_position, velocity, acreq)
		

func moving_code(delta): #perhaps make a global here that allows me to reuse code library
	if input_dir:
		velocity += input_dir * base_acceleration * delta
		#velocity = velocity.limit_length(max_speed - (aim_subtract * angle_difference))
		velocity = velocity.limit_length(max_speed)
	else:
		velocity.x = move_toward(velocity.x, 0.0, friction * delta)
		velocity.y = move_toward(velocity.y, 0.0, friction * delta)
	
	
