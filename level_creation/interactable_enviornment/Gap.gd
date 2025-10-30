extends Area3D
class_name Gap

@export var connections : Array[Gap]


signal _set_gap_data (pos : Vector3, velocity: Vector3, acreq : Array)
 #might want to add animation requests here too
 #and final rotation?

#perhaps have a requirement to select one?
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
var g = ProjectSettings.get_setting("physics/3d/default_gravity")


func _process(delta: float) -> void:
	calc_traj(delta)
	emit_signal("_set_gap_data", velocity, direction, acreq) #might want to wait untill someone is connected

func _on_body_entered(body: BaseC) -> void:
	_set_gap_data.connect(body._set_modified_input)
	acreq = ['enter_gap']
	t = 1.0
	d = connections[0].global_position - body.global_position
	
	velocity = (d / t) - (0.5 * g * t)

func _on_body_exited(body: Node3D) -> void:
	acreq = ['leave_gap']
	_set_gap_data.disconnect(body._set_modified_input)

func calc_traj(delta):
	velocity.y -= gravity
