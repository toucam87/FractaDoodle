extends Control
class_name FractalFrameController

signal frame_changed(emitter : FractalFrameController)
@export var vertically_flipped := false
@export var horizontally_flipped := false


func _ready() -> void:
	initialize_size(450)

func initialize_size(_height):
	size.y = _height
	size.x = _height * 16 / 9

#TODO deal with the scale factor compared to whole screen when sending signal to fractal frame
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
