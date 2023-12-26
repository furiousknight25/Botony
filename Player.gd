extends CharacterBody3D
#im chosing the keep the player scene and script not in a folder because we will acess it a lot 
#ima create a state machine for the player, simmilar system to the enimies, they will call the movement_c.gd to control movement based on their special state machine

var fullscreen := false
var speed := 12
var rot_want 

@onready var movementC = $MovementC
var camera : Camera3D

func _ready():
	camera = get_tree().get_nodes_in_group("camera")[0]
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
	
	$velocity.position = position
	$accel.position = position
	$velocity.target_position = velocity
	$accel.target_position = movementC.global_transform.basis.z * delta * movementC.base_acceleration * 50
	
#endregion
	
	#move_and_slide() #might have to find the difference between the movement_c.gd's velocity and this one, subtract them and add it to this velocity so that the characterbody3d move and slide can act accordenliy rather than setting. 


func death():
	queue_free()

func _set_velocity(v, r):
	velocity = v
	rot_want = r
