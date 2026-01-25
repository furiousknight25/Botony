extends StaticBody3D

@onready var healthc: health_c = $HealthC
@onready var label_3d: Label3D = $Label3D
@onready var swinger: CollisionShape3D = $Swinger

func hit(damage: float, direction: Vector3):
	healthc.change_h(damage)
	label_3d.text = str(healthc.health)
	swinger.rotation += direction.normalized()

func _process(delta: float) -> void:
	swinger.rotation = swinger.rotation.lerp(Vector3.ZERO, delta * 12)
