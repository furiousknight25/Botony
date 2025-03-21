extends Node3D

var target_position = Vector3.ZERO
var input = Vector2.ZERO
var acreq = [] #action request
var connected_node = null
signal _set_input(target_position : Vector3, input : Vector2, acreq : Array)

func connect_to(connected_node):	
	if self.connected_node: self.disconnect("_set_input", self.connected_node._set_input)
	self.connected_node = connected_node
	_set_input.connect(connected_node._set_input)

func _process(delta: float) -> void:
	_set_input.emit(Vector3.ZERO, Vector2(-1,-1), ["run"])
	
	
	
