extends HSlider


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	value_changed.emit(value)

