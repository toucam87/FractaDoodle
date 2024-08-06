class_name HistoryEntryClearStrokes
extends HistoryEntry


func undo_action():
	undone = true
	var drawing_manager = manager as DrawingManager
	drawing_manager.undo_clear_paint(object)


func redo_action():
	undone = false
	var drawing_manager = manager as DrawingManager
	drawing_manager.clear_paint(object)


func delete_action():
	pass
