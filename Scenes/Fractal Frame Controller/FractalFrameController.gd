extends Control
class_name FractalFrameController

signal frame_changed(emitter : FractalFrameController)
signal frame_change_initiated(emitter: FractalFrameController)
signal frame_change_completed(emitter: FractalFrameController)
signal frame_deletion_requested(emitter : FractalFrameController)
signal frame_selection_requested(emitter : FractalFrameController)
@export var vertically_flipped := false
@export var horizontally_flipped := false
var selected := false
var fractal_frame : FractalFrame
var fractal_frame_UI : FractalFrameUI

func initialize(_viewport : SubViewport, _fractal_frame : FractalFrame, _fractal_frame_UI : FractalFrameUI):
	fractal_frame = _fractal_frame
	fractal_frame_UI = _fractal_frame_UI
	#connects the UI buttons
	fractal_frame_UI.frame_ui_label.button_up.connect(_on_frame_UI_label_button_up)
	fractal_frame_UI.frame_ui_delete_button.button_up.connect(_on_frame_UI_delete_button_up)
	#connects the frame controller to the actual graphic frame
	frame_changed.connect(fractal_frame._on_fractal_frame_controller_frame_changed)
	#initializes the frame controller and makes the graphic frame comform to it
	initialize_size(_viewport.size, 0.5)
	initialize_position(Vector2(450.0, 270.0))
	publish_change()


func publish_change():
	frame_changed.emit(self)
	


func initialize_size(_size : Vector2, _fraction : float):
	size = _size * _fraction


func initialize_position(_position : Vector2):
	var rand_x = randf_range(-300.0, 300.0)
	var rand_y = randf_range(-200.0, 200.0)
	position = _position + Vector2(rand_x, rand_y)


func change_size_to(_new_size : Vector2):
	size = _new_size
	publish_change()


func change_position_to(_new_pos : Vector2):
	position = _new_pos
	publish_change()

func change_rotation_to(_new_rot : float):
	rotation = _new_rot
	publish_change()

func flip_vertically():
	vertically_flipped = !vertically_flipped
	publish_change()

func flip_horizontally():
	horizontally_flipped = !horizontally_flipped
	publish_change()

func change_to_state(_state : FractalFrameData):
	position = _state.ff_position
	size = _state.ff_size
	rotation = _state.ff_rotation
	horizontally_flipped = _state.ff_horizontal_flip
	vertically_flipped = _state.ff_vertical_flip
	publish_change()
	


func _on_frame_UI_label_button_up():
	frame_selection_requested.emit(self)

func _on_frame_UI_delete_button_up():
	frame_deletion_requested.emit(self)


