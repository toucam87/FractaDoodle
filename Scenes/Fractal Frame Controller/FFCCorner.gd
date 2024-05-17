extends Panel

#Corner is a global enum in godot
@export var corner_enum : Corner
@onready var fractal_frame_controller = $"../.." as FractalFrameController

@export var is_dragging = false

@export var frame_start_position : Vector2
@export var frame_start_angle : float
@export var frame_start_size : Vector2

@export var corner_start_local_position : Vector2
@export var frame_start_local_diagonal : Vector2
@export var local_pivot_point := Vector2(0,0) 

@export var start_drag_position : Vector2
@export var canvas_mouse_pos : Vector2
@export var drag_canvas_translation : Vector2
@export var drag_local_translation : Vector2
@export var drag_local_position_from_pivot : Vector2

@export var translation_vector : Vector2

@export var rotation_angle : float
@export var scale_factor : float

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left click"):
		is_dragging = true
		start_drag_position = Mouse.mouse_pos
		frame_start_position = fractal_frame_controller.position
		frame_start_angle = fractal_frame_controller.rotation
		frame_start_size = fractal_frame_controller.size
		calculate_corner_local_position()
		calculate_local_pivot_point()
		calculate_local_diagonal()
		
	if event.is_action_released("left click"):
		is_dragging = false

	
	

func _process(delta: float) -> void:
	if is_dragging:
		canvas_mouse_pos = Mouse.mouse_pos
		#measure the vector from pivot to mouse position 
		calculate_drag_local_position_from_pivot()
		calculate_rotation()
		calculate_scale_factor()
		resize_and_rotate_frame(local_pivot_point, rotation_angle, scale_factor)


func calculate_corner_local_position():
	match corner_enum:
		CORNER_TOP_LEFT:
			corner_start_local_position = Vector2(0,0)
		CORNER_TOP_RIGHT:
			corner_start_local_position = Vector2(fractal_frame_controller.size.x,0)
		CORNER_BOTTOM_LEFT:
			corner_start_local_position = Vector2(0,fractal_frame_controller.size.y)
		CORNER_BOTTOM_RIGHT:
			corner_start_local_position = Vector2(fractal_frame_controller.size.x,fractal_frame_controller.size.y)
	#print("corner " + str(corner_start_local_position))

func calculate_local_pivot_point():
	match corner_enum:
		CORNER_TOP_LEFT:
			local_pivot_point = Vector2(fractal_frame_controller.size.x,fractal_frame_controller.size.y)
		CORNER_TOP_RIGHT:
			local_pivot_point = Vector2(0,fractal_frame_controller.size.y)
		CORNER_BOTTOM_LEFT:
			local_pivot_point = Vector2(fractal_frame_controller.size.x,0)
		CORNER_BOTTOM_RIGHT:
			local_pivot_point = Vector2(0,0)
	#print("pivot " + str(local_pivot_point))

#FIXTHIS 
func calculate_drag_local_position_from_pivot():
	drag_canvas_translation = canvas_mouse_pos - start_drag_position
	drag_local_translation = drag_canvas_translation.rotated(- frame_start_angle)
	drag_local_position_from_pivot = frame_start_local_diagonal + drag_local_translation



func calculate_local_diagonal():
	frame_start_local_diagonal = (corner_start_local_position - local_pivot_point) 

	
	
func calculate_rotation():
	rotation_angle = frame_start_local_diagonal.angle_to(drag_local_position_from_pivot) 




func calculate_scale_factor():
	scale_factor = drag_local_position_from_pivot.length() / frame_start_local_diagonal.length()



func resize_and_rotate_frame(_pivot: Vector2, _angle : float, _scale: float):
	#rotate frame
	fractal_frame_controller.change_rotation_to(frame_start_angle + _angle)
	#translate frame according to which corner was pulled // this translation only takes into account rotation
	#holy shit these formulas were hard to find, but good trig and geometry skills... ugh.
	var new_fractal_frame_position = fractal_frame_controller.position
	translation_vector = Vector2(0,0)
	match corner_enum:
		CORNER_TOP_LEFT:
			translation_vector = (-frame_start_local_diagonal + frame_start_local_diagonal.rotated(_angle)).rotated(frame_start_angle)
			new_fractal_frame_position = frame_start_position + translation_vector
			fractal_frame_controller.change_position_to(new_fractal_frame_position)
		CORNER_TOP_RIGHT:
			translation_vector = Vector2(_pivot.length() *(sin(_angle)), _pivot.length() * (1.0 - cos(_angle))).rotated(frame_start_angle)
			new_fractal_frame_position = frame_start_position + translation_vector
			fractal_frame_controller.change_position_to(new_fractal_frame_position)
		CORNER_BOTTOM_LEFT:
			translation_vector = Vector2(_pivot.length() *(1.0 - cos(_angle)), - _pivot.length() * sin(_angle)).rotated(frame_start_angle)
			new_fractal_frame_position = frame_start_position + translation_vector
			fractal_frame_controller.change_position_to(new_fractal_frame_position)
		CORNER_BOTTOM_RIGHT:
			pass
		
	#scale frame
	fractal_frame_controller.change_size_to(frame_start_size * _scale)
	#translation due to resizing
	translation_vector = Vector2(0,0)
	match corner_enum:
		CORNER_TOP_LEFT:
			translation_vector = Vector2(_pivot.x * (1 - _scale), _pivot.y * (1 - _scale)).rotated(_angle).rotated(frame_start_angle)
			new_fractal_frame_position += translation_vector
			fractal_frame_controller.change_position_to(new_fractal_frame_position)
		CORNER_TOP_RIGHT:
			translation_vector = Vector2(0, _pivot.y * (1 - _scale)).rotated(_angle).rotated(frame_start_angle)
			new_fractal_frame_position += + translation_vector
			fractal_frame_controller.change_position_to(new_fractal_frame_position)
		CORNER_BOTTOM_LEFT:
			translation_vector = Vector2(_pivot.x * (1 - _scale), 0).rotated(_angle).rotated(frame_start_angle)
			new_fractal_frame_position += translation_vector
			fractal_frame_controller.change_position_to(new_fractal_frame_position)
		CORNER_BOTTOM_RIGHT:
			pass
	
	
