extends Control
class_name FractalFrameController


func _ready() -> void:
	resize(900)

func resize(_height):
	size.y = _height
	size.x = _height * 16 / 9

