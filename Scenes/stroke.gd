extends Node2D
class_name Stroke


var control_points : PackedVector2Array
@export var curve : Curve2D
var points_to_draw : PackedVector2Array
var color = Color.BLACK
var thickness = 2
var opacity = 1.0
var is_painting = true
var varying_thicknesses := {}
var max_velocity = 500.0
var min_thickness_percent = 0.3

func _ready() -> void:
	curve = Curve2D.new()


func configurate(_color : Color, _thickness : float, _opacity : float):
	thickness = _thickness
	color = _color
	opacity = _opacity
	modulate = Color(Color.WHITE, opacity)
	control_points.append(Mouse.mouse_pos)
	calculate_bezier_curve(control_points)
	

func _input(event: InputEvent) -> void:
	if (Mouse.left_click_pressed or Mouse.right_click_pressed) and is_painting:
			control_points.append(Mouse.mouse_pos)
			calculate_bezier_curve(control_points)
			queue_redraw()
			

func _draw() -> void:
	#draw_polyline(points_to_draw, color, thickness*2 , true)
	#TODO try to use line2D with round edges and transitions instead of polyline, might solve my alpha problem too.
	
	#it makes for a smoother paint experience to draw circles instead of polylines. Somehow I couldn't get the polyline to not look like a bunch of straight lines
	#with jagged edges and corners. The circles makes it look smooth
	#for i in points_to_draw.size():
	#	draw_circle(points_to_draw[i], thickness, color)
	
	#drawing circles with varying thicknesses
	for i in points_to_draw.size():
		draw_circle(points_to_draw[i], varying_thicknesses[points_to_draw[i]], color)
	
	# drawing just the control points
	#for i in control_points.size():
	#	draw_circle(control_points[i], varying_thicknesses[control_points[i]], Color.BLACK)
	
	pass
	


func calculate_bezier_curve(_points : PackedVector2Array):
	#reinitialize the curve and the thicknesses since this is going to be called every frame when the mouse is moving
	curve.clear_points()
	varying_thicknesses.clear()
	#fill in the control points in the curve
	for i in control_points.size():
		curve.add_point(control_points[i])
		print("control point index " + str(i))
	#initialize the first and last point with the base thickness (in case there are fewer than 3 points total)	
	varying_thicknesses[control_points[0]] = thickness
	varying_thicknesses[control_points[control_points.size() - 1]] = thickness
	
	#in most cases there are more than 3 mouse points:
	if curve.point_count > 2:
		#change the handles of the in between points
		#to do this, I find the point right before and right after and create a vector between them.
		#I then set the handle nodes to be proportional to the ratio of how far I am from the previous point and next point.
		for i in range(1, curve.point_count - 1):
			var from_previous_to_next = curve.get_point_position(i+1) - curve.get_point_position(i-1)
			var distance_to_previous = curve.get_point_position(i).distance_to(curve.get_point_position(i-1))
			var distance_to_next = curve.get_point_position(i).distance_to(curve.get_point_position(i+1))
			var ratio_to_previous = distance_to_previous / ( distance_to_previous + distance_to_next)
			var ratio_to_next = distance_to_next / ( distance_to_previous + distance_to_next)
			curve.set_point_in(i, - ratio_to_previous * from_previous_to_next / 2.0)
			curve.set_point_out(i, ratio_to_next * from_previous_to_next / 2.0)
			#calculate varying thickness and store value in dictionary
			calculate_control_point_thickness(curve.get_point_position(i), distance_to_previous, distance_to_next)
		#I recalculate the velocity for the first and last point, they don't have to be stuck at the max thickness.
		calculate_control_point_thickness(curve.get_point_position(0),
		 curve.get_point_position(0).distance_to(curve.get_point_position(1)),
		 curve.get_point_position(0).distance_to(curve.get_point_position(1)))
		calculate_control_point_thickness(curve.get_point_position(curve.point_count - 1),
		 curve.get_point_position(curve.point_count - 1).distance_to(curve.get_point_position(curve.point_count - 2)),
		 curve.get_point_position(curve.point_count - 1).distance_to(curve.get_point_position(curve.point_count - 2)))
	#I linear extrapolate the thicknesses for the baked points in between the control points of the bezier curve
	extrapolate_control_points()


func calculate_control_point_thickness(_point : Vector2, _distance_to_previous, _distance_to_next):
	var new_thickness = thickness * (1 - clamp(_distance_to_previous + _distance_to_next, 0, max_velocity) / max_velocity )
	#clamping to make sure there's always a minimum thickness and the line doesn't just disappear
	new_thickness = clamp(new_thickness, thickness * min_thickness_percent, thickness)
	varying_thicknesses[_point] = new_thickness
	
#FIXME so many error messages. there are problems with bounds. pretty sure it comes from this function sometimes not extrapolating right before the end.
func extrapolate_control_points():
	points_to_draw = curve.get_baked_points()
	for i in curve.point_count - 1:
		var index1 = points_to_draw.bsearch(curve.get_point_position(i))
		var index2 = points_to_draw.bsearch(curve.get_point_position(i+1))
		print(index1)
		print(index2)
		for t in range(index1 + 1, index2):
			varying_thicknesses[points_to_draw[t]] = lerp(varying_thicknesses[points_to_draw[index1]],
			 varying_thicknesses[points_to_draw[index2]],
			 1.0 * (t - index1) / (index2 - index1))
	
	
