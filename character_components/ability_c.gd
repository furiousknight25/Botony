extends Node3D

@export var ability_1 : Ability
@export var ability_2 : Ability
@export var ability_3 : Ability

func activate_ability(ability_num : int): 
	match ability_num:
		1: if ability_1: ability_1.activate_ability()
		2: if ability_2: ability_2.activate_ability()
		2: if ability_3: ability_3.activate_ability()
