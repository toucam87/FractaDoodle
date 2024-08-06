class_name HistoryEntryChangeBackgroundColor
extends HistoryEntry

var previous_color : Color
var new_color : Color

func undo_action():
	undone = true
	var background = object as BackgroundColorPanel
	background.modulate = previous_color

func redo_action():
	undone = false
	var background = object as BackgroundColorPanel
	background.modulate = new_color

func delete_action():
	pass
