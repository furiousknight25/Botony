extends Bullet


func fire(vel : Vector3, spe : float):
	on = true

func destroy_self():
	queue_free()
