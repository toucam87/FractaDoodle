extends HBoxContainer
class_name FractalFrameUI

@onready var frame_ui_label: Button = $"Frame UI label"
@onready var frame_ui_delete_button: Button = $"Frame UI delete button"


func setup_label(index):
	frame_ui_label.text = "Fractal Frame #" + str(index)

