class_name AbilityC extends Node3D

@onready var baseC: CharacterBody3D = get_parent()

@export var ability_1 : Ability
@export var ability_2 : Ability
@export var ability_3 : Ability

func activate_ability(ability_num : int): 
	match ability_num:
		1: if ability_1: ability_1.activate_ability()
		2: if ability_2: ability_2.activate_ability()
		2: if ability_3: ability_3.activate_ability()


func set_input(pos : Vector3, dir : Vector2, acreq : Array):
	for i in get_children():
		i.target_position = pos
		i.input_dir = dir
		i.acreq = acreq

func set_m_input(pos : Vector3, dir : Vector2, acreq : Array):
	baseC._set_modified_input(pos, dir, acreq)
