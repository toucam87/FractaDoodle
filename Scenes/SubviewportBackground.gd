class_name BackgroundColorPanel
extends Panel

var old_color := Color.WHITE
var new_color := Color.WHITE
signal background_color_changed(_panel : BackgroundColorPanel)


func _on_background_color_picker_button_color_changed(color: Color) -> void:
	modulate = color




func _on_background_color_picker_button_popup_closed() -> void:
	new_color = modulate
	background_color_changed.emit(self)
	


func _on_background_color_picker_button_button_down() -> void:
	old_color = modulate
