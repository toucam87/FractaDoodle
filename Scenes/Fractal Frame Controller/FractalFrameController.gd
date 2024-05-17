extends Control
class_name FractalFrameController

#TODO remove this when everything is working as expected
@export var angles_in_rad : float

func _ready() -> void:
	resize(450)

func resize(_height):
	size.y = _height
	size.x = _height * 16 / 9

func _process(delta: float) -> void:
	#TODO remove this when everything is working as expected
	angles_in_rad = rotation
