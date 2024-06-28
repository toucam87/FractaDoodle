extends CheckButton


func _ready() -> void:
	toggled.emit(toggle_mode)

