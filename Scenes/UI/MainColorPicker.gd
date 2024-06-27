extends ColorPicker


#TODO have preset color palette in the picker
func _ready() -> void:
	color_changed.emit(color)
