extends Node
# could do a dictionary of people

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("action_1"):
		$PlayerC.connect_to($Nod1)
		
	if Input.is_action_just_pressed("action_2"):
		$AIC.connect_to($Nod2)
