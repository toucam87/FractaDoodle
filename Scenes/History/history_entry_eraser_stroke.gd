class_name HistoryEntryEraserStroke
extends HistoryEntry

var points
var empty_points = []

func undo_action():
	undone = true
	var eraser_stroke = object as Stroke
	eraser_stroke.eraser_data.update_points(empty_points)

func redo_action():
	undone = false
	var eraser_stroke = object as Stroke
	eraser_stroke.eraser_data.update_points(points)



func delete_action():
	var eraser_stroke = object as Stroke
	for line in eraser_stroke.eraser_lines:
		line.queue_free()
	eraser_stroke.queue_free()
