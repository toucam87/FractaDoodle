class_name HistoryEntryChangeFrame
extends HistoryEntry

var previous_state : FractalFrameData
var new_state : FractalFrameData


func undo_action():
	undone = true
	var ff_manager = manager as FractalFrameManager
	var ff = object as FractalFrameController
	ff.change_to_state(previous_state)
	

func redo_action():
	undone = false
	var ff_manager = manager as FractalFrameManager
	var ff = object as FractalFrameController
	ff.change_to_state(new_state)


func delete_action():
	var ff_manager = manager as FractalFrameManager
	var ff = object as FractalFrameController
	pass
