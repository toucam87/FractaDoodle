extends Control
class_name RecordingManager

@onready var canvas_viewport: SubViewport = $"../Canvas viewport Container/Canvas subviewport"
@onready var save_png_file_dialog: FileDialog = $SavePNGFileDialog





func canvas_as_png():
	return canvas_viewport.get_texture().get_image()
	

func create_file_name_by_date() -> String:
	var date_time = Time.get_datetime_string_from_system().replace(":", "-").replace("T", "_")
	var file_name = "FractaDoodle_" + date_time + ".png"
	return file_name



func _on_save_as_png_button_up() -> void:
	var default_name = create_file_name_by_date()
	save_png_file_dialog.current_file = default_name
	save_png_file_dialog.visible = true
	



func _on_save_png_file_dialog_file_selected(path: String) -> void:
	canvas_as_png().save_png(path)


