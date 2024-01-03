extends CharacterBody3D
#im chosing the keep the player scene and script not in a folder because we will acess it a lot 

var fullscreen := false 

@onready var movementC = $MovementC
@onready var aimC = $AimC
@onready var gunC = $jump_nod_2_/Armature_001/Skeleton3D/Hand/GunC
@onready var cursor = gunC.get_child(3)
@onready var camera = get_tree().get_nodes_in_group("camera")[0]

func _ready():
	movementC.STATES.IDLE
func _process(delta):
#region basic debug tool
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	if Input.is_action_just_pressed("fullscreen"):
		if !fullscreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			fullscreen = true
		else:
			fullscreen = false
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	if Input.is_action_just_pressed('restart'):
		get_tree().reload_current_scene()
	#print(Engine.get_frames_per_second())
	var input_cam = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	camera.rotation.y -= input_cam.x * delta
	var cam_vel = camera.global_transform.basis.z * input_cam.y * delta * 2
	camera.position += cam_vel
	
	
	
#endregion
#region debug devices
	$"Debug tools/velocity".position = position
	$"Debug tools/accel".position = position
	$"Debug tools/velocity".target_position = velocity
	$"Debug tools/accel".target_position = movementC.global_transform.basis.z * delta * movementC.base_acceleration * 50
#endregion
	input_movement(delta)
	cursor_control(delta)
	#print(velocity.dot(global_transform.basis.z))
func death():
	queue_free()

func _set_velocity(v, r):
	velocity = v

func input_movement(delta): #region Input movement perhaps add can press button to prevent these states, like in deploy
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	
	if Input.is_action_pressed('sprint'): #yesssss... small victory :)
		if movementC.cur_state != movementC.STATES.ACTIVE:
			movementC.set_state_active()
			$"Debug tools/debugtext".text = 'state running'
	elif !input_dir:
		if movementC.cur_state != movementC.STATES.IDLE:
			movementC.set_state_idle()
			$"Debug tools/debugtext".text = 'state idle'
	elif input_dir:
		if movementC.cur_state != movementC.STATES.WALK:
			movementC.set_state_walk()
			$"Debug tools/debugtext".text = 'state jog/walk'
	
	movementC.rotation.y = camera.rotation.y
	var intent = (movementC.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	movementC.intent = intent
	
	movementC.direction = Vector3(input_dir.x, 0, input_dir.y)
func cursor_control(delta):
	var offset = PI/2 + camera.rotation.y
	var screen_pos = camera.unproject_position(global_transform.origin)
	var mouse_pos = get_viewport().get_mouse_position()
	var angle = screen_pos.angle_to_point(mouse_pos)
	
	
	
	#aimC.intent = position.angle_to(cursor.position)
	#print(position, cursor.position)
	#print(transform.looking_at(cursor.position, Vector3.UP))
	#Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	#hm
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * 1000
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.collision_mask = 1024 #11
	ray_query.from = from
	ray_query.to = to
	var raycast_result = space.intersect_ray(ray_query)
	if raycast_result:
		gunC.cursor_place(raycast_result.position, atan2((position.x - cursor.position.x), (position.z - cursor.position.z)) + PI)
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		aimC.shoot()
	
	var angle_facing = atan2((position.x - cursor.position.x), (position.z - cursor.position.z))
	aimC.intent = angle_facing
	
	
