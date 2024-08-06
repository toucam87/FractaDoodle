extends Control


@onready var drawing_manager: DrawingManager = $"../Canvas viewport Container/Canvas subviewport/Drawing Viewport Container/Drawing Viewport/DrawingManager"
@onready var fractal_frame_manager: FractalFrameManager = $"../Fractal Frame Manager"
@onready var subviewport_background: BackgroundColorPanel = $"../Canvas viewport Container/Canvas subviewport/SubviewportBackground"


@export var history : Array[HistoryEntry] = []
#index is initialized at -1 to indicate that there is no action yet, 0 will be the first index of the list
@export var active_index := -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	drawing_manager.brush_stroke_completed.connect(_on_brushstroke_completed)
	drawing_manager.eraser_stroke_completed.connect(_on_eraser_stroke_completed)
	drawing_manager.paint_cleared.connect(_on_clear_paint)
	fractal_frame_manager.fractal_frame_added.connect(_on_fractal_frame_added)
	fractal_frame_manager.fractal_frame_removed.connect(_on_fractal_frame_removed)
	fractal_frame_manager.fractal_frame_modified.connect(_on_fractal_frame_modified)
	subviewport_background.background_color_changed.connect(_on_background_color_changed)


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

func _on_brushstroke_completed(_stroke : Stroke):
	#creates a brushstroke history entry
	var brushstroke_entry = HistoryEntryBrushstroke.new()
	brushstroke_entry.object = _stroke
	brushstroke_entry.manager = drawing_manager
	add_history_entry(brushstroke_entry)

func _on_eraser_stroke_completed(_eraser_stroke : Stroke):
	#creates a eraser stroke history entry
	var eraser_entry = HistoryEntryEraserStroke.new()
	eraser_entry.object = _eraser_stroke
	eraser_entry.manager = drawing_manager
	eraser_entry.points = _eraser_stroke.eraser_data.points
	add_history_entry(eraser_entry)


func _on_fractal_frame_added(_frame_controller : FractalFrameController):
	#creates a add frame entry
	var add_fractal_frame_entry = HistoryEntryAddFrame.new()
	add_fractal_frame_entry.object = _frame_controller
	add_fractal_frame_entry.manager = fractal_frame_manager
	add_history_entry(add_fractal_frame_entry)
	

func _on_fractal_frame_removed(_frame_controller : FractalFrameController):
	#creates a remove frame entry
	var remove_fractal_frame_entry = HistoryEntryRemoveFrame.new()
	remove_fractal_frame_entry.object = _frame_controller
	remove_fractal_frame_entry.manager = fractal_frame_manager
	add_history_entry(remove_fractal_frame_entry)

func _on_clear_paint(_strokes_to_clear : Array):
	var clear_entry = HistoryEntryClearStrokes.new()
	clear_entry.manager = drawing_manager
	clear_entry.object = _strokes_to_clear
	add_history_entry(clear_entry)

func _on_fractal_frame_modified(_frame_controller : FractalFrameController, _previous_state : FractalFrameData, _new_state : FractalFrameData):
	#creates a remove frame entry
	var change_fractal_frame_entry = HistoryEntryChangeFrame.new()
	change_fractal_frame_entry.object = _frame_controller
	change_fractal_frame_entry.manager = fractal_frame_manager
	change_fractal_frame_entry.previous_state = _previous_state
	change_fractal_frame_entry.new_state = _new_state
	add_history_entry(change_fractal_frame_entry)

func _on_background_color_changed(_background : BackgroundColorPanel):
	#creates a change background entry
	var change_background_entry = HistoryEntryChangeBackgroundColor.new()
	change_background_entry.object = _background
	change_background_entry.previous_color = _background.old_color
	change_background_entry.new_color = _background.new_color
	add_history_entry(change_background_entry)


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
