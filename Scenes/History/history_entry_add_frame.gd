class_name HistoryEntryAddFrame
extends HistoryEntry


func undo_action():
	undone = true
	var ff_manager = manager as FractalFrameManager
	var ff = object as FractalFrameController
	ff_manager.remove_frame(ff)
	

func redo_action():
	undone = false
	var ff_manager = manager as FractalFrameManager
	var ff = object as FractalFrameController
	ff_manager.undo_remove_frame(ff)


func delete_action():
	var ff_manager = manager as FractalFrameManager
	var ff = object as FractalFrameController
	ff_manager.delete_frame(ff)
