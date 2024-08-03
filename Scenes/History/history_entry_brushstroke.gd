class_name HistoryEntryBrushstroke
extends HistoryEntry


func undo_action():
	undone = true
	object.visible = false

func redo_action():
	undone = false
	object.visible = true

func delete_action():
	var stroke = object as Stroke
	stroke.self_destruct()
