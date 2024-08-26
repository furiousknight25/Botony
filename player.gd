extends CharacterBody3D
#im chosing the keep the player scene and script not in a folder because we will acess it a lot 

@onready var movementC = $MovementC
@onready var aimC = $AimC
@export var gunC : Node3D
@onready var cursor = gunC.get_child(3)
@onready var camera = get_tree().get_nodes_in_group("camera")[0]
@onready var double_tap_timer = $DoubleTap
#damn i've lasted this long without adding a variable other than fullscreen 

func _ready():
	movementC.STATES.IDLE

func _process(delta):
	var input_cam = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	camera.rotation.y -= input_cam.x * delta
	var cam_vel = camera.global_transform.basis.z * input_cam.y * delta * 2
	camera.position += cam_vel
	
#endregion
	input_movement(delta)
	cursor_control(delta)
	
func death():
	queue_free()

func _set_velocity(v, r):
	velocity = v

var old_input 
var double_tap = 0
func input_movement(delta): #region Input movement perhaps add can press button to prevent these states, like in deploy
	var input_dir = Input.get_vector("left", "right", "forward", "backward")

	if input_dir and double_tap == 0 and double_tap_timer.is_stopped():
		double_tap_timer.start()
		double_tap += 1
		old_input = input_dir
	if input_dir == old_input and double_tap == 0  and !double_tap_timer.is_stopped():
		double_tap = 0
		double_tap_timer.stop()
		movementC.set_state_active()
	if !input_dir:
		double_tap = 0

	#yesssss... small victory :)
	if !input_dir:
		if movementC.cur_state != movementC.STATES.IDLE:
			movementC.set_state_idle()
			$"Debug tools/debugtext".text = 'state idle'
	elif input_dir and movementC.cur_state != movementC.STATES.ACTIVE:
		if movementC.cur_state != movementC.STATES.WALK:
			movementC.set_state_walk()
			$"Debug tools/debugtext".text = 'state jog/walk'
	
	movementC.rotation.y = camera.rotation.y
	var intent = (movementC.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	print(Vector2(cos(movementC.global_rotation.y), sin(movementC.global_rotation.y)))
	print(movementC.transform.basis)
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
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
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
		gunC.cursor_place(raycast_result.position, atan2(($GunbarrelTest.global_position.x - cursor.position.x), ($GunbarrelTest.global_position.z - cursor.position.z)) + PI)
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		aimC.shoot()
	
	var angle_facing = atan2(($GunbarrelTest.global_position.x - cursor.position.x), ($GunbarrelTest.global_position.z - cursor.position.z))
	aimC.intent = angle_facing
	
func _on_double_tap_timeout():
	double_tap = 0
