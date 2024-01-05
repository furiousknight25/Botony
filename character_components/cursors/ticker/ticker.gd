extends cursor

#four stages
var stage = 0


var length = 0.0
@onready var scale_start = scale.x

func cursor_prop():
	print(scale.x)
	var old_stage = stage
	stage = floor(3* distance)/3
	if stage != old_stage:
		if stage >= old_stage:
			$CurveTween2.play(.1, scale_start, scale_start + .001)
		if stage <= old_stage:
			$CurveTween2.play(.1, scale_start, scale_start - .001)
		$CurveTween.play(.1, length, stage)
		
	#print(length)
	animation.set('parameters/Blend2/blend_amount', length)
	#animation.set("parameters/Transition/transition_request", str(stage))

func _on_tween_curve_tween(sat):
	length = sat

func _on_curve_tween_2_curve_tween(sat):
	scale.x = sat
