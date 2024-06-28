extends Control
class_name FractalFrameController

signal frame_changed(emitter : FractalFrameController)
@export var vertically_flipped := false
@export var horizontally_flipped := false
var selected := false
var fractal_frame : FractalFrame

func initialize(_viewport : SubViewport, _fractal_frame : FractalFrame):
	fractal_frame = _fractal_frame
	frame_changed.connect(fractal_frame._on_fractal_frame_controller_frame_changed)
	initialize_size(_viewport.size, 0.5)
	initialize_position(Vector2(450.0, 270.0))
	frame_changed.emit(self)



func initialize_size(_size : Vector2, _fraction : float):
	size = _size * _fraction


func initialize_position(_position : Vector2):
	var rand_x = randf_range(-300.0, 300.0)
	var rand_y = randf_range(-200.0, 200.0)
	position = _position + Vector2(rand_x, rand_y)


func change_size_to(_new_size : Vector2):
	size = _new_size
	frame_changed.emit(self)


func change_position_to(_new_pos : Vector2):
	position = _new_pos
	frame_changed.emit(self)

func change_rotation_to(_new_rot : float):
	rotation = _new_rot
	frame_changed.emit(self)

func flip_vertically():
	vertically_flipped = !vertically_flipped
	frame_changed.emit(self)

func flip_horizontally():
	horizontally_flipped = !horizontally_flipped
	frame_changed.emit(self)


