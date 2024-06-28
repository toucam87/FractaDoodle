extends Control
class_name FractalFrameManager

@onready var drawing_manager: Node2D = $"../Main Viewport Container (drawing area)/main viewport/DrawingManager"
@onready var main_viewport: SubViewport = $"../Main Viewport Container (drawing area)/main viewport"

var fractal_frame_packed_scene = preload("res://Scenes/Fractal Frame Controller/Fractal Frame.tscn")
var fractal_frame_controller_packed_scene = preload("res://Scenes/Fractal Frame Controller/fractal_frame_controller.tscn")
@export var frame_controllers := []
@export var selected_frame : FractalFrameController

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_frame()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("delete") and selected_frame != null:
		remove_frame(selected_frame)



func add_frame():
	#adds the fractal frame and spawns it under the main viewport
	var new_fractal_frame = fractal_frame_packed_scene.instantiate() as FractalFrame
	new_fractal_frame.name = "fractal frame " + str(frame_controllers.size() + 1)
	main_viewport.add_child(new_fractal_frame)
	new_fractal_frame.setup_viewport(main_viewport)
	
	#adds the fractal frame controller under itself
	var new_fractal_frame_controller = fractal_frame_controller_packed_scene.instantiate() as FractalFrameController
	new_fractal_frame_controller.name = "fractal frame controller " + str(frame_controllers.size() + 1)
	add_child(new_fractal_frame_controller)
	#connect to this manager
	new_fractal_frame_controller.frame_changed.connect(_on_frame_changed)
	#initializes the frame controller to connect to the frame
	new_fractal_frame_controller.initialize(main_viewport, new_fractal_frame)

	#adds the controller to the list controlled by the frame manager
	frame_controllers.append(new_fractal_frame_controller)


func select_frame(_frame_controller : FractalFrameController):
	selected_frame = _frame_controller
	selected_frame.modulate = Color("b9b9b9")


func deselect_frame(_frame_controller : FractalFrameController):
	if _frame_controller == null:
		return
	if _frame_controller == selected_frame:
		selected_frame = null
		_frame_controller.modulate = Color.WHITE
	


func remove_frame(_frame_controller : FractalFrameController):
	_frame_controller.fractal_frame.visible = false
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


