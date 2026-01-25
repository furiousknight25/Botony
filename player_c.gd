extends Node3D
#im chosing the keep the player scene and script not in a folder because we will acess it a lot 

@onready var camera : Camera3D = get_tree().get_nodes_in_group("camera")[0]
@onready var double_tap_timer = $DoubleTap
var target_position = Vector3.ZERO
var input = Vector2.ZERO
var acreq = [] #action request

var connected_node : BaseC
signal _set_input(target_position : Vector3, input : Vector2, acreq : String)

func connect_to(connected_node):
	if self.connected_node: 
		_set_input.emit(target_position, input, ["disconnect"])
		self.disconnect("_set_input", self.connected_node._set_input)
	self.connected_node = connected_node
	_set_input.connect(connected_node._set_input)


func _process(delta):
	
	input_movement(delta)
	action_input()
	cursorC_control(delta)
	if connected_node: global_transform = connected_node.global_transform
	_set_input.emit(target_position, input, acreq) #emit all data to controller

func action_input(): #top level, only allow one action

	if Input.is_action_just_pressed("action_1"):
		acreq.append("action_1")
	if Input.is_action_just_pressed("action_2"):
		acreq.append("action_2")
	if Input.is_action_just_pressed("action_3"):
		acreq.append("action_3")
	if Input.is_action_just_pressed("left_mouse"):
		acreq.append("hold_shoot")
	elif Input.is_action_just_released('left_mouse'):
		acreq.append("release_shoot")
	
var old_input 
var double_tap = 0
func input_movement(delta): #region Input movement perhaps add can press button to prevent these states, like in deploy	
	rotation.y = camera.rotation.y
	
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	input_dir = camera_relativity_translator(input_dir)
	
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
	
	input = input_dir

func camera_relativity_translator(inpu : Vector2) -> Vector2: #converts camera relativity to player controls
	var cam_xform = camera.global_transform 
	#    Get the camera's "forward" and "right" directions
	#    We project on a plane to ignore the camera's up/down tilt.
	var forward = -cam_xform.basis.z.slide(Vector3.UP).normalized()
	var right = cam_xform.basis.x.slide(Vector3.UP).normalized()
	
	# 4. Combine input and camera directions to get the final world-space direction
	#    (forward * -input_vec.y) is the key.
	#    "forward" (y=-1) becomes (forward * 1.0)
	#    "backward" (y=1) becomes (forward * -1.0)
	var direction_3d = (right * inpu.x) + (forward * -inpu.y)
	
	# 5. Store the result as the 2D vector your BaseC script expects
	#    This new 'input' has the correct world-space direction.
	inpu = Vector2(direction_3d.x, direction_3d.z)
	
	return inpu
	
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
