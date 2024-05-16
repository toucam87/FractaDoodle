extends Panel

@onready var fractal_frame_controller = $"../.." as FractalFrameController

enum Corner {TOPLEFT, TOPRIGHT, BOTLEFT, BOTRIGHT}

var frame_start_position : Vector2
var frame_start_angle : float
var frame_start_height : float
var frame_start_diagonal : Vector2
var is_dragging = false
var start_drag_position : Vector2
var current_drag_position : Vector2
var drag_position_from_pivot : Vector2
var pivot_point := Vector2(0,0) 


func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left click"):
		is_dragging = true
		start_drag_position = Mouse.mouse_pos
		frame_start_position = fractal_frame_controller.position
		frame_start_angle = fractal_frame_controller.rotation
		frame_start_height = fractal_frame_controller.size.y
		calculate_diagonal()
		
	if event.is_action_released("left click"):
		is_dragging = false

	
	

func _process(delta: float) -> void:
	if is_dragging:
		current_drag_position = Mouse.mouse_pos
		#measure the vector from pivot to mouse position 
		calculate_drag_position_from_pivot()
		resize_and_rotate_frame(pivot_point, calculate_rotation(), calculate_scale_factor())


#TODO calculate from other pivots
func calculate_drag_position_from_pivot():
	drag_position_from_pivot = current_drag_position - frame_start_position


#TODO calculate diagonal for different pivots
func calculate_diagonal():
	frame_start_diagonal = Vector2(fractal_frame_controller.size.x,fractal_frame_controller.size.y).rotated(frame_start_angle)
	
	
func calculate_rotation() -> float:
	var rotation_angle = frame_start_diagonal.angle_to(drag_position_from_pivot) 
	return rotation_angle


func calculate_scale_factor() -> float:
	var scale_factor = drag_position_from_pivot.length() / frame_start_diagonal.length()
	return scale_factor


func resize_and_rotate_frame(_pivot, _angle, _scale):
	#rotate frame #TODO take pivot into account
	fractal_frame_controller.rotation = frame_start_angle + _angle
	#scale frame
	fractal_frame_controller.size.y = frame_start_height * _scale 
	fractal_frame_controller.size.x = fractal_frame_controller.size.y * 16.0 / 9.0
	
	
	#print(_pivot)
	print(_scale)

	
