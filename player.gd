extends CharacterBody3D
#im chosing the keep the player scene and script not in a folder because we will acess it a lot 

var fullscreen := false 

@onready var movementC = $MovementC
@onready var camera = get_tree().get_nodes_in_group("camera")[0]

func _ready():
	pass
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
	
#endregion
	
#region Input movement
	movementC.rotation.y = camera.rotation.y
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var intent = (movementC.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	movementC.intent = intent
	
	if intent: # this is jank and will not work long term
		movementC.cur_state = movementC.STATES.ACTIVE
	if !intent:
		movementC.cur_state = movementC.STATES.IDLE
	
	
#region debug devices
	$"Debug tools/velocity".position = position
	$"Debug tools/accel".position = position
	$"Debug tools/velocity".target_position = velocity
	$"Debug tools/accel".target_position = movementC.global_transform.basis.z * delta * movementC.base_acceleration * 50
#endregion
	
#endregion
	
	#print(velocity.dot(global_transform.basis.z))
func death():
	queue_free()

func _set_velocity(v, r):
	velocity = v
