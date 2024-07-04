extends ColorPicker



func _ready() -> void:
	color_changed.emit(color)
