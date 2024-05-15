extends Panel



@onready var fractal_frame_controller = $"../.." as FractalFrameController



var is_dragging = false
var current_drag_position : Vector2
var start_drag_position : Vector2
var frame_start_position : Vector2

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left click"):
		is_dragging = true
		start_drag_position = Mouse.mouse_pos
		frame_start_position = fractal_frame_controller.position
	if event.is_action_released("left click"):
		is_dragging = false

	
	

func _process(delta: float) -> void:
	if is_dragging:
		current_drag_position = Mouse.mouse_pos
		fractal_frame_controller.position = frame_start_position + current_drag_position - start_drag_position
