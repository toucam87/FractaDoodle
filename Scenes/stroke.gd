extends Node2D
class_name Stroke


var mouse_points : PackedVector2Array
@export var curve : Curve2D
var points_to_draw : PackedVector2Array
var color = Color.BLACK
var thickness = 2
var opacity = 1.0
var is_painting = true



func configurate(_color : Color, _thickness : float, _opacity : float):
	thickness = _thickness
	color = _color
	opacity = _opacity
	modulate = Color(Color.WHITE, opacity)
	mouse_points.append(Mouse.mouse_pos)
	calculate_bezier_curve(mouse_points)

func _input(event: InputEvent) -> void:
	if (Mouse.left_click_pressed or Mouse.right_click_pressed) and is_painting:
			mouse_points.append(Mouse.mouse_pos)
			calculate_bezier_curve(mouse_points)
			queue_redraw()
			

func _draw() -> void:
	#draw_polyline(points_to_draw, Color.WEB_GREEN,24.0 , true)
	
	#it makes for a smoother paint experience to draw circles instead of polylines. Somehow I couldn't get the polyline to not look like a bunch of straight lines
	#with jagged edges and corners. The circles makes it look smooth (although not antialiased)
	for i in points_to_draw.size():
		draw_circle(points_to_draw[i], 12.0, Color.WEB_GREEN)
	
	#for i in mouse_points.size():
	#	draw_circle(mouse_points[i], 2.0, Color.BLACK)
	
	pass
	


func calculate_bezier_curve(_points : PackedVector2Array):
	curve.clear_points()
	for i in mouse_points.size():
		curve.add_point(mouse_points[i])
	if curve.point_count > 2:
		#change the control points of the in between points
		#to do this, I find the point right before and right after and create a vector between them.
		#I then set the control nodes to be proportional to the ratio of how far I am from the previous point and next point.
		#probably not "perfect" in terms of smooth line, but good enough for me to be satisfied.
		for i in curve.point_count - 2:
			var from_previous_to_next = curve.get_point_position(i+2) - curve.get_point_position(i)
			var distance_to_previous = curve.get_point_position(i+1).distance_to(curve.get_point_position(i))
			var distance_to_next = curve.get_point_position(i+1).distance_to(curve.get_point_position(i+2))
			var ratio_to_previous = distance_to_previous / ( distance_to_previous + distance_to_next)
			var ratio_to_next = distance_to_next / ( distance_to_previous + distance_to_next)
			curve.set_point_in(i+1, - ratio_to_previous * from_previous_to_next / 2.0)
			curve.set_point_out(i+1, ratio_to_next * from_previous_to_next / 2.0)
	
	#points_to_draw = curve.tessellate_even_length(7, 5.0)
	points_to_draw = curve.get_baked_points()

