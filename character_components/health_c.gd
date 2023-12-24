extends Node3D
class_name health_c

signal death 

@export var MAX_HEALTH : float
var health : float

func _ready():
	health = MAX_HEALTH

func change_h(amount):
	health += amount
	
	if health <= 0:
		emit_signal('death')

