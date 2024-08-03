extends Control


@onready var drawing_manager: DrawingManager = $"../Canvas viewport Container/Canvas subviewport/Drawing Viewport Container/Drawing Viewport/DrawingManager"

@export var history : Array[HistoryEntry] = []
#index is initialized at -1 to indicate that there is no action yet, 0 will be the first index of the list
@export var active_index := -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	drawing_manager.brush_stroke_completed.connect(_on_brushstroke_completed)

func add_history_entry(_entry : HistoryEntry):
	if active_index < history.size() - 1:
		#delete all undone actions after the cutoff
		for i in range(active_index + 1, history.size()):
			history[i].delete_action()
		#deletes all undone actions from the history list
		history.resize(active_index + 1)
	#adds the new action to the history
	history.append(_entry)
	active_index += 1



func _on_reset_all_button_up() -> void:
	get_tree().reload_current_scene()

func _on_brushstroke_completed(_stroke):
	print("brushstroke completed: " + _stroke.name)
	#creates a brushstroke history entry
	var brushstroke_entry = HistoryEntryBrushstroke.new()
	brushstroke_entry.object = _stroke
	add_history_entry(brushstroke_entry)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("undo"):
		_on_undo_button_up()
	if event.is_action_pressed("redo"):
		_on_redo_button_up()

func _on_undo_button_up() -> void:
	if active_index >= 0:
		history[active_index].undo_action()
		active_index -= 1
	else:
		print("no action to undo")

func _on_redo_button_up() -> void:
	if active_index + 1 <= history.size() - 1:
		active_index += 1
		history[active_index].redo_action()
	else:
		print("no action to redo")
