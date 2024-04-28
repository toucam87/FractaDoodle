extends Node2D

var points_to_paint = []


func _draw() -> void:
	for i in points_to_paint.size():
		draw_circle(points_to_paint[i], 10, Color.BLACK)
		


func _input(event: InputEvent) -> void:
	if Mouse.left_click_pressed:
		points_to_paint.append(Mouse.mouse_pos)
		queue_redraw()
		print("mouse button pressed " + str(Mouse.mouse_pos))
	
