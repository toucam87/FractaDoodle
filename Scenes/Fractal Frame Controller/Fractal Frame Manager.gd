extends Control
class_name FractalFrameManager

@onready var drawing_manager: DrawingManager = $"../Canvas viewport Container/Canvas subviewport/Drawing Viewport Container/Drawing Viewport/DrawingManager"
@onready var drawing_viewport: SubViewport = $"../Canvas viewport Container/Canvas subviewport/Drawing Viewport Container/Drawing Viewport"
@onready var list_of_frames_container: VBoxContainer = $"../UI/MarginContainer/Main VBox container/Frames ScrollContainer/List of frames Container"


var fractal_frame_packed_scene = preload("res://Scenes/Fractal Frame Controller/Fractal Frame.tscn")
var fractal_frame_controller_packed_scene = preload("res://Scenes/Fractal Frame Controller/fractal_frame_controller.tscn")
var fractal_frame_UI_packed_scene = preload("res://Scenes/UI/fractal_frame_ui.tscn")
var frame_controllers := []
var selected_frame : FractalFrameController
var frame_index := 1
var previous_ff_state : FractalFrameData
var new_ff_state : FractalFrameData
signal fractal_frame_added(_frame : FractalFrameController)
signal fractal_frame_removed(_frame : FractalFrameController)
signal fractal_frame_modified(_frame : FractalFrameController, _previous_state : FractalFrameData, _new_state : FractalFrameData)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	drawing_manager.stroke_created.connect(_on_drawing)
	add_frame()

func _input(event: InputEvent) -> void:
	#deletes frame when del
	if event.is_action_pressed("delete") and selected_frame != null:
		#sends signal to history manager
		fractal_frame_removed.emit(selected_frame)
		remove_frame(selected_frame)



func add_frame():
	#adds the fractal frame and spawns it under the main viewport
	var new_fractal_frame = fractal_frame_packed_scene.instantiate() as FractalFrame
	new_fractal_frame.name = "fractal frame " + str(frame_index)
	drawing_viewport.add_child(new_fractal_frame)
	new_fractal_frame.setup_viewport(drawing_viewport)

	#adds the fractal frame into the UI
	var new_fractal_frame_UI = fractal_frame_UI_packed_scene.instantiate() as FractalFrameUI
	list_of_frames_container.add_child(new_fractal_frame_UI)
	new_fractal_frame_UI.name = "fractal frame UI " + str(frame_index)
	new_fractal_frame_UI.setup_label(frame_controllers.size() + 1)
	
	#adds the fractal frame controller under itself
	var new_fractal_frame_controller = fractal_frame_controller_packed_scene.instantiate() as FractalFrameController
	new_fractal_frame_controller.name = "fractal frame controller " + str(frame_index)
	add_child(new_fractal_frame_controller)
	#adds the controller to the list controlled by the frame manager
	frame_controllers.append(new_fractal_frame_controller)
	#connect to this manager
	new_fractal_frame_controller.frame_changed.connect(_on_frame_changed)
	new_fractal_frame_controller.frame_deletion_requested.connect(_on_frame_deletion_requested)
	new_fractal_frame_controller.frame_selection_requested.connect(_on_frame_selection_requested)
	new_fractal_frame_controller.frame_change_initiated.connect(_on_frame_change_initiated)
	new_fractal_frame_controller.frame_change_completed.connect(_on_frame_change_completed)
	#initializes the frame controller to connect to the frame
	new_fractal_frame_controller.initialize(drawing_viewport, new_fractal_frame, new_fractal_frame_UI)
	#sends signal to history manager
	fractal_frame_added.emit(new_fractal_frame_controller)
	
	#increment the frame index for next created frame
	frame_index += 1


func select_frame(_frame_controller : FractalFrameController):
	if selected_frame == _frame_controller:
		return
	if selected_frame != _frame_controller and selected_frame != null:
		deselect_frame(selected_frame)
	selected_frame = _frame_controller
	selected_frame.modulate = Color("b9b9b9")
	#make the UI buttons focus the correct frame
	selected_frame.fractal_frame_UI.frame_ui_label.grab_focus()


func deselect_frame(_frame_controller : FractalFrameController):
	if _frame_controller == null:
		return
	if _frame_controller == selected_frame:
		selected_frame = null
		_frame_controller.modulate = Color.WHITE
		_frame_controller.fractal_frame_UI.frame_ui_label.release_focus()


func remove_frame(_frame_controller : FractalFrameController):
	frame_controllers.erase(_frame_controller)
	_frame_controller.fractal_frame.visible = false
	_frame_controller.fractal_frame_UI.visible = false
	deselect_frame(_frame_controller)
	_frame_controller.visible = false
	

func undo_remove_frame(_frame_controller : FractalFrameController):
	frame_controllers.append(_frame_controller)
	_frame_controller.fractal_frame.visible = true
	_frame_controller.fractal_frame_UI.visible = true
	_frame_controller.visible = true


func delete_frame(_frame_controller : FractalFrameController):
	#remove the frame controller from the manager list if it still exists
	frame_controllers.erase(_frame_controller)
	deselect_frame(_frame_controller)
	_frame_controller.fractal_frame.queue_free()
	_frame_controller.fractal_frame_UI.queue_free()
	_frame_controller.queue_free()



func _on_add_frame_button_up() -> void:
	add_frame()


func _on_frame_opacity_h_slider_value_changed(value: float) -> void:
	for controller in frame_controllers:
		controller.fractal_frame.change_opacity(value)


func _on_frames_visible_toggle_toggled(toggled_on: bool) -> void:
	if toggled_on:
		for controller in frame_controllers:
			controller.visible = true
	if !toggled_on:
		for controller in frame_controllers:
			controller.visible = false

func _on_frame_changed(_emitter):
	if _emitter != selected_frame:
		deselect_frame(selected_frame)
		select_frame(_emitter)
		
func _on_frame_change_initiated(_emitter):
	var frame = _emitter as FractalFrameController
	previous_ff_state = FractalFrameData.new()
	previous_ff_state.ff_position = frame.position
	previous_ff_state.ff_size = frame.size
	previous_ff_state.ff_rotation = frame.rotation
	previous_ff_state.ff_horizontal_flip = frame.horizontally_flipped
	previous_ff_state.ff_vertical_flip = frame.vertically_flipped
	


func _on_frame_change_completed(_emitter):
	var frame = _emitter as FractalFrameController
	new_ff_state = FractalFrameData.new()
	new_ff_state.ff_position = frame.position
	new_ff_state.ff_size = frame.size
	new_ff_state.ff_rotation = frame.rotation
	new_ff_state.ff_horizontal_flip = frame.horizontally_flipped
	new_ff_state.ff_vertical_flip = frame.vertically_flipped
	#sends signal to history manager
	fractal_frame_modified.emit(frame, previous_ff_state, new_ff_state)


func _on_frame_deletion_requested(_emitter):
	remove_frame(_emitter)
	#sends signal to history manager
	fractal_frame_removed.emit(_emitter)
	
	
func _on_frame_selection_requested(_emitter):
	if selected_frame == _emitter:
		deselect_frame(_emitter)
		return
	if selected_frame != _emitter:
		select_frame(_emitter)
		

func _on_drawing(_stroke):
	deselect_frame(selected_frame)
