extends Label



func _on_opacity_h_slider_value_changed(value: float) -> void:
	text = str(value * 100.0) + " %"

