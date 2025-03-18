extends Node
# could do a dictionary of people
signal send_node(node)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("action_1"):
		#$PlayerC.connect_to($PlayerC.get_path_to($Nod1))
		#send_node.emit($Nod1)
		pass
		
	if Input.is_action_just_pressed("action_2"):
		print($Nod2)
		#$PlayerC.connect_to($Nod2)
