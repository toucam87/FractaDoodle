extends Panel



@onready var fractal_frame_controller = $"../.." as FractalFrameController
@export var side_enum : Side


var is_dragging = false
var current_drag_position : Vector2
var start_drag_position : Vector2
var frame_start_position : Vector2


func _gui_input(event: InputEvent) -> void:
	#when I left click on borders, it records the starting state
	if event.is_action_pressed("left click"):
		is_dragging = true
		start_drag_position = Mouse.mouse_pos
		frame_start_position = fractal_frame_controller.position
		#sends signal to manager
		fractal_frame_controller.frame_change_initiated.emit(fractal_frame_controller)
	
	if event.is_action_released("left click") and is_dragging:
		is_dragging = false
		#sends signal to manager
		fractal_frame_controller.frame_change_completed.emit(fractal_frame_controller)
		

	if event.is_action_released("right click"):
		fractal_frame_controller.frame_change_initiated.emit(fractal_frame_controller)
		match side_enum:
			SIDE_LEFT:
				fractal_frame_controller.flip_horizontally()
			SIDE_RIGHT:
				fractal_frame_controller.flip_horizontally()
			SIDE_TOP:
				fractal_frame_controller.flip_vertically()
			SIDE_BOTTOM:
				fractal_frame_controller.flip_vertically()
		fractal_frame_controller.frame_change_completed.emit(fractal_frame_controller)
	

func _process(_delta: float) -> void:
	if is_dragging:
		current_drag_position = Mouse.mouse_pos
		#translates to new location according to displacement
		fractal_frame_controller.change_position_to(frame_start_position + current_drag_position - start_drag_position)
		
