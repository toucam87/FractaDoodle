extends Control
class_name FractalFrameManager

@onready var drawing_manager: DrawingManager = $"../Main Viewport Container (drawing area)/main viewport/DrawingManager"
@onready var main_viewport: SubViewport = $"../Main Viewport Container (drawing area)/main viewport"
@onready var list_of_frames_container: VBoxContainer = $"../UI/MarginContainer/Main VBox container/Frames ScrollContainer/List of frames Container"

var fractal_frame_packed_scene = preload("res://Scenes/Fractal Frame Controller/Fractal Frame.tscn")
var fractal_frame_controller_packed_scene = preload("res://Scenes/Fractal Frame Controller/fractal_frame_controller.tscn")
var fractal_frame_UI_packed_scene = preload("res://Scenes/UI/frame_ui.tscn")
var frame_controllers := []
var selected_frame : FractalFrameController
var frame_index := 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	drawing_manager.stroke_created.connect(_on_drawing)
	add_frame()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("delete") and selected_frame != null:
		remove_frame(selected_frame)



func add_frame():
	#adds the fractal frame and spawns it under the main viewport
	var new_fractal_frame = fractal_frame_packed_scene.instantiate() as FractalFrame
	new_fractal_frame.name = "fractal frame " + str(frame_index)
	main_viewport.add_child(new_fractal_frame)
	new_fractal_frame.setup_viewport(main_viewport)

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
	new_fractal_frame_controller.frame_UI_deletion_requested.connect(_on_frame_deletion_requested)
	new_fractal_frame_controller.frame_UI_selection_requested.connect(_on_frame_UI_selection_requested)
	#initializes the frame controller to connect to the frame
	new_fractal_frame_controller.initialize(main_viewport, new_fractal_frame, new_fractal_frame_UI)
	
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
	_frame_controller.fractal_frame.visible = false
	_frame_controller.fractal_frame_UI.visible = false
	deselect_frame(_frame_controller)
	_frame_controller.visible = false
	
	




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

func _on_frame_deletion_requested(_emitter):
	remove_frame(_emitter)
	
func _on_frame_UI_selection_requested(_emitter):
	if selected_frame == _emitter:
		deselect_frame(_emitter)
		return
	if selected_frame != _emitter:
		select_frame(_emitter)
		

func _on_drawing(_stroke):
	deselect_frame(selected_frame)
