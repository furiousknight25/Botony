extends Node
# could do a dictionary of people


func _ready() -> void:
	return
	$PlayerC.connect_to($Nod1)

func _process(delta: float) -> void:
	pass
	
	if Input.is_action_just_pressed("action_1"):
		$PlayerC.connect_to($Nod1) #TODO make a better way to controll connecting these
		
	if Input.is_action_just_pressed("action_2"):
		$PlayerC.connect_to($Nod2)
