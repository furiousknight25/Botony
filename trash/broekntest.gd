extends Node3D

var target_position = Vector3.ZERO
var input = Vector2.ZERO
var acreq = [] #action request
var connected_node = null
signal _set_input(target_position : Vector3, input : Vector2, acreq : Array)

var strategy = 'right'
func connect_to(connected_node):	
	if self.connected_node: self.disconnect("_set_input", self.connected_node._set_input)
	self.connected_node = connected_node
	_set_input.connect(connected_node._set_input)

func _process(delta: float) -> void:
	if strategy == 'right':
		input = Vector2(1,0)
	else:
		input = Vector2(-1,0)
	_set_input.emit(Vector3.ZERO, Vector2(-1,0), [])

func _on_timer_timeout() -> void:
	var coin_toss = randf_range(-1.0,1.0)
	
	if coin_toss > 0:
		strategy = 'right'
	else: 
		strategy = 'left'
		
