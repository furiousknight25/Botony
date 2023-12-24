extends CharacterBody3D
#im chosing the keep the player scene and script not in a folder because we will acess it a lot 
#ima create a state machine for the player, simmilar system to the enimies, they will call the movement_c.gd to control movement based on their special state machine


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func death():
	queue_free()
