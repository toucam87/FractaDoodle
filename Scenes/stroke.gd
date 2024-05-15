extends Node2D
class_name Stroke


var points_to_paint : PackedVector2Array
var color = Color.BLACK
var thickness = 10
var opacity = 1.0
var is_painting = true


func _input(event: InputEvent) -> void:
	if (Mouse.left_click_pressed or Mouse.right_click_pressed) and is_painting:
			points_to_paint.append(Mouse.mouse_pos)
			queue_redraw()
			

func _draw() -> void:
	for i in points_to_paint.size():
		draw_circle(points_to_paint[i], thickness, color)


	
func configurate(_color : Color, _thickness : float, _opacity : float):
	thickness = _thickness
	color = _color
	opacity = _opacity
	modulate = Color(Color.WHITE, opacity)
