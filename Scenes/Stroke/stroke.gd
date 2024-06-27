extends Node2D
class_name Stroke

@onready var graphics: Node2D = $"Stroke Subviewport Container/SubViewport/Graphics"
@onready var stroke_subviewport_container: SubViewportContainer = $"Stroke Subviewport Container"
@onready var sub_viewport: SubViewport = $"Stroke Subviewport Container/SubViewport"


var control_points : PackedVector2Array
@export var curve : Curve2D
var points_to_draw : PackedVector2Array
var color = Color.BLACK
var thickness = 2
var opacity = 1.0
var is_painting = true
var varying_thicknesses := {}
var max_velocity = 500.0
var min_thickness_percent = 0.6
var is_eraser := false
var eraser_data : EraserLineData
#signal sent whenever we are erasing, so that other strokes can listen to it
signal erasing(_sender : Stroke)




func _ready() -> void:
	curve = Curve2D.new()


func configurate(_color : Color, _thickness : float, _opacity : float, _main_viewport: SubViewport,  _eraser : bool = false):
	thickness = _thickness
	color = _color
	opacity = _opacity
	stroke_subviewport_container.modulate.a = opacity
	sub_viewport.size = _main_viewport.size
	control_points.append(Mouse.mouse_pos)
	calculate_bezier_curve()
	if _eraser == true:
		is_eraser = true
		#remove the antialias to prevent weird grey lines on the sides of the eraser
		sub_viewport.set_msaa_2d(0)
		#create a new eraser resource that all eraser strokes will use (one eraser stroke per existing non eraser stroke)
		eraser_data = EraserLineData.new()
		eraser_data.configurate(thickness, opacity, points_to_draw)

func _input(_event: InputEvent) -> void:
	if (Mouse.left_click_pressed or Mouse.right_click_pressed) and is_painting:
			control_points.append(Mouse.mouse_pos)
			calculate_bezier_curve()
			if is_eraser:
				eraser_data.update_points(points_to_draw)
			#queue_redraw()
			graphics.queue_redraw()
			

#func _draw() -> void:
	##drawing circles with varying thicknesses
	#for i in points_to_draw.size():
		#draw_circle(points_to_draw[i], varying_thicknesses[points_to_draw[i]], color)

	# drawing just the control points
	#for i in control_points.size():
		#draw_circle(control_points[i], varying_thicknesses[control_points[i]], Color.BLACK)
	

#TODO optimize so it doesn't recalculate everything every frame, since it's laggy
func calculate_bezier_curve():
	#reinitialize the curve and the thicknesses since this is going to be called every frame when the mouse is moving
	curve.clear_points()
	varying_thicknesses.clear()
	#initialize the bezier curve as the points of the mouse, without bezier in and out points
	for i in control_points.size():
		curve.add_point(control_points[i])
		#print("control point index " + str(i))
	
	#print("curve has " + str(curve.point_count) + " points")
	for i in curve.point_count:
		#first point
		if i == 0:
			#print("starting i == 0")
			#if curve has more than 1 point, we calculate thickness based on distance to second point
			if curve.point_count > 1:
				var distance_to_next = curve.get_point_position(i).distance_to(curve.get_point_position(i+1))
				calculate_control_point_thickness(curve.get_point_position(i), distance_to_next, distance_to_next)
			#special case where the curve has only one point
			else : calculate_control_point_thickness(curve.get_point_position(i), 0.0, 0.0)
		#middle points if there are more than 3 in total, we calculate thickness based on distance to previous and next
		if i > 0 and i < curve.point_count - 1:
			#print("middle i == " + str(i))
			var from_previous_to_next = curve.get_point_position(i+1) - curve.get_point_position(i-1)
			var distance_to_previous = curve.get_point_position(i).distance_to(curve.get_point_position(i-1))
			var distance_to_next = curve.get_point_position(i).distance_to(curve.get_point_position(i+1))
			var ratio_to_previous = distance_to_previous / ( distance_to_previous + distance_to_next)
			var ratio_to_next = distance_to_next / ( distance_to_previous + distance_to_next)
			curve.set_point_in(i, - ratio_to_previous * from_previous_to_next / 2.0)
			curve.set_point_out(i, ratio_to_next * from_previous_to_next / 2.0)
			calculate_control_point_thickness(curve.get_point_position(i), distance_to_previous, distance_to_next)
		#last point if there's more than 1
		if i == curve.point_count - 1 and curve.point_count > 1:
			#print("last i == " + str(i))
			var distance_to_previous = curve.get_point_position(i).distance_to(curve.get_point_position(i-1))
			calculate_control_point_thickness(curve.get_point_position(i),  distance_to_previous, distance_to_previous)
	
	#this function works as intended before interpolating between the points of the mouse position. everything is in order.
	
	#points_to_draw = control_points
	extrapolate_control_points()
	



func calculate_control_point_thickness(_point : Vector2, _distance_to_previous, _distance_to_next):
	var new_thickness = thickness * (1 - clamp(_distance_to_previous + _distance_to_next, 0, max_velocity) / max_velocity )
	#clamping to make sure there's always a minimum thickness and the line doesn't just disappear
	new_thickness = clamp(new_thickness, thickness * min_thickness_percent, thickness)
	varying_thicknesses[_point] = new_thickness



func extrapolate_control_points():
	points_to_draw = curve.get_baked_points()
	if curve.point_count > 1:
		for i in curve.point_count - 1:
			#I found out "find" is better than bsearch which returned weird values when the array was small size, not sure why though
			var index1 = points_to_draw.find(curve.get_point_position(i))
			var index2 = points_to_draw.find(curve.get_point_position(i+1))
			#print("i : " + str(i))
			#print("index1 : " + str(index1))
			#print("index2 : " + str(index2))
			for t in range(index1 + 1, index2):
				varying_thicknesses[points_to_draw[t]] = lerp(varying_thicknesses[points_to_draw[index1]],
				 varying_thicknesses[points_to_draw[index2]],
				 1.0 * (t - index1) / (index2 - index1))

#I call this function adopt, because it doesn't instantiate it, it just adds it as a child
func adopt_eraser_line(_eraser_line : EraserLine):
	sub_viewport.add_child(_eraser_line)


