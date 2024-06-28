extends Label




func _on_brush_size_h_slider_value_changed(value: float) -> void:
	text = str(value) + " px"


func _on_eraser_size_h_slider_value_changed(value: float) -> void:
	text = str(value) + " px"
