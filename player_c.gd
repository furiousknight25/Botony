extends Node3D
#im chosing the keep the player scene and script not in a folder because we will acess it a lot 

@onready var camera = get_tree().get_nodes_in_group("camera")[0]
@onready var double_tap_timer = $DoubleTap
var target_position = Vector3.ZERO
var input = Vector2.ZERO
var acreq = [] #action request

var connected_node : BaseC
signal _set_input(target_position, input, acreq)

func connect_to(connected_node):	
	if self.connected_node: self.disconnect("_set_input", self.connected_node._set_input)
	self.connected_node = connected_node
	_set_input.connect(connected_node._set_input)

func _process(delta):
	var input_cam = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	camera.rotation.y -= input_cam.x * delta
	var cam_vel = camera.global_transform.basis.z * input_cam.y * delta * 2
	camera.position += cam_vel
	
	#endregion
	input_movement(delta)
	cursorC_control(delta)
	if connected_node: global_transform = connected_node.global_transform
	_set_input.emit(target_position, input, acreq)
	

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
		acreq.append("run")
	if !input_dir:
		double_tap = 0

	#yesssss... small victory :)
	if !input_dir:
		acreq.erase("run")
	
	
	
	rotation.y = camera.rotation.y
	#var intent = (base_c.movement_c.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#base_c.movement_c.intent = intent
	#base_c.movement_c.direction = Vector3(input_dir.x, 0, input_dir.y)
	input = input_dir
	
func cursorC_control(delta):
	
	var offset = PI/2 + camera.rotation.y
	var screen_pos = camera.unproject_position(global_transform.origin)
	var mouse_pos = get_viewport().get_mouse_position()
	var angle = screen_pos.angle_to_point(mouse_pos)
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
		target_position = raycast_result.position
		#gunC.cursorC_place(raycast_result.position, atan2((gunC.global_position.x - cursorC.position.x), (gunC.global_position.z - cursorC.position.z)) + PI)
	if Input.is_action_just_pressed("left_mouse"):
		acreq.append("shoot")
	if Input.is_action_just_released("left_mouse"):
		acreq.erase("shoot")
	
	#var angle_facing = atan2((gunC.global_position.x - cursorC.position.x), (gunC.global_position.z - cursorC.position.z))
	#aimC.intent = angle_facing
	

func _on_double_tap_timeout():
	double_tap = 0
