extends Node3D 
class_name GapHelper
@onready var input_req: Marker3D = $InputReq
func get_input_req() -> Vector3: return input_req.global_position - global_position
