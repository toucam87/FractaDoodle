extends Node2D


@onready var stroke: Stroke = $"../../.."



func _draw() -> void:
	#drawing circles with varying thicknesses
	for i in stroke.points_to_draw.size():
		#things used to get out of bound, I'm adding this as a safeguard
		if stroke.varying_thicknesses.has(stroke.points_to_draw[i]):
			draw_circle(stroke.points_to_draw[i], stroke.varying_thicknesses[stroke.points_to_draw[i]], stroke.color)
	
